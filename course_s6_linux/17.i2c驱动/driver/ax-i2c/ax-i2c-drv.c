/** ===================================================== **
 *Author : ALINX Electronic Technology (Shanghai) Co., Ltd.
 *Website: http://www.alinx.com
 *Address: Room 202, building 18, 
           No.518 xinbrick Road, 
           Songjiang District, Shanghai
 *Created: 2020-3-2 
 *Version: 1.0
 ** ===================================================== **/
 
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/delay.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/errno.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/string.h>
#include <linux/timer.h>
#include <linux/i2c.h>
#include <linux/irq.h>
#include <linux/wait.h>
#include <linux/poll.h>
#include <linux/fs.h>
#include <linux/fcntl.h>
#include <linux/platform_device.h>
#include <asm/mach/map.h>
#include <asm/uaccess.h>
#include <asm/io.h>

/* 驱动个数 */  
#define AX_I2C_CNT  1
/* 设备节点名称 */ 
#define AX_I2C_NAME "ax_i2c_e2p"

struct ax_i2c_dev {
    dev_t devid;              //设备号
    struct cdev cdev;         //字符设备
    struct class *class;      //类
    struct device *device;    //设备
    int major;                //主设备号
    void *private_data;       //用于在probe函数中获取client
};
/* 声明设备结构体变量 */
struct ax_i2c_dev axi2cdev;

/* i2c数据读取
 * struct ax_i2c_dev *dev : 设备结构体
 * u8 reg                 : 数据在目标设备中的地址
 * void *val              : 数据buffer首地址
 * int len                ：数据长度
 */
static int ax_i2c_read_regs(struct ax_i2c_dev *dev, u8 reg, void *val, int len)
{
    int ret;
    /* 构建msg, 读取时一般使用一个至少两个元素的msg数组
       第一个元素用于发送目标数据地址(写), 第二个元素发送buffer地址(读) */
    struct i2c_msg msg[2];
    /* 从设备结构体变量中获取client数据 */
    struct i2c_client *client = (struct i2c_client *)dev->private_data;

    /* 构造msg */
    msg[0].addr = client->addr;    //设置设备地址
    msg[0].flags = 0;              //标记为写, 先给eeprom发送读取数据的所在地址
    msg[0].buf = &reg;             //读取数据的所在地址
    msg[0].len = 1;                //地址数据长度, 只发送首地址的话长度就为1

    msg[1].addr = client->addr;    //设置设备地址
    msg[1].flags = I2C_M_RD;       //标记为读
    msg[1].buf = val;              //数据读出的buffer地址
    msg[1].len = len;              //读取数据长度

    /* 调用i2c_transfer发送msg */
    ret = i2c_transfer(client->adapter, msg, 2);
    if(2 == ret)
    {
        ret = 0;
    }
    else
    {
        printk("i2c read failed %d\r\n", ret);
        ret = -EREMOTEIO;
    }

    return ret;
}

/* i2c数据写入
 * struct ax_i2c_dev *dev : 设备结构体
 * u8 reg                 : 数据在目标设备中的地址
 * void *val              : 数据buffer首地址
 * int len                ：数据长度
 */
static s32 ax_i2c_write_regs(struct ax_i2c_dev *dev, u8 reg, u8 *buf, int len)
{
    int ret;
    /* 数据buffer */
    u8 b[100] = {0};
    /* 构建msg */
    struct i2c_msg msg;
    /* 从设备结构体变量中获取client数据 */
    struct i2c_client *client = (struct i2c_client *)dev->private_data;

    /* 把写入目标地址放在buffer的第一个元素中首先发送 */
    b[0] = reg;
    /* 把需要发送的数据拷贝到随后的地址中 */
    memcpy(&b[1], buf, 100 > len ? len : 100);

    /* 构建msg */
    msg.addr = client->addr;    //设置设备地址
    msg.flags = 0;              //标记为写
    msg.buf = b;                //数据写入的buffer地址
    msg.len = len + 1;          //写入的数据长度, 因为除了用户数据外, 
                                //还需要发送数据地址所以要+1
    
    /* 调用i2c_transfer发送msg */
    ret = i2c_transfer(client->adapter, &msg, 1);

    if(1 == ret)
    {
        ret = 0;
    }
    else
    {
        printk("i2c write failed %d\r\n", ret);
        ret = -EREMOTEIO;
    }
    return ret;
}

/* open函数实现, 对应到Linux系统调用函数的open函数 */
static int ax_i2c_open(struct inode *inode, struct file *filp)
{
    /* 设置私有数据 */
    filp->private_data = &axi2cdev;
    return 0;
}

