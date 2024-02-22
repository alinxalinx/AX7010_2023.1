/** ===================================================== **
 *Author : ALINX Electronic Technology (Shanghai) Co., Ltd.
 *Website: http://www.alinx.com
 *Address: Room 202, building 18, 
           No.518 xinbrick Road, 
           Songjiang District, Shanghai
 *Created: 2020-3-2 
 *Version: 1.0
 ** ===================================================== **/
 
#include <linux/err.h>
#include <linux/errno.h>
#include <linux/device.h>
#include <linux/mtd/mtd.h>
#include <linux/mtd/partitions.h>
#include <linux/spi/spi.h>
#include <linux/spi/flash.h>
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/ide.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/cdev.h>
#include <linux/fs.h>
#include <linux/fcntl.h>
#include <linux/platform_device.h>
#include <asm/mach/map.h>
#include <asm/uaccess.h>
#include <asm/io.h>

/* 驱动个数 */  
#define AX_FLASH_CNT  1
/* 设备节点名称 */ 
#define AX_FLASH_NAME "ax_flash"

/* Flash操作命令 */   
#define CMD_WRITE_ENABLE    0x06      
#define CMD_BULK_ERASE      0xc7  
#define CMD_READ_BYTES      0x03  
#define CMD_PAGE_PROGRAM    0x02 
#define CMD_MAX                 5   

struct ax_qflash_dev {
    dev_t   devid;              //设备号
    struct  cdev cdev;          //字符设备
    struct  class *class;       //类
    struct  device *device;     //设备
    int     major;              //主设备号
    void    *private_data;      //私有数据, 获取spi_device
    char    cmd[CMD_MAX];       //SPI命令和地址
};

struct ax_qflash_dev ax_qflash;

static int ax_spi_write(struct ax_qflash_dev *dev, loff_t addr, const char *buf, size_t len)  
{  
    int ret; 
    char cmd_buf[1] = {0};    
    struct spi_device *spi = (struct spi_device *)dev->private_data;
    struct spi_transfer trans[2] = {0}; 
    struct spi_message msg;  
    spi_message_init(&msg);

    /* 写使能 */
    cmd_buf[0] = CMD_WRITE_ENABLE;
    spi_write(spi, cmd_buf, 1);
    
    dev->cmd[0] = CMD_PAGE_PROGRAM;  
    dev->cmd[1] = addr >> 24;  
    dev->cmd[2] = addr >> 16;  
    dev->cmd[3] = addr >> 8;    
    dev->cmd[4] = addr;   
    
    trans[0].tx_buf = dev->cmd;  
    trans[0].len = CMD_MAX;  
    spi_message_add_tail(&trans[0], &msg);  
  
    trans[1].tx_buf = buf;  
    trans[1].len = len;  
    spi_message_add_tail(&trans[1], &msg);
      
    ret = spi_sync(spi, &msg);    

    return ret;  
}  
  
static int ax_spi_read(struct ax_qflash_dev *dev, loff_t addr, const char *buf, size_t len)
{  
    int ret;  
    struct spi_device *spi = (struct spi_device *)dev->private_data;
    struct spi_transfer trans[2] = {0}; 
    struct spi_message msg;  
    spi_message_init(&msg);
    
    dev->cmd[0] = CMD_READ_BYTES;  
    dev->cmd[1] = addr >> 24;  
    dev->cmd[2] = addr >> 16;  
    dev->cmd[3] = addr >> 8;    
    dev->cmd[4] = addr; 
    
    trans[0].tx_buf = dev->cmd;  
    trans[0].len = CMD_MAX;  
    spi_message_add_tail(&trans[0], &msg);  
  
    trans[1].rx_buf = buf;  
    trans[1].len = len;  
    spi_message_add_tail(&trans[1], &msg);

    ret = spi_sync(spi, &msg);  
    
    return ret;  
}  

/* open函数实现, 对应到Linux系统调用函数的open函数 */
static int ax_flash_open(struct inode *inode, struct file *filp)
{
    /* 设置私有数据 */
    filp->private_data = &ax_qflash;
    return 0;
}

