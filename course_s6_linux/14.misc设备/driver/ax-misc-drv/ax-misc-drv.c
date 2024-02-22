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
#include <linux/gpio.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/of_gpio.h>
#include <linux/semaphore.h>
#include <linux/timer.h>
#include <linux/irq.h>
#include <linux/wait.h>
#include <linux/poll.h>
#include <linux/fs.h>
#include <linux/fcntl.h>
#include <linux/platform_device.h>
#include <linux/miscdevice.h>
#include <asm/mach/map.h>
#include <asm/uaccess.h>
#include <asm/io.h>

/* 设备节点名称 */  
#define DEVICE_NAME       "gpio_leds"
/* 设备号个数 */  
#define DEVID_COUNT       1
/* 驱动个数 */  
#define DRIVE_COUNT       1
/* 主设备号 */
#define MAJOR_AX
/* 次设备号 */
#define MINOR_AX          20
/* LED点亮时输入的值 */
#define ALINX_LED_ON      1
/* LED熄灭时输入的值 */
#define ALINX_LED_OFF     0

/* 把驱动代码中会用到的数据打包进设备结构体 */
struct alinx_char_dev{
    dev_t              devid;       //设备号
    struct cdev        cdev;        //字符设备
    struct class       *class;      //类
    struct device      *device;     //设备
	struct device_node *nd;         //设备树的设备节点
    int                ax_led_gpio; //gpio号
};
/* 声明设备结构体 */
static struct alinx_char_dev alinx_char = {
    .cdev = {
        .owner = THIS_MODULE,
    },
};

/* open函数实现, 对应到Linux系统调用函数的open函数 */  
static int gpio_leds_open(struct inode *inode_p, struct file *file_p)  
{  
    /* 设置私有数据 */
    file_p->private_data = &alinx_char;    
      
    return 0;  
}  

/* write函数实现, 对应到Linux系统调用函数的write函数 */  
static ssize_t gpio_leds_write(struct file *file_p, const char __user *buf, size_t len, loff_t *loff_t_p)  
{  
    int retvalue;
    unsigned char databuf[1];  
	/* 获取私有数据 */
	struct alinx_char_dev *dev = file_p->private_data;
  
    /* 获取用户数据 */
    retvalue = copy_from_user(databuf, buf, len);  
    if(retvalue < 0) 
    {
		printk("alinx led write failed\r\n");
		return -EFAULT;
    } 
      
    if(databuf[0] == ALINX_LED_ON)
    {
        /* gpio_set_value方法设置GPIO的值, 使用!!对0或者1二值化 */
		gpio_set_value(dev->ax_led_gpio, !!0);
    }
    else if(databuf[0] == ALINX_LED_OFF)
    {
		gpio_set_value(dev->ax_led_gpio, !!1);
    }
    else
    {
		printk("gpio_test para err\n");
    }
	 
    return 0;  
}  

/* release函数实现, 对应到Linux系统调用函数的close函数 */  
static int gpio_leds_release(struct inode *inode_p, struct file *file_p)  
{   
    return 0;  
}  

/* file_operations结构体声明, 是上面open、write实现函数与系统调用函数对应的关键 */
static struct file_operations ax_char_fops = {  
    .owner   = THIS_MODULE,  
    .open    = gpio_leds_open,  
    .write   = gpio_leds_write,     
    .release = gpio_leds_release,   
};

/* MISC设备结构体 */
static struct miscdevice led_miscdev = {
	.minor = MINOR_AX,
	.name = DEVICE_NAME,
    /* file_operations结构体 */
	.fops = &ax_char_fops,
};

/* probe函数实现, 驱动和设备匹配时会被调用 */
static int gpio_leds_probe(struct platform_device *dev)
{	
    /* 用于接受返回值 */
	u32 ret = 0;
	
	/* 获取设备节点 */
	alinx_char.nd = of_find_node_by_path("/alinxled");
	if(alinx_char.nd == NULL)	
    {
		printk("gpioled node nost find\r\n");
		return -EINVAL;
	}

    /* 获取节点中gpio标号 */
	alinx_char.ax_led_gpio = of_get_named_gpio(alinx_char.nd, "alinxled-gpios", 0);
	if(alinx_char.ax_led_gpio < 0)	
    {
		printk("can not get alinxled-gpios\r\n");
		return -EINVAL;
	}

	/* 把这个io设置为输出 */
	ret = gpio_direction_output(alinx_char.ax_led_gpio, 1);
	if(ret < 0)
	{
		printk("can not set gpio\r\n");
	}
    
    /*
    alloc_chrdev_region(&alinx_char.devid, MINOR_AX, DEVID_COUNT, DEVICE_NAME);

    cdev_init(&alinx_char.cdev, &ax_char_fops);

    cdev_add(&alinx_char.cdev, alinx_char.devid, DRIVE_COUNT);

    alinx_char.class = class_create(THIS_MODULE, DEVICE_NAME);
    if(IS_ERR(alinx_char.class)) 
    {
        return PTR_ERR(alinx_char.class);
    }

    alinx_char.device = device_create(alinx_char.class, NULL, 
                                      alinx_char.devid, NULL, 
                                      DEVICE_NAME);
    if (IS_ERR(alinx_char.device)) 
    {
        return PTR_ERR(alinx_char.device);
    }
    */
    
    /* 注册misc设备 */
    ret = misc_register(&led_miscdev);
	if(ret < 0) {
		printk("misc device register failed\r\n");
		return -EFAULT;
	}
    
    return 0;
}

static int gpio_leds_remove(struct platform_device *dev)
{
    /* 
    cdev_del(&alinx_char.cdev);

    unregister_chrdev_region(alinx_char.devid, DEVID_COUNT);

    device_destroy(alinx_char.class, alinx_char.devid);

    class_destroy(alinx_char.class);
    */
    
    /* 注销misc设备 */
    misc_deregister(&led_miscdev);
    return 0;
}

/* 初始化of_match_table */
static const struct of_device_id led_of_match[] = {
    /* compatible字段和设备树中保持一致 */
	{ .compatible = "alinx-led" },
	{/* Sentinel */}
};


/* 声明并初始化platform驱动 */
static struct platform_driver led_driver = {
    .driver = {
        /* name字段需要保留 */
        .name = "alinx-led",
        /* 用of_match_table代替name匹配 */
        .of_match_table = led_of_match,
    },
    .probe  = gpio_leds_probe,
    .remove = gpio_leds_remove,
};

/* 驱动入口函数 */
static int __init gpio_led_drv_init(void)
{
    /* 在入口函数中调用platform_driver_register, 注册platform驱动 */
    return platform_driver_register(&led_driver);
}

/* 驱动出口函数 */
static void __exit gpio_led_dev_exit(void)
{
    /* 在出口函数中调用platform_driver_register, 卸载platform驱动 */
    platform_driver_unregister(&led_driver);
}

/* 标记加载、卸载函数 */ 
module_init(gpio_led_drv_init);
module_exit(gpio_led_dev_exit);

/* 驱动描述信息 */  
MODULE_AUTHOR("Alinx");  
MODULE_ALIAS("gpio_led");  
MODULE_DESCRIPTION("MISC LED driver");  
MODULE_VERSION("v1.0");  
MODULE_LICENSE("GPL"); 





































