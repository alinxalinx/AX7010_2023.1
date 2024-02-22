/** ===================================================== **
 *Author : ALINX Electronic Technology (Shanghai) Co., Ltd.
 *Website: http://www.alinx.com
 *Address: Room 202, building 18, 
           No.518 xinbrick Road, 
           Songjiang District, Shanghai
 *Created: 2020-3-2 
 *Version: 1.0
 ** ===================================================== **/
 
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/device.h>
#include <linux/init.h>
#include <linux/cdev.h>
#include <linux/platform_device.h>
#include <linux/miscdevice.h>
#include <linux/ioport.h>
#include <linux/of.h>
#include <linux/uaccess.h>
#include <linux/interrupt.h>
#include <linux/of_irq.h>
#include <linux/irq.h>
#include <linux/timer.h>
#include <linux/dma-mapping.h>
#include <asm/io.h>
#include <asm/uaccess.h>
#include <asm/irq.h>
#include <asm/byteorder.h>

//驱动个数  
#define AX_DRV_CNT  1
//设备节点名称
#define AX_DRV_NAME "ax_dma"

//AMBA总线时钟使能
#define DMA_CLKEN_ADDR          0xF800012C
volatile u32   * clken;

//基地址
#define DMA_BASE_ADDR           0xF8003000

//DBGSTATUS
#define DMA_DBGSTATUS_OFFSET    0x00000D00
volatile u32   * dbgstatus;

//DBGCMD
#define DMA_DBGCMD_OFFSET       0x00000D04
volatile u32   * dbgcmd;

//DBGINST0
#define DMA_DBGINST0_OFFSET     0x00000D08
volatile u32   * dbginst0;

//DBGINST1
#define DMA_DBGINST1_OFFSET     0x00000D0C
volatile u32   * dbginst1;

//cache
#define DMA_CACH_OFFSET         0x00000E04
volatile u32   * cache;

//DMA中断使能
#define DMA_IRQ_EN_OFFSET       0x00000020
volatile u32   * irqen;

//DMA中断清除
#define DMA_IRQ_CLR_OFFSET      0x0000002C
volatile u32   * irqclr;


//指令集
#define CMD_DMAADDH     0x54
#define CMD_DMAEND      0x00
#define CMD_DMAFLUSHP   0x35
#define CMD_DMAGO       0xa0
#define CMD_DMALD       0x04
#define CMD_DMALDP      0x25
#define CMD_DMALP       0x20
#define CMD_DMALPEND    0x28
#define CMD_DMAKILL     0x01
#define CMD_DMAMOV      0xbc
#define CMD_DMANOP      0x18
#define CMD_DMARMB      0x12
#define CMD_DMASEV      0x34
#define CMD_DMAST       0x08
#define CMD_DMASTP      0x29
#define CMD_DMASTZ      0x0c
#define CMD_DMAWFE      0x36
#define CMD_DMAWFP      0x30
#define CMD_DMAWMB      0x13

//指令长度
#define SZ_DMAADDH      3
#define SZ_DMAEND       1
#define SZ_DMAFLUSHP    2
#define SZ_DMAGO        6
#define SZ_DMALD        1
#define SZ_DMALDP       2
#define SZ_DMALP        2
#define SZ_DMALPEND     2
#define SZ_DMAKILL      1
#define SZ_DMAMOV       6
#define SZ_DMANOP       1
#define SZ_DMARMB       1
#define SZ_DMASEV       2
#define SZ_DMAST        1
#define SZ_DMASTP       2
#define SZ_DMASTZ       1
#define SZ_DMAWFE       2
#define SZ_DMAWFP       2
#define SZ_DMAWMB       1

//指令队列总长
#define INSTR_Q_MAX     500

//缓冲区大小
#define BUF_SIZE  (512*64)

//DMAMOV指令对应的三个目标地址下标
enum dmamov_dst {
    SAR = 0,
    CCR,
    DAR,
};

//DMA源缓冲区
static char *src;
static u32 src_phys;

//DMA目标缓冲区
static char *dst;
static u32 dst_phys;

//DMA指令缓冲区
static char *instr_q; 
static u32 instr_q_phys;


struct ax_dma_drv {
    dev_t   devid;              //设备号
    struct  cdev cdev;          //字符设备
    struct  class *class;       //类
    struct  device *device;     //设备
    int     major;              //主设备号
};
struct ax_dma_drv ax_dma;

