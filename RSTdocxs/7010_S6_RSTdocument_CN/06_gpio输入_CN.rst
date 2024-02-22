gpio输入
===============

本章我们做一个gpio输出的实验，巩固一下pinctrl和gpio子系统，同时也为后面的学习做铺垫。

gpio输出最经典的例子就是按键，我们就用按键来做个简单的gpio输入实验。实验的目标是应用程序通过read函数读取按键状态，如果按键被按下，就反转一次led的电平。用按键控制led的亮灭。

原理图
----------

led部分和 **字符设备** 章节相同。

key部分，使用板子上的ps_key1，查看原理图，对应到原理图上的KEY2，key的另一端是接地的。按下按键MIO_KEY1就会被拉低。

.. image:: images/06_media/image1.png

再找到MIO_KEY1连接的IO，为MIO50。

.. image:: images/06_media/image2.png

设备树
----------

打开system-user.dtsi文件，在根节点中添加下面的节点：

.. code:: c
   
    amba {
        slcr@f8000000 {
            pinctrl@700 {
                pinctrl_led_default: led-default {  
                    mux {  
                        groups = "gpio0_0_grp";  
                        function = "gpio0";  
                    };  

                    conf {  
                        pins = "MIO0"; 
                        io-standard = <1>; 
                        bias-disable;  
                        slew-rate = <0>;  
                    };      
                }; 
                pinctrl_key_default: key-default {
                    mux {
                        groups = "gpio0_50_grp";
                        function = "gpio0";
                    };

                    conf {
                        pins = "MIO50";
                        io-standard = <1>;
                        bias-high-impedance;
                        slew-rate = <0>;
                    };
                };
            };
        };
    };

    alinxled {
        compatible = "alinx-led";
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_led_default>;
        alinxled-gpios = <&gpio0 0 0>;
    };

    alinxkey {
        compatible = "alinx-key";
        pinctrl-names = "default";
        pinctrl-0 = <&pinctrl_key_default>;
        alinxkey-gpios = <&gpio0 50 0>;
    }; 

其中led相关的部分和之前是一样的。

key使用的IO是MIO50，所以groups = "gpio0_50_grp"、pins = "MIO50"、alinxkey-gpio = <&gpio0 50 0>。输入引脚电气特性配置成高阻bias-high-impedance。

6.3 驱动代码
------------

使用petalinux新建驱动名为”ax-key-dev”，在ax-key-dev中输入以下代码：


.. code:: c

 #include <linux/module.h>  
 #include <linux/kernel.h>  
 #include <linux/fs.h>  
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
 #include <linux/delay.h>
 #include <asm/uaccess.h>
 #include <asm/mach/map.h>
 #include <asm/io.h>
   
 /* 设备节点名称 */  
 #define DEVICE_NAME       "gpio_key"
 /* 设备号个数 */  
 #define DEVID_COUNT       1
 /* 驱动个数 */  
 #define DRIVE_COUNT       1
 /* 主设备号 */
 #define MAJOR1
 /* 次设备号 */
 #define MINOR1            0
 
 /* 把驱动代码中会用到的数据打包进设备结构体 */
 struct alinx_char_dev{
     dev_t              devid;             //设备号
     struct cdev        cdev;              //字符设备
     struct class       *class;            //类
     struct device      *device;           //设备
     struct device_node *nd;               //设备树的设备节点
     int                alinx_key_gpio;    //gpio号
 };
 /* 声明设备结构体 */
 static struct alinx_char_dev alinx_char = {
     .cdev = {
         .owner = THIS_MODULE,
     },
 };
 
 /* open函数实现, 对应到Linux系统调用函数的open函数 */  
 static int gpio_key_open(struct inode *inode_p, struct file *file_p)  
 {
     /* 设置私有数据 */
     file_p->private_data = &alinx_char;
     printk("gpio_test module open\n");  
     return 0;  
 }  
   
   
 /* write函数实现, 对应到Linux系统调用函数的write函数 */  
 static ssize_t gpio_key_read(struct file *file_p, char __user *buf, size_t len, loff_t *loff_t_p)  
 {  
     int ret = 0;
     /* 返回按键的值 */
 	unsigned int key_value = 0;
     /* 获取私有数据 */
     struct alinx_char_dev *dev = file_p->private_data;
   
     /* 检查按键是否被按下 */
     if(0 == gpio_get_value(dev->alinx_key_gpio))
     {
         /* 按键被按下 */
         /* 防抖 */
         mdelay(50);
         /* 等待按键抬起 */
         while(!gpio_get_value(dev->alinx_key_gpio));
         key_value = 1;
     }
     else
     {
         /* 按键未被按下 */
     }
     /* 返回按键状态 */
     ret = copy_to_user(buf, &key_value, sizeof(key_value));
     
     return ret;  
 }  
   
 /* release函数实现, 对应到Linux系统调用函数的close函数 */  
 static int gpio_key_release(struct inode *inode_p, struct file *file_p)  
 {  
     printk("gpio_test module release\n");  
     return 0;  
 }  
       
 /* file_operations结构体声明, 是上面open、write实现函数与系统调用函数对应的关键 */  
 static struct file_operations ax_char_fops = {  
     .owner   = THIS_MODULE,  
     .open    = gpio_key_open,  
     .read    = gpio_key_read,     
     .release = gpio_key_release,   
 };  
   
 /* 模块加载时会调用的函数 */  
 static int __init gpio_key_init(void)  
 {
     /* 用于接受返回值 */
     u32 ret = 0;
     
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
     
     /* 注册设备号 */
     alloc_chrdev_region(&alinx_char.devid, MINOR1, DEVID_COUNT, DEVICE_NAME);
     
     /* 初始化字符设备结构体 */
     cdev_init(&alinx_char.cdev, &ax_char_fops);
     
     /* 注册字符设备 */
     cdev_add(&alinx_char.cdev, alinx_char.devid, DRIVE_COUNT);
     
     /* 创建类 */
     alinx_char.class = class_create(THIS_MODULE, DEVICE_NAME);
     if(IS_ERR(alinx_char.class)) 
     {
         return PTR_ERR(alinx_char.class);
     }
     
     /* 创建设备节点 */
     alinx_char.device = device_create(alinx_char.class, NULL, 
                                       alinx_char.devid, NULL, 
                                       DEVICE_NAME);
     if (IS_ERR(alinx_char.device)) 
     {
         return PTR_ERR(alinx_char.device);
     }
     
     return 0;  
 }
 
 /* 卸载模块 */  
 static void __exit gpio_key_exit(void)  
 {  
     /* 释放gpio */
     gpio_free(alinx_char.alinx_key_gpio);
 
     /* 注销字符设备 */
     cdev_del(&alinx_char.cdev);
     
     /* 注销设备号 */
     unregister_chrdev_region(alinx_char.devid, DEVID_COUNT);
     
     /* 删除设备节点 */
     device_destroy(alinx_char.class, alinx_char.devid);
     
     /* 删除类 */
     class_destroy(alinx_char.class);
        
     printk("gpio_key_dev_exit_ok\n");  
 }  
   
 /* 标记加载、卸载函数 */  
 module_init(gpio_key_init);  
 module_exit(gpio_key_exit);  
   
 /* 驱动描述信息 */  
 MODULE_AUTHOR("Alinx");  
 MODULE_ALIAS("gpio_key");  
 MODULE_DESCRIPTION("GPIO OUT driver");  
 MODULE_VERSION("v1.0");  
 MODULE_LICENSE("GPL");  