/* read函数实现, 对应到Linux系统调用函数的read函数 */ 
static ssize_t ax_i2c_read(struct file *file, char __user *buf, size_t size, loff_t *offset)
{
    /* 获取私有数据 */
    struct ax_i2c_dev *dev = (struct ax_i2c_dev *)file->private_data;
    /* 读取数据buffer */
    char b[100] = {0};
    int ret = 0;
    /* 从0地址开始读, 这里只是为了实验方便使用了read并且把地址写死了, 
       实际的应用中不应该在驱动中把地址写死, 可以尝试使用iotcl去实现灵活的方法 */
    ax_i2c_read_regs(dev, 0x00, b, 100 > size ? size : 100);

    /* 把读取到的数据拷贝到用户读取的地址 */
    ret = copy_to_user(buf, b, 100 > size ? size : 100);
    return 0;
}

/* write函数实现, 对应到Linux系统调用函数的write函数 */
static ssize_t ax_i2c_write(struct file *file, const char __user *buf, size_t size, loff_t *offset)
{
    /* 获取私有数据 */
    struct ax_i2c_dev *dev = (struct ax_i2c_dev *)file->private_data;
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
    /* 和读对应的从0开始写 */
    ax_i2c_write_regs(dev, 0x00, user_data, size);
    
    return 0;
}

/* release函数实现, 对应到Linux系统调用函数的close函数 */
static int ax_i2c_release(struct inode *inode, struct file *filp)
{
    return 0;
}

/* file_operations结构体声明 */
static const struct file_operations ax_i2c_ops = {
    .owner = THIS_MODULE,
    .open  = ax_i2c_open,
    .read  = ax_i2c_read,
    .write = ax_i2c_write,
    .release = ax_i2c_release,
};

/* probe函数实现, 驱动和设备匹配时会被调用 */
static int axi2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
{
    printk("eeprom probe\r\n");
    /* 构建设备号 */
    alloc_chrdev_region(&axi2cdev.devid, 0, AX_I2C_CNT, AX_I2C_NAME);

    /* 注册设备 */
    cdev_init(&axi2cdev.cdev, &ax_i2c_ops);
    cdev_add(&axi2cdev.cdev, axi2cdev.devid, AX_I2C_CNT);

    /* 创建类 */
    axi2cdev.class = class_create(THIS_MODULE, AX_I2C_NAME);
    if(IS_ERR(axi2cdev.class))
    {
        return PTR_ERR(axi2cdev.class);
    }

    /* 创建设备 */
    axi2cdev.device = device_create(axi2cdev.class, NULL, axi2cdev.devid, NULL, AX_I2C_NAME);
    if(IS_ERR(axi2cdev.device))
    {
        return PTR_ERR(axi2cdev.device);
    }

    axi2cdev.private_data = client;

    return 0;
}

/* remove函数实现, 驱动卸载时会被调用 */
static void axi2c_remove(struct i2c_client *client)
{
    /* 删除设备 */
    cdev_del(&axi2cdev.cdev);
    unregister_chrdev_region(axi2cdev.major, AX_I2C_CNT);
    /* 注销类 */
    device_destroy(axi2cdev.class, axi2cdev.devid);
    class_destroy(axi2cdev.class);
}

/* of匹配表, 设备树下的匹配方式 */
static const struct of_device_id axi2c_of_match[] = 
{
    { .compatible = "ax-e2p1"},
    {/* sentinel */}
};

/* 传统的id_table匹配方式 */
static const struct i2c_device_id axi2c_id[] = {
    {"ax-e2p1"},
    {}
};

/* 声明并初始化i2c驱动 */
static struct i2c_driver axi2c_driver = {
    .driver = {
        .owner = THIS_MODULE,
        .name    = "ax-e2p1",
        /* 用of_match_table匹配 */
        .of_match_table = axi2c_of_match,
    },
    /* 使用传统的方式匹配 */
    .id_table = axi2c_id,
    .probe = axi2c_probe,
    .remove = axi2c_remove,
};

/* 驱动入口函数 */
static int __init ax_i2c_init(void)
{
    /* 在入口函数中调用i2c_add_driver, 注册驱动 */
    return i2c_add_driver(&axi2c_driver);
}

/* 驱动出口函数 */
static void __exit ax_i2c_exit(void)
{
    /* 在出口函数中调用i2c_add_driver, 卸载驱动 */
    i2c_del_driver(&axi2c_driver);
}

/* 标记加载、卸载函数 */ 
module_init(ax_i2c_init);
module_exit(ax_i2c_exit);

/* 驱动描述信息 */  
MODULE_AUTHOR("Alinx");  
MODULE_ALIAS("pwm_led");  
MODULE_DESCRIPTION("I2C EEPROM driver");  
MODULE_VERSION("v1.0");  
MODULE_LICENSE("GPL"); 