static irqreturn_t dma_irq(int irq, void *dev_id)
{
    u32 reg;
    //清除通道1中断标志
    iowrite32(0x000000ff, irqclr);
    
    if(!memcmp(src, dst, 160))
    {
        printk("dma irq test ok\r\n");
    }
    
    return IRQ_HANDLED;
}

static int dma_open(struct inode *inode,struct file *file)
{
    printk("dma_open\r\n");
    return 0;
}

static int dma_write(struct file *file,const char __user *buf, size_t count,loff_t *ppos)
{ 
    //指令长度计数
    int instr_cnt = 0, loop_start = 0, lpcount;
    u32 reg;
    printk("dma_write\r\n");

    memset(instr_q, 0x00, INSTR_Q_MAX);
    memset(src, 0xAA, 160);
    memset(dst, 0x55, 160);

    //设置数据源地址
    instr_q[instr_cnt + 0] = (char)(CMD_DMAMOV);
    instr_q[instr_cnt + 1] = (char)(SAR);
    *((__le32 *)&instr_q[instr_cnt + 2]) = cpu_to_le32(src_phys);
    //指令总长计数
    instr_cnt += SZ_DMAMOV;
    
    //设置数据目标地址
    instr_q[instr_cnt + 0] = (char)(CMD_DMAMOV);
    instr_q[instr_cnt + 1] = (char)(DAR);
    *((__le32 *)&instr_q[instr_cnt + 2]) = cpu_to_le32(dst_phys);
    //指令总长计数
    instr_cnt += SZ_DMAMOV;
    
    //设置数据传输规则, 每个循环传输burst_size * burst_len, 源和目标地址变化规则等
    instr_q[instr_cnt + 0] = (char)(CMD_DMAMOV);
    instr_q[instr_cnt + 1] = (char)(CCR);
    //0x0005c017 -> 0000 0000 0000 0001 0111 0000 0001 0111
    //len = 2byte, instr_cnt = 8byte, inc = Incrementing-address
    //单次循环数据大小 = burst_size * burst_len = 2 * 8 = 16
    *((__le32 *)&instr_q[instr_cnt + 2]) = cpu_to_le32(0x0005c017);
    //指令总长计数
    instr_cnt += SZ_DMAMOV;
    
    //循环装载数据, 输出FIFO
    instr_q[instr_cnt + 0] =(char)(CMD_DMALP);
    instr_q[instr_cnt + 1] =(char)(100);   //循环次数
    instr_cnt += SZ_DMALP;
    loop_start = instr_cnt;
    
    for(lpcount = 0; lpcount < 100; lpcount ++)
    {
        //从源读数据
        instr_q[instr_cnt + 0] =(char)(CMD_DMALD);   
        instr_cnt += SZ_DMALD;
        instr_q[instr_cnt + 0] =(char)(CMD_DMARMB);
        instr_cnt += SZ_DMARMB;
        //写数据到目标地址
        instr_q[instr_cnt + 0] =(char)(CMD_DMAST);  
        instr_cnt += SZ_DMAST;
        instr_q[instr_cnt + 0] =(char)(CMD_DMAWMB);
        instr_cnt += SZ_DMAWMB;
    }
    
    //申请中断
    instr_q[instr_cnt + 0] = (char)(CMD_DMASEV);
    instr_q[instr_cnt + 1] = (char)(1 << 3);
    instr_cnt += SZ_DMASEV;

    //等待dmac空闲
    do {
        reg = ioread32(dbgstatus);
    } while((reg & 0x01) == 0x01);
    
    iowrite32((0 << 24) | (CMD_DMAGO << 16) | (0 << 8) | (0 << 0), dbginst0);
    iowrite32(instr_q_phys, dbginst1); 
    iowrite32(0, dbgcmd);
    printk("dma go\r\n");
    
    return 0;
}

static int dma_release(struct inode *inode, struct file *filp)
{
    printk("dma_release\r\n");   
    return 0;
}

static struct file_operations dma_lops=
{
    .owner   = THIS_MODULE,
    .open    = dma_open,
    .write   = dma_write,
    .release = dma_release,
};

