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
#include <linux/errno.h>
#include <linux/interrupt.h>
#include <linux/mm.h>
#include <linux/fs.h>
#include <linux/kernel.h>
#include <linux/timer.h>
#include <linux/genhd.h>
#include <linux/hdreg.h>
#include <linux/ioport.h>
#include <linux/init.h>
#include <linux/wait.h>
#include <linux/blkdev.h>
#include <linux/blkpg.h>
#include <linux/delay.h>
#include <linux/io.h>
#include <asm/mach/map.h>
#include <asm/uaccess.h>
#include <asm/dma.h>

#define AX_BLOCK_SIZE   (1024*64)                   //块设备大小
#define SECTOR_SIZE     512                         //扇区大小
#define SECTORS_NUM     AX_BLOCK_SIZE / SECTOR_SIZE //扇区数

#define AX_BLOCK_NAME   "ax_block"                  //设备节点名称

#define AX_BLOCK_MAJOR  40
struct ax_block{
    struct gendisk          *block_disk;    //磁盘结构体
    struct request_queue    *block_request; //申请队列
    unsigned char           *block_buf;     //磁盘地址
};
/* 声明设备结构体变量 */
struct ax_block ax_block_drv;
/* 定义一个自旋锁 */
static DEFINE_SPINLOCK(ax_block_lock);

/* 块设备操作函数集, 即使没有操作函数, 也需要赋值 */
static struct block_device_operations ax_block_fops = {
    .owner  =   THIS_MODULE,
};

/* 队列处理函数 */
static void ax_block_request(struct request_queue * q)
{
    struct request *req;
    
    /* 轮询队列中的每个申请 */
    req = blk_fetch_request(q);
    while(req) 
    {
        unsigned long start;
        unsigned long len;
        void *buffer = bio_data(req->bio);
        /* 获取首地址 */
        start = (int)blk_rq_pos(req) * SECTOR_SIZE + ax_block_drv.block_buf; 
        /* 获取长度 */
        len = blk_rq_cur_bytes(req);     
                      
        if(rq_data_dir(req) == READ)
        {            
            printk("ax_request read\n");
            memcpy(buffer, (char *)start, len);
        }
        else
        {             
            printk("ax_request write\n");
            memcpy((char *)start, buffer, len);
        }
        /* 处理完的申请出列 */
        if (!__blk_end_request_cur(req, 0))
			req = blk_fetch_request(q);
    }  
}

static int __init ax_block_init(void)
{
    /* 分配块设备 */
    ax_block_drv.block_disk = alloc_disk(1);  
    /* 分配申请队列, 提供队列处理函数 */ 
    ax_block_drv.block_request = blk_init_queue(ax_block_request, &ax_block_lock);
    /* 设置申请队列 */
    ax_block_drv.block_disk->queue = ax_block_drv.block_request;
    /* 向内核注册块设备 */
    register_blkdev(AX_BLOCK_MAJOR, AX_BLOCK_NAME);   
    /* 主设备号赋给块设备得主设备号字段 */
    ax_block_drv.block_disk->major = AX_BLOCK_MAJOR;
    /* 设置其他参数 */
    ax_block_drv.block_disk->first_minor = 0;
    ax_block_drv.block_disk->fops = &ax_block_fops;
    sprintf(ax_block_drv.block_disk->disk_name, AX_BLOCK_NAME);
    /* 设置扇区数 */
    set_capacity(ax_block_drv.block_disk, SECTORS_NUM);
    /* 获取缓存, 把内存模拟成块设备 */
    ax_block_drv.block_buf = kzalloc(AX_BLOCK_SIZE, GFP_KERNEL);
    /* 向内核注册gendisk结构体 */
    add_disk(ax_block_drv.block_disk);   
    return  0;
}

static void __exit ax_block_exit(void)
{
    /* 注销gendisk结构体 */
    put_disk(ax_block_drv.block_disk);
    /* 释放gendisk结构体 */
    del_gendisk(ax_block_drv.block_disk);
    /* 释放缓存 */
    kfree(ax_block_drv.block_buf);
    /* 清空内存中的队列 */
    blk_cleanup_queue(ax_block_drv.block_request);
    /* 卸载快设备 */
    unregister_blkdev(AX_BLOCK_MAJOR, AX_BLOCK_NAME);
}

module_init(ax_block_init);
module_exit(ax_block_exit);

/* 驱动描述信息 */  
MODULE_AUTHOR("Alinx"); 
MODULE_ALIAS("block test");  
MODULE_DESCRIPTION("BLOCK driver");  
MODULE_VERSION("v1.0");  
MODULE_LICENSE("GPL"); 