/* read函数实现, 对应到Linux系统调用函数的read函数 */ 
static ssize_t ax_flash_read(struct file *file, char __user *buf, size_t size, loff_t *offset)
{
    /* 获取私有数据 */
    struct ax_qflash_dev *dev = (struct ax_qflash_dev *)file->private_data;
    /* 读取数据buffer */
    char b[100] = {0};
    int ret = 0;
    
    /* 读取数据 */
    ax_spi_read(dev, 0, b, 100 > size ? size : 100);
    
    /* 把读取到的数据拷贝到用户读取的地址 */
    ret = copy_to_user(buf, b, 100 > size ? size : 100);
    return 0;
}

/* write函数实现, 对应到Linux系统调用函数的write函数 */
static ssize_t ax_flash_write(struct file *file, const char __user *buf, size_t size, loff_t *offset)
{
    /* 获取私有数据 */
    struct ax_qflash_dev *dev = (struct ax_qflash_dev *)file->private_data;
    /* 写入数据的buffer */
    static char user_data[100] = {0};
    int ret = 0;
    /* 获取用户需要发送的数据 */
    ret = copy_from_user(user_data, buf, 100 > size ? size : 100);
    if(ret < 0)
    {
        printk("copy user data failed\r\n");
        return ret;
    } 
    
    /* 写入数据 */
    ax_spi_write(dev, 0, user_data, 100 > size ? size : 100);
    
    return 0;
}

/* release函数实现, 对应到Linux系统调用函数的close函数 */
static int ax_flash_release(struct inode *inode, struct file *filp)
{
    return 0;
}

/* file_operations结构体声明 */
static const struct file_operations ax_flash_ops = {
    .owner = THIS_MODULE,
    .open  = ax_flash_open,
    .read  = ax_flash_read,
    .write = ax_flash_write,
    .release = ax_flash_release,
};

static int ax_spi_probe(struct spi_device *spi)  
{  
    char cmd_buf[1] = {0};
    printk("flash probe\r\n");
 
    /* 构建设备号 */
    alloc_chrdev_region(&ax_qflash.devid, 0, AX_FLASH_CNT, AX_FLASH_NAME);

    /* 注册设备 */
    cdev_init(&ax_qflash.cdev, &ax_flash_ops);
    cdev_add(&ax_qflash.cdev, ax_qflash.devid, AX_FLASH_CNT);

    /* 创建类 */
    ax_qflash.class = class_create(THIS_MODULE, AX_FLASH_NAME);
    if(IS_ERR(ax_qflash.class))
    {
        return PTR_ERR(ax_qflash.class);
    }

    /* 创建设备 */
    ax_qflash.device = device_create(ax_qflash.class, NULL, ax_qflash.devid, NULL, AX_FLASH_NAME);
    if(IS_ERR(ax_qflash.device))
    {
        return PTR_ERR(ax_qflash.device);
    }

    ax_qflash.private_data = spi; 
    /* 擦除 */
    cmd_buf[0] = CMD_BULK_ERASE;
    spi_write(spi, cmd_buf, 1); 
    return 0;  
}  
  
static int ax_spi_remove(struct spi_device *spi)  
{  
    /* 删除设备 */
    cdev_del(&ax_qflash.cdev);
    unregister_chrdev_region(ax_qflash.major, AX_FLASH_CNT);
    /* 注销类 */
    device_destroy(ax_qflash.class, ax_qflash.devid);
    class_destroy(ax_qflash.class);
    return 0;  
}  
  
static const struct spi_device_id ax_id_table[] = {  
    {"w25q256", 0},  
    { }  
};  
  
static const struct of_device_id ax_of_match[] = {  
    { .compatible = "w25q256" },  
    { }  
};  
  
static struct spi_driver ax_spi_driver = {  
    .probe = ax_spi_probe,  
    .remove = ax_spi_remove,  
    .driver = {  
        .owner = THIS_MODULE,  
        .name = "w25q256",  
        .of_match_table = ax_of_match,  
    },  
    .id_table = ax_id_table,  
};  
  
static int __init ax_init(void)  
{  
    return spi_register_driver(&ax_spi_driver);  
}  
  
static void __exit ax_exit(void)  
{  
    spi_unregister_driver(&ax_spi_driver);  
}  
  
module_init(ax_init);  
module_exit(ax_exit);  

/* 驱动描述信息 */  
MODULE_AUTHOR("Alinx");  
MODULE_ALIAS("qspi flash");  
MODULE_DESCRIPTION("I2C FLASH driver");  
MODULE_VERSION("v1.0");  
MODULE_LICENSE("GPL"); 