static int dma_init(void)
{
    int err;
    u32 reg;

    printk("dma_init\r\n");

    //构建设备号
    alloc_chrdev_region(&ax_dma.devid, 0, AX_DRV_CNT, AX_DRV_NAME);

    //注册设备
    cdev_init(&ax_dma.cdev, &dma_lops);
    cdev_add(&ax_dma.cdev, ax_dma.devid, AX_DRV_CNT);

    //创建类
    ax_dma.class = class_create(THIS_MODULE, AX_DRV_NAME);
    if(IS_ERR(ax_dma.class))
    {
        return PTR_ERR(ax_dma.class);
    }

    //创建设备
    ax_dma.device = device_create(ax_dma.class, NULL, ax_dma.devid, NULL, AX_DRV_NAME);
    if(IS_ERR(ax_dma.device))
    {
        return PTR_ERR(ax_dma.device);
    }

    //注册中断
    err = request_irq(33, dma_irq, IRQF_TRIGGER_HIGH, "ax-dmac2", NULL);
    if(err < 0) printk("irq err=%d\n", err);
    
    //分配SRC对应的缓冲区
    src = dma_alloc_coherent(NULL, BUF_SIZE, &src_phys, GFP_KERNEL);
    if (NULL == src)
    {
        printk("can't alloc buffer for src\n");
        return -ENOMEM;
    }
    
    //分配DST对应的缓冲区
    dst = dma_alloc_coherent(NULL, BUF_SIZE, &dst_phys, GFP_KERNEL);
    if (NULL == dst)
    {
        dma_free_coherent(NULL, BUF_SIZE, src, src_phys);
        printk("can't alloc buffer for dst\n");
        return -ENOMEM;
    }
    
    instr_q = dma_alloc_coherent(NULL, INSTR_Q_MAX, &instr_q_phys, GFP_KERNEL); 
    if (NULL == instr_q)
    {
        dma_free_coherent(NULL, BUF_SIZE, src, src_phys);
        dma_free_coherent(NULL, BUF_SIZE, dst, dst_phys);
        printk("can't alloc buffer for instr_q\n");
        return -ENOMEM;
    }
    
    //虚拟地址映射
    dbgstatus  = ioremap(DMA_BASE_ADDR + DMA_DBGSTATUS_OFFSET, 4);
    dbgcmd     = ioremap(DMA_BASE_ADDR + DMA_DBGCMD_OFFSET,    4);
    dbginst0   = ioremap(DMA_BASE_ADDR + DMA_DBGINST0_OFFSET,  4);
    dbginst1   = ioremap(DMA_BASE_ADDR + DMA_DBGINST1_OFFSET,  4);
    irqen      = ioremap(DMA_BASE_ADDR + DMA_IRQ_EN_OFFSET,    4);
    irqclr     = ioremap(DMA_BASE_ADDR + DMA_IRQ_CLR_OFFSET,   4);
    clken      = ioremap(DMA_CLKEN_ADDR, 4);
    cache      = ioremap(DMA_BASE_ADDR + DMA_CACH_OFFSET, 4);

    //使能AMBA时钟
    reg = ioread32(clken);
    iowrite32(reg | 0x00000001, clken);
    //使能通道1中断
    iowrite32(0x000000ff, irqen);
    //读取cache寄存器以初始化cache
    reg = ioread32(cache);
    
    return 0;
}

static void dma_exit(void)
{
    //释放中断
    free_irq(33, NULL);
    //删除设备
    cdev_del(&ax_dma.cdev);
    unregister_chrdev_region(ax_dma.major, AX_DRV_CNT);
    //注销类
    device_destroy(ax_dma.class, ax_dma.devid);
    class_destroy(ax_dma.class);
    //释放缓冲区
    dma_free_coherent(NULL, BUF_SIZE, src, src_phys);
    dma_free_coherent(NULL, BUF_SIZE, dst, dst_phys);
    dma_free_coherent(NULL, BUF_SIZE, instr_q, instr_q_phys);
    //失能DMA中断
    iowrite32(0x00000000, irqen);
    //释放虚拟地址
    iounmap(dbgstatus);
    iounmap(dbgcmd);
    iounmap(dbginst0);
    iounmap(dbginst1);
    iounmap(irqen);
    iounmap(irqclr);
    iounmap(clken);
    iounmap(cache);
    //test
}

//驱动入口函数标记
module_init(dma_init);
//驱动出口函数标记
module_exit(dma_exit);

/* 驱动描述信息 */  
MODULE_AUTHOR("Alinx");  
MODULE_ALIAS("dma");  
MODULE_DESCRIPTION("DMA driver");  
MODULE_VERSION("v1.0");  
MODULE_LICENSE("GPL"); 

