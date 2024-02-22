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
#include <linux/of.h>
#include <linux/cdev.h>
#include <linux/device.h>
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

/* 设备节点名称 */  
#define DEVICE_NAME       "ax_pwm"
/* 设备号个数 */  
#define DEVID_COUNT       1
/* 驱动个数 */  
#define DRIVE_COUNT       1
/* 主设备号 */
#define MAJOR_AX
/* 次设备号 */
#define MINOR_AX       
/* 设置频率 */
#define PWM_FREQ           0x100001
/* 设置占空比 */
#define PWM_DUTY           0x100002   

/* 把驱动代码中会用到的数据打包进设备结构体 */
struct alinx_char_dev{
    dev_t              devid;       //设备号
    struct cdev        cdev;        //字符设备
	struct device_node *nd;         //设备树的设备节点
	unsigned int       *freq;       //频率的寄存器虚拟地址
	unsigned int       *duty;       //占空比的寄存器虚拟地址
};
/* 声明设备结构体 */
static struct alinx_char_dev alinx_char = {
    .cdev = {
        .owner = THIS_MODULE,
    },
};

/* open函数实现, 对应到Linux系统调用函数的open函数 */  
static int ax_pwm_open(struct inode *inode_p, struct file *file_p)  
{  
    /* 设置私有数据 */
    file_p->private_data = &alinx_char;  
      
    return 0;  
}  

/* iotcl函数实现, 对应到Linux系统调用函数的iotcl函数 */  
static long ax_pwm_ioctl(struct file *file_p, unsigned int cmd, unsigned long arg)
{   
    /* 获取私有数据 */
	struct alinx_char_dev *dev = file_p->private_data;
    
    switch(cmd) 
    {
        case PWM_FREQ:
        {
            *(dev->freq) = (unsigned int)arg;
            break;
        }
            
        case PWM_DUTY: 
        {
            *(dev->duty) = (unsigned int)arg;
            break;
        }
        
        default :
        {
            break;
        }
    }
    
    return 0;
}

/* release函数实现, 对应到Linux系统调用函数的close函数 */  
static int ax_pwm_release(struct inode *inode_p, struct file *file_p)  
{   
    return 0;  
}  

/* file_operations结构体声明 */
static struct file_operations ax_char_fops = {  
    .owner          = THIS_MODULE,  
    .open           = ax_pwm_open,  
    .unlocked_ioctl = ax_pwm_ioctl,     
    .release        = ax_pwm_release,   
};

/* MISC设备结构体 */
static struct miscdevice led_miscdev = {
    /* 自动分配次设备号 */
	.minor = MISC_DYNAMIC_MINOR,
	.name = DEVICE_NAME,
    /* file_operations结构体 */
	.fops = &ax_char_fops,
};

/* probe函数实现, 驱动和设备匹配时会被调用 */
static int ax_pwm_probe(struct platform_device *dev)
{	
    /* 用于接受返回值 */
	u32 ret = 0;
    /* 频率的寄存器物理地址 */
	int freq_addr;   
    /* 占空比的寄存器物理地址 */
	int duty_addr;   
	
	/* 获取设备节点 */
	alinx_char.nd = of_find_node_by_path("/alinxpwm");
	if(alinx_char.nd == NULL)	
    {
		printk("gpioled node nost find\r\n");
		return -EINVAL;
	}

    /* 获取寄存器中freq的地址 */
    of_property_read_u32(alinx_char.nd, "reg-freq", &freq_addr);
	if(!freq_addr)	{
		printk("can not get reg-freq\r\n");
		return -EINVAL;
	}
	else
	{
		/* 映射地址 */
		alinx_char.freq = ioremap(freq_addr, 4);
	}
    
    /* 获取寄存器中duty的地址 */
    of_property_read_u32(alinx_char.nd, "reg-duty", &duty_addr);
	if(!duty_addr)	{
		printk("can not get reg-duty\r\n");
		iounmap((unsigned int *)alinx_char.freq);
		return -EINVAL;
	}
	else
	{
		/* 映射地址 */
		alinx_char.duty = ioremap(duty_addr, 4);
	}
     
    /* 注册misc设备 */
    ret = misc_register(&led_miscdev);
	if(ret < 0) {
		printk("misc device register failed\r\n");
		return -EFAULT;
	}
    
    return 0;
}

static int ax_pwm_remove(struct platform_device *dev)
{
    /* 释放虚拟地址 */
    iounmap((unsigned int *)alinx_char.freq);
	iounmap((unsigned int *)alinx_char.duty);
    /* 注销misc设备 */
    misc_deregister(&led_miscdev);
    return 0;
}

/* 初始化of_match_table */
static const struct of_device_id pwm_of_match[] = {
    /* compatible字段和设备树中保持一致 */
	{ .compatible = "alinx-pwm" },
	{/* Sentinel */}
};


/* 声明并初始化platform驱动 */
static struct platform_driver pwm_driver = {
    .driver = {
        /* name字段需要保留 */
        .name = "alinx-pwm",
        /* 用of_match_table代替name匹配 */
        .of_match_table = pwm_of_match,
    },
    .probe  = ax_pwm_probe,
    .remove = ax_pwm_remove,
};

/* 驱动入口函数 */
static int __init pwm_drv_init(void)
{
    /* 在入口函数中调用platform_driver_register, 注册platform驱动 */
    return platform_driver_register(&pwm_driver);
}

/* 驱动出口函数 */
static void __exit pwm_drv_exit(void)
{
    /* 在出口函数中调用platform_driver_register, 卸载platform驱动 */
    platform_driver_unregister(&pwm_driver);
}

/* 标记加载、卸载函数 */ 
module_init(pwm_drv_init);
module_exit(pwm_drv_exit);

/* 驱动描述信息 */  
MODULE_AUTHOR("Alinx");  
MODULE_ALIAS("pwm_led");  
MODULE_DESCRIPTION("PWM LED driver");  
MODULE_VERSION("v1.0");  
MODULE_LICENSE("GPL"); 






































