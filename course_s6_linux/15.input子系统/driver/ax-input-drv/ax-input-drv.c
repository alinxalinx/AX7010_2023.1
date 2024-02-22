/** ===================================================== **
 *Author : ALINX Electronic Technology (Shanghai) Co., Ltd.
 *Website: http://www.alinx.com
 *Address: Room 202, building 18, 
           No.518 xinbrick Road, 
           Songjiang District, Shanghai
 *Created: 2020-3-2 
 *Version: 1.0
 ** ===================================================== **/

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>  
#include <linux/types.h>  
#include <linux/errno.h>
#include <linux/cdev.h>
#include <linux/of.h>
#include <linux/of_address.h>
#include <linux/of_gpio.h>
#include <linux/device.h>
#include <linux/delay.h>
#include <linux/init.h>
#include <linux/gpio.h>
#include <linux/semaphore.h>
#include <linux/timer.h>
#include <linux/of_irq.h>
#include <linux/irq.h>
#include <linux/interrupt.h>
#include <linux/input.h>
#include <asm/uaccess.h>
#include <asm/mach/map.h>
#include <asm/io.h>
   
/* 设备节点名称 */  
#define INPUT_DEV_NAME "input_key"

/* 把驱动代码中会用到的数据打包进设备结构体 */
struct alinx_char_dev {
    dev_t              devid;             //设备号
    struct cdev        cdev;              //字符设备
    struct class       *class;            //类
    struct device      *device;           //设备
    struct device_node *nd;               //设备树的设备节点
    spinlock_t         lock;              //自旋锁变量
    int                alinx_key_gpio;    //gpio号
    unsigned int       irq;               //中断号
    struct timer_list  timer;             //定时器
    struct input_dev   *inputdev;         //input_dev结构体
    unsigned char      code;              //input事件码
};
/* 声明设备结构体 */
static struct alinx_char_dev alinx_char = {
    .cdev = {
        .owner = THIS_MODULE,
    },
};

/* 中断服务函数 */
static irqreturn_t key_handler(int irq, void *dev)
{
    /* 按键按下或抬起时会进入中断 */
    struct alinx_char_dev *cdev = (struct alinx_char_dev *)dev;
    /* 开启50毫秒的定时器用作防抖动 */
    mod_timer(&cdev->timer, jiffies + msecs_to_jiffies(50));
    return IRQ_RETVAL(IRQ_HANDLED);
}

/* 定时器服务函数 */
void timer_function(struct timer_list *timer)
{
    unsigned long flags;
    struct alinx_char_dev *dev = &alinx_char;
    /* value用于获取按键值 */
    unsigned char value;
    
    /* 获取锁 */
    spin_lock_irqsave(&dev->lock, flags);

    /* 获取按键值 */
    value = gpio_get_value(dev->alinx_key_gpio);
    
    if(value == 0)
    {
        /* 按键按下, 状态置1 */
        input_report_key(dev->inputdev, dev->code, 1);
        input_sync(dev->inputdev);
    }
    else
    {
        /* 按键抬起 */
        input_report_key(dev->inputdev, dev->code, 0);
        input_sync(dev->inputdev);
    }
    
    /* 释放锁 */
    spin_unlock_irqrestore(&dev->lock, flags);
}
  
/* 模块加载时会调用的函数 */  
static int __init char_drv_init(void)  
{
    /* 用于接受返回值 */
    u32 ret = 0;
    
    /* 初始化自旋锁 */
    spin_lock_init(&alinx_char.lock);

    /* 获取设备节点 */
    alinx_char.nd = of_find_node_by_path("/alinxkey");
    if(alinx_char.nd == NULL)
    {
        printk("alinx_char node not find\r\n");
        return -EINVAL;
    }
    else
    {
        printk("alinx_char node find\r\n");
    }
    
    /* 获取节点中gpio标号 */
    alinx_char.alinx_key_gpio = of_get_named_gpio(alinx_char.nd, "alinxkey-gpios", 0);
    if(alinx_char.alinx_key_gpio < 0)
    {
        printk("can not get alinxkey-gpios");
        return -EINVAL;
    }
    printk("alinxkey-gpio num = %d\r\n", alinx_char.alinx_key_gpio);
    
    /* 申请gpio标号对应的引脚 */
    ret = gpio_request(alinx_char.alinx_key_gpio, "alinxkey");
    if(ret != 0)
    {
        printk("can not request gpio\r\n");
        return -EINVAL;
    }
    
    /* 把这个io设置为输入 */
    ret = gpio_direction_input(alinx_char.alinx_key_gpio);
    if(ret < 0)
    {
        printk("can not set gpio\r\n");
        return -EINVAL;
    }

    /* 获取中断号 */
    alinx_char.irq = gpio_to_irq(alinx_char.alinx_key_gpio);
    /* 申请中断 */
    ret = request_irq(alinx_char.irq,
                      key_handler,
                      IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
                      "alinxkey", 
                      &alinx_char);
    if(ret < 0)
    {
        printk("irq %d request failed\r\n", alinx_char.irq);
        return -EFAULT;
    }

    __init_timer(&alinx_char.timer, timer_function, 0);
   
    /* 设置事件码为KEY_0 */
    alinx_char.code = KEY_0;
    
    /* 申请input_dev结构体变量 */
    alinx_char.inputdev = input_allocate_device();
    
    alinx_char.inputdev->name = INPUT_DEV_NAME;
    /* 设置按键事件 */
    __set_bit(EV_KEY, alinx_char.inputdev->evbit);
    /* 设置按键重复事件 */
    __set_bit(EV_REP, alinx_char.inputdev->evbit);
    /* 设置按键事件码 */
    __set_bit(KEY_0, alinx_char.inputdev->keybit);
    
    /* 注册input_dev结构体变量 */
    ret = input_register_device(alinx_char.inputdev);
    if(ret) {
        printk("register input device failed\r\n");
        return ret;
    }
    
    return 0;  
}

/* 卸载模块 */  
static void __exit char_drv_exit(void)  
{  
    /* 删除定时器 */
    del_timer_sync(&alinx_char.timer);
    /* 释放中断号 */
    free_irq(alinx_char.irq, &alinx_char);
    /* 注销input_dev结构体变量 */
    input_unregister_device(alinx_char.inputdev);
    /* 释放input_dev结构体变量 */
    input_free_device(alinx_char.inputdev);
}  
  
/* 标记加载、卸载函数 */  
module_init(char_drv_init);  
module_exit(char_drv_exit);  
  
/* 驱动描述信息 */  
MODULE_AUTHOR("Alinx");  
MODULE_ALIAS("alinx char");  
MODULE_DESCRIPTION("INPUT LED driver");  
MODULE_VERSION("v1.0");  
MODULE_LICENSE("GPL");  