和 **pinctrl和gpio子系统** 章节的很相似。

**138**\ 原先是设置成输出，改成了输入。

**59~82**\ 行原先的write函数变成了read。每次read就用gpio_get_value函数读取一下IO的电平，如果检测到低电平，则按键被按下，按键按下后则是常规的延时去抖，等待抬起。

read函数最后要把读到的电平返回给用户buf。

测试代码
------------

新建QT工程名为”ax-key-test”，新建main.c，输入下列代码：

.. code:: c

 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
 #include <fcntl.h>

 int main(int argc, char *argv[])
 {
     int fd, fd_l ,ret;
     char *filename, led_value = 0;
     unsigned int key_value;
 
     /* 验证输入参数个数 */
     if(argc != 2)
     {
         printf("Error Usage\r\n");
         return -1;
     }
 
     /* 打开输入的设备文件, 获取文件句柄 */
     filename = argv[1];
     fd = open(filename, O_RDWR);
     if(fd < 0)
     {
         /* 打开文件失败 */
         printf("file %s open failed\r\n", argv[1]);
         return -1;
     }
 
     while(1)
     {
         /* 读取按键状态 */
         ret = read(fd, &key_value, sizeof(key_value));
         if(ret < 0)
         {
             printf("read failed\r\n");
             break;
         }
         /* 按键被按下 */
         if(1 == key_value)
         {
             printf("ps_key1 press\r\n");
             led_value = !led_value;
 
             /* 用设备节点/dev/gpio_leds, 点亮led */
             fd_l = open("/dev/gpio_leds", O_RDWR);
             if(fd_l < 0)
             {
                 printf("file /dev/gpio_leds open failed\r\n");
                 break;
             }
 
             ret = write(fd_l, &led_value, sizeof(led_value));
             if(ret < 0)
             {
                 printf("write failed\r\n");
                 break;
             }
 
             ret = close(fd_l);
             if(ret < 0)
             {
                 printf("file /dev/gpio_leds close failed\r\n");
                 break;
             }
         }
     }
 
     ret = close(fd);
     if(ret < 0)
     {
         printf("file %s close failed\r\n", argv[1]);
         return -1;
     }
 
     return 0;
 }



因为要点灯，所以还要用到前面led的设备节点，这边就直接用设备节点/dev/gpio_leds了，在测试时记得加载led驱动就行了。

在\ **26**\ 行的while循环里，不停的去调用read函数读取按键状态，一旦读取到按键被按下，就去对led的io进行写操作，每次写入相反的值以达到每一次按键led状态反转的效果。

运行测试
------------

因为修改了设备树，所以要跟新sd卡中image.ub文件。因为同时用到了led和key，所以要加载两个驱动，led驱动用上面任意一章的都行。步骤如下：

+-----------------------------------------------------------------------+
| mount -t nfs -o nolock 192.168.1.107:/home/alinx/work /mnt            |
|                                                                       |
| cd /mnt                                                               |
|                                                                       |
| mkdir /tmp/qt                                                         |
|                                                                       |
| mount qt_lib.img /tmp/qt                                              |
|                                                                       |
| cd /tmp/qt                                                            |
|                                                                       |
| source ./qt_env_set.sh                                                |
|                                                                       |
| cd /mnt                                                               |
|                                                                       |
| insmod ./ax-concled-drv.ko                                            |
|                                                                       |
| insmod ./ax-key-drv.ko                                                |
|                                                                       |
| cd ./build-ax-key-test-ZYNQ-Debug/                                    |
|                                                                       |
| ./ax-key-test /dev/gpio_key                                           |
+-----------------------------------------------------------------------+

IP和路径根据实际情况调整。

操作结果如下图：

.. image:: images/06_media/image3.png

.. image:: images/06_media/image4.png

执行app后，打印出的第一句” gpio_test module
open”是open函数打开/dev/gpio_key设备时打印出来的，之后按下按键，led的状态就反转一次并打印ps_key1
press、gpio_test module open、gpio_test module release三行信息。


