中断
===========

中断是很常用的功能，Linux内核中也实现了完善的中断框架，这一章来学习一下Linux内核中中断的简单用法。

Linux中断框架简介
---------------------

接口函数
~~~~~~~~~~~~~~

Linux内核中的中断框架使用已经相当便捷，一般需要做三件事申请中断、实现中断服务函数、使能中断。对应的接口函数如下：

(一) 中断申请和释放函数

1) 中断申请函数request_irq，该函数可能会导致睡眠，在申请成功后会使能中断，函数原型：

+-----------------------------------------------------------------------+
| Int request_irq(unsigned int irq, irq_handler_t handler, unsigned     |
| long flags, const char \*name, void \*dev);                           |
+-----------------------------------------------------------------------+

参数说明：

**irq**\ ：申请的中断号，中断号也可以叫中断线，是中断的唯一标识，也是内核找到对应中断服务函数的依据。

**handler**\ ：中断服务函数，中断触发后会执行的函数。

**flags**\ ：中断标志，用于设置中断的触发方式和其他特性，常用的标识有：

.. code:: c

 /* 无触发 */
 IRQF_TRIGGER_NONE
 /* 上升沿触发 */
 IRQF_TRIGGER_RISING
 /* 下降沿触发 */
 IRQF_TRIGGER_FALLING
 /* 高电平触发 */
 IRQF_TRIGGER_HIGH
 /* 低电平触发 */
 IRQF_TRIGGER_LOW
 /* 单次中断 */
 IRQF_ONESHOT
 /* 作为定时器中断 */
 IRQF_TIMER
 /* 共享中断，多个设备共享一个中断号时需要此标志 */
 IRQF_SHARED


可在/include/linux/interrupt.h文件中可以查看全部的flag和英文释义。中断标志可以使用|号来组合，如IRQF_TRIGGER_RISING\|
IRQF_ONESHOT意为上升沿触发的单次中断。

**name**\ ：中断名称，申请中断成功后，在/proc/interrupts文件中可以找到这个名字。

**dev**\ ：flag设置IRQF_SHARED时，使用dev来区分不同的设备，dev的值会传递给中断服务函数的第二个参数。

**返回值**\ ：0-申请成功，-EBUSY-中断已被占用，其他值都表示申请失败。

2) 和中断申请相对的中断释放函数free_irq，如果目标中断不是共享中断，那么free_irq函数在释放中断后，会禁止中断并删除中断服务函数，原型如下：

+-----------------------------------------------------------------------+
| void free_irq(unsigned int irq, void \*dev);                          |
+-----------------------------------------------------------------------+

参数说明：

**irq**\ ：需要释放的中断。

**dev**\ ：释放的中断如果是共享中断，用这个参数来区分具体的中断，只有共享中断下所有的dev都被释放时，free_irq函数才会禁止中断并删除中断服务函数。

(二) 实现服务申请函数

中断服务函数的格式为：

+-----------------------------------------------------------------------+
| irqreturn_t (\*irq_handler_t) (int, void \*)                          |
+-----------------------------------------------------------------------+

第一个参数int型时中断服务函数对应的中断号。

第二个参数是通用指针，需要和request_irq函数的参数dev一致。

返回值irqreturn_t为美剧类型，一般在服务函数中用下面的方式返回值：

+-----------------------------------------------------------------------+
| return IRQ_RETVAL(IRQ_HANDLED);                                       |
+-----------------------------------------------------------------------+

(三) 中断使能和禁止函数

1) enable_irq(unsigned int irq)、disable_irq(unsigned int
   irq)和disable_irq_nosync(unsigned int irq)

enable_irq和disable_irq分别是中断使能和禁止函数，irq是目标中断号。disable_irq会等待目标中断的中断服务函数执行结束才会禁止中断，如果想要立即禁止中断则可以使用disable_irq_nosync()函数。

2) local_irq_enable()和local_irq_disable()

local_irq_enable()函数用于使能当前处理器的中断系统。

local_irq_disable()函数用于禁止当前处理器的中断系统。

3) local_irq_save(flags)和local_irq_restore(flags)

local_irq_save(flags)函数也是用于禁止当前处理器中断，但是会把进之前的中断状态保存在输入参数flags中。而local_irq_restore(flags)函数则是把中断恢复到flags中记录的状态。

Linux的下半部机制
~~~~~~~~~~~~~~~~~~~~~~~

上半部下半部是为了尽量缩短中断服务函数的处理过程而引入的机制，上半部就是中断触发后立即执行的中断服务函数，而下半部就是对中断服务函数的延时处理。因为中断的优先级较高，如果处理内容过多，长时间占用处理器会影响其他代码的运行，所以上半部要尽量的短。裸机程序里，在中断处理函数中树flag，然后到主程序大循环中去轮询判断这个flag再做相应的操作，就是一种上半部下半部的思想。Linux中的上半部就是指中断服务函数irq_handler_t。至于那些任务放在上半部哪些放在下半部，没有明确的界限，一般我们把对时间敏感、不能被打断的任务放到上半部中，其他的都可以考虑放到下半部。

Linux针对下半部也提供了一些完善的机制：

1) 软中断

软中断结构体定义在include/linux/interrupt.h文件中，具体如下：

.. code:: c

 struct softirq_action
 {
 void (*action)(struct softirq_action *);
 };


内核在kernel/softirq.c文件中定义了全局的软中断向量表：

+-----------------------------------------------------------------------+
| static struct softirq_action softirq_vec[NR_SOFTIRQS];                |
+-----------------------------------------------------------------------+

NR_SOFTIRQS为枚举类型的最大值，该枚举类型定义在include/linux/interrupt.h中：

.. code:: c

 enum
 {
 HI_SOFTIRQ=0,
 TIMER_SOFTIRQ,
 NET_TX_SOFTIRQ,
 NET_RX_SOFTIRQ,
 BLOCK_SOFTIRQ,
 IRQ_POLL_SOFTIRQ,
 TASKLET_SOFTIRQ,
 SCHED_SOFTIRQ,
 HRTIMER_SOFTIRQ,
 RCU_SOFTIRQ,
 NR_SOFTIRQS
 };

代表了十个软中断，要使用软中断只能向内核定义的软中断向量表注册，注册软中断需要使用函数：

+-----------------------------------------------------------------------+
| void (int nr, void (\*action)(struct softirq_action \*));             |
+-----------------------------------------------------------------------+

参数说明：

**nr**\ ：小于NR_SOFTIRQS的枚举值。

**action**\ ：对应的软中断服务函数。

软中断必须在编译时静态注册，注册完成就需要使用raise_softirq(unsigned int
nr)触发，nr即为需要触发的软中断。

但下半部机制通常不用软中断，而是使用下面要讲的tasklets机制。

2) tasklets机制

Linux内核在softirq_int函数中初始化软中断，其中HI_SOFTIRQ和TASKLET_SOFTIRQ是默认打开的。tasklets机制就是在这两个软中断基础上实现的。

tasklets的结构体也定义在头文件include/linux/interrupt.h中，定义如下：

.. code:: c

 struct tasklet_struct
 {
 struct tasklet_struct *next;
 unsigned long state;
 atomic_t count;
 void (*func)(unsigned long);
 unsigned long data;
 };
 

其中func就是相当于是tasklet的中断服务函数，tasklet的定义和初始化可以直接用下面的宏定义来完成：

+-----------------------------------------------------------------------+
| DECLARE_TASKLET(name, func, data)                                     |
+-----------------------------------------------------------------------+

**name**\ ：tasklet的名字。

**func**\ ：tasklet触发时的处理函数。

**data**\ ：传递给func的输入参数。

初始化完成后，调用以下函数即可激活tesklet：

+-----------------------------------------------------------------------+
| tasklet_schedule(struct tasklet_struct \*t)                           |
+-----------------------------------------------------------------------+

激活后tesklet的服务函数就会在合适的时间运行。用作中断的下半段时，就在上半段中调用该函数。如果要用优先级较高的tasklet，就使用tasklet_hi_schedule(struct
tasklet_struct \*t)函数激活。

tasklet的下半段机制使用示例：

.. code:: c

 /* 定义 taselet */
 struct tasklet_struct example;
 /* tasklet 处理函数 */
 void testtasklet_func(unsigned long data)
 {
 /* tasklet 具体处理内容 */
 }
 /* 中断处理函数 */
 irqreturn_t test_handler(int irq, void *dev_id)
 {
 /* 调度 tasklet */
 tasklet_schedule(&example);
 }
 /* 驱动入口函数 */
 static int __init xxxx_init(void)
 {
 /* 初始化 tasklet */
 tasklet_init(&example, testtasklet_func, data);
 /* 注册中断处理函数 */
 request_irq(irq, test_handler, 0, "name", &dev);
 }

3) 工作队列

工作队列也是下半部的实现方案。与tasklet相对的，工作队列是可阻塞的，因此不能在中断上下文中运行。工作队列的队列实现我们可以不用去管，要使用工作队列，只要定一个工作即可。

工作结构体为work_struct，定义在/include/linux/workqueue.h文件中：

.. code:: c

 struct work_struct {
 atomic_long_t data;
 struct list_head entry;
 work_func_t func;
 #ifdef CONFIG_LOCKDEP
 struct lockdep_map lockdep_map;
 #endif
 };

func即为需要处理的函数。可使用以下宏定义来创建并初始化工作：

+-----------------------------------------------------------------------+
| DECLARE_WORK(n, f)                                                    |
+-----------------------------------------------------------------------+

**n**\ ：需要创建并初始化的工作结构体work_struct的名称。

**f**\ ：工作队列需要处理的函数。

初始化完成后，使用下面的函数来调用工作队列：

+-----------------------------------------------------------------------+
| bool schedule_work(struct work_struct \*work)                         |
+-----------------------------------------------------------------------+

work：需要调用的工作。

返回值：0成功，1失败。

workqueue的下半段机制使用示例：

.. code:: c

 /* 定义工作(work) */
 struct work_struct example;
 /* work 处理函数 */
 void work_func_t(struct work_struct *work);
 {
 /* work 具体处理内容 */
 }
 /* 中断处理函数 */
 irqreturn_t test_handler(int irq, void *dev_id)
 {
 /* 调度 work */
 schedule_work(&example);
 }
 /* 驱动入口函数 */
 static int __init xxxx_init(void)
 {
 ......
 /* 初始化 work */
 INIT_WORK(&example, work_func_t);
 /* 注册中断处理函数 */
 

设备树中的中断
~~~~~~~~~~~~~~~~~~~~

设备树中，通用的中断设置方法可参考文档Documentation/devicetree/bindings/arm/arm,gic.txt。Xilinx的设备树中断控制器的设置与Linux内核的通用设置稍有区别，可以查看文档Documentation/devicetree/bindings/arm/xilinx,intc.txt了解详情。看这个文件最后的一段例子：

.. code:: c

 axi_intc_0: interrupt-controller@41800000 {
 #interrupt-cells = <2>;
 compatible = "xlnx,xps-intc-1.00.a";
 interrupt-controller;
 interrupt-parent = <&ps7_scugic_0>;
 interrupts = <0 29 4>;
 reg = <0x41800000 0x10000>;
 xlnx,kind-of-intr = <0x1>;
 xlnx,num-intr-inputs = <0x1>;
 };

回头看一下gpio子系统的章节，那时候讲gpio的设备树时，就已经出现了这几个中断相关的属性。

第2行的"#interrupt-cells"是中断控制器节点的属性，用来描述子节点中"interrupts"属性值的数量。一般父节点的"#interrupt-cells"值为3，则子节点的"interrupts"一个cell的三个32位整数的值为<中断域
中断号 触发方式>，如果父节点的该属性是2，则是<中断号 触发方式>。

第4行的属性"interrupt-controller"代表这个节点是一个中断控制器。

第5行的"interrupt-parent"属性表明这个设备属于哪个中断控制器，如果没有这个属性会自动依附于父节点的"interrupt-parent"。

第6行的"interrupts"，第一个值为0表示SPI中断，1表示PPI中断。在zynq中，第一个值如果是0，则中断号等于第二个值加32。

第8行的"xlnx,kind-of-intr"表示为每个可能的中断指定中断类型，1表示edge，0表示level。

第9行"xlnx,num-intr-inputs"属性指定控制器的特定实现支持的中断数，范围是1~32。

我们需要从设备树中获取设备号信息，以向内核注册中断，of函数中有对应的函数：

+-----------------------------------------------------------------------+
| unsigned int irq_of_parse_and_map(struct device_node \*dev, int       |
| index);                                                               |
+-----------------------------------------------------------------------+

dev是设备节点

index是对属性"interrupts"元素的索引，因为中断号的位置有可能不同。

返回值就是中断号。

要使用这个函数的话，需要我们在对应的设备中设置好"interrupts"属性。

对于gpio，内核提供了更方便的函数获取中断号：

+-----------------------------------------------------------------------+
| int gpio_to_irq(unsigned int gpio);                                   |
+-----------------------------------------------------------------------+

gpio为需要申请中断号的gpio编号。

返回值就是中断号。

zynq下gpio是共享的一个中断，针对单个io去设置"interrupts"属性比较麻烦，gpio_to_irq函数帮我们做了很多事，后面的gpio中断实验，我们就直接使用这个函数。

实验
--------

这章写一个通过按键中断驱动，按下按键触发中断，触发中断后，在中断服务函数中开启一个50ms的定时器来实现按键去抖。

原理图
~~~~~~~~~~~

led部分和 **字符设备** 章节相同。

key部分和章节 **gpio输入** 章节相同。

设备树
~~~~~~~~~~~

和 **gpio输入** 章节相同。

驱动程序
~~~~~~~~~~~~~

使用 petalinux 新建名为”ax-irq-drv”的驱劢程序，并执行 petalinux-config
-c rootfs 命令选上新增的驱动程序。

在 ax-irq-drv.c 文件中输入下面的代码：


.. code:: c
   
 #include <linux/module.h>  
 #include <linux/kernel.h>
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
 #include <asm/uaccess.h>
 #include <asm/mach/map.h>
 #include <asm/io.h>
   
 /* 设备节点名称 */  
 #define DEVICE_NAME       "interrupt_led"
 /* 设备号个数 */  
 #define DEVID_COUNT       1
 /* 驱动个数 */  
 #define DRIVE_COUNT       1
 /* 主设备号 */
 #define MAJOR_U
 /* 次设备号 */
 #define MINOR_U           0
 
 /* 把驱动代码中会用到的数据打包进设备结构体 */
 struct alinx_char_dev {
 /** 字符设备框架 **/
     dev_t              devid;             //设备号
     struct cdev        cdev;              //字符设备
     struct class       *class;            //类
     struct device      *device;           //设备
     struct device_node *nd;               //设备树的设备节点
 /** 并发处理 **/
     spinlock_t         lock;              //自旋锁变量
 /** gpio **/    
     int                alinx_key_gpio;    //gpio号
     int                key_sts;           //记录按键状态, 为1时被按下
 /** 中断 **/
     unsigned int       irq;               //中断号
 /** 定时器 **/
     struct timer_list  timer;             //定时器
 };
 /* 声明设备结构体 */
 static struct alinx_char_dev alinx_char = {
     .cdev = {
         .owner = THIS_MODULE,
     },
 };
 
 /** 回掉 **/
 /* 中断服务函数 */
 static irqreturn_t key_handler(int irq, void *dev)
 {
     /* 按键按下或抬起时会进入中断 */
     /* 开启50毫秒的定时器用作防抖动 */
     mod_timer(&alinx_char.timer, jiffies + msecs_to_jiffies(50));
     return IRQ_RETVAL(IRQ_HANDLED);
 }
 
 /* 定时器服务函数 */
 void timer_function(struct timer_list *timer)
 {
     unsigned long flags;
     /* 获取锁 */
     spin_lock_irqsave(&alinx_char.lock, flags);
 
     /* value用于获取按键值 */
     unsigned char value;
     /* 获取按键值 */
     value = gpio_get_value(alinx_char.alinx_key_gpio);
     if(value == 0)
     {
         /* 按键按下, 状态置1 */
         alinx_char.key_sts = 1;
     }
     else
     {
         /* 按键抬起 */
     }
     
     /* 释放锁 */
     spin_unlock_irqrestore(&alinx_char.lock, flags);
 }
 
 /** 系统调用实现 **/
 /* open函数实现, 对应到Linux系统调用函数的open函数 */  
 static int char_drv_open(struct inode *inode_p, struct file *file_p)  
 {  
     printk("gpio_test module open\n");  
     return 0;  
 }  
   
   
 /* read函数实现, 对应到Linux系统调用函数的write函数 */  
 static ssize_t char_drv_read(struct file *file_p, char __user *buf, size_t len, loff_t *loff_t_p)  
 {  
     unsigned long flags;
     int ret;
     /* 获取锁 */
     spin_lock_irqsave(&alinx_char.lock, flags);
     
     /* keysts用于读取按键状态 */
     /* 返回按键状态值 */
     ret = copy_to_user(buf, &alinx_char.key_sts, sizeof(alinx_char.key_sts));
     /* 清除按键状态 */
     alinx_char.key_sts = 0;
     
     /* 释放锁 */
     spin_unlock_irqrestore(&alinx_char.lock, flags);
     return 0;  
 }  
   
 /* release函数实现, 对应到Linux系统调用函数的close函数 */  
 static int char_drv_release(struct inode *inode_p, struct file *file_p)  
 {  
     printk("gpio_test module release\n");
     return 0;  
 }  
       
 /* file_operations结构体声明, 是上面open、write实现函数与系统调用函数对应的关键 */  
 static struct file_operations ax_char_fops = {  
     .owner   = THIS_MODULE,  
     .open    = char_drv_open,  
     .read   = char_drv_read,     
     .release = char_drv_release,   
 };  
   
 /* 模块加载时会调用的函数 */  
 static int __init char_drv_init(void)  
 {
     /* 用于接受返回值 */
     u32 ret = 0;
     
 /** 并发处理 **/
     /* 初始化自旋锁 */
     spin_lock_init(&alinx_char.lock);
     
 /** gpio框架 **/   
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
 
 /** 中断 **/
     /* 获取中断号 */
     alinx_char.irq = gpio_to_irq(alinx_char.alinx_key_gpio);
     /* 申请中断 */
     ret = request_irq(alinx_char.irq,
                       key_handler,
                       IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
                       "alinxkey", 
                       NULL);
     if(ret < 0)
     {
         printk("irq %d request failed\r\n", alinx_char.irq);
         return -EFAULT;
     }
     
 /** 定时器 **/
     __init_timer(&alinx_char.timer, timer_function, 0);
 
 /** 字符设备框架 **/    
     /* 注册设备号 */
     alloc_chrdev_region(&alinx_char.devid, MINOR_U, DEVID_COUNT, DEVICE_NAME);
     
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
 static void __exit char_drv_exit(void)  
 {  
 /** gpio **/
     /* 释放gpio */
     gpio_free(alinx_char.alinx_key_gpio);
 
 /** 中断 **/
     /* 释放中断 */
     free_irq(alinx_char.irq, NULL);
 
 /** 定时器 **/
     /* 删除定时器 */   
     del_timer_sync(&alinx_char.timer);
 
 /** 字符设备框架 **/
     /* 注销字符设备 */
     cdev_del(&alinx_char.cdev);
     
     /* 注销设备号 */
     unregister_chrdev_region(alinx_char.devid, DEVID_COUNT);
     
     /* 删除设备节点 */
     device_destroy(alinx_char.class, alinx_char.devid);
     
     /* 删除类 */
     class_destroy(alinx_char.class);
     
     printk("timer_led_dev_exit_ok\n");  
 }  
   
 /* 标记加载、卸载函数 */  
 module_init(char_drv_init);  
 module_exit(char_drv_exit);  
   
 /* 驱动描述信息 */  
 MODULE_AUTHOR("Alinx");  
 MODULE_ALIAS("alinx char");  
 MODULE_DESCRIPTION("INTERRUPT LED driver");  
 MODULE_VERSION("v1.0");  
 MODULE_LICENSE("GPL");      

187行在驱动入口函数中，初始化gpio之后，使用gpio_to_irq函数通过gpio端口号来获取中断号。

189行通过中断号向内核申请中断。上升沿或下降沿触发，命名为”alinxkey”，中断服务函数为key_handler。

对照前面说的中断步骤，现在我们只要实现key_handler这个函数就可以了。

61行实现了key_handler，内容很简单先是开启了一个50ms的timer，之后返回IRQ_RETVAL(IRQ_HANDLED)就行了。

242行驱动出口函数中把注册的中断号释放。

关于自旋锁保护的对象，实际上就是alinx_char.key_sts这个值，因为这个值在读函数中操作了，在中断开启定时器回掉函数中也操作了，这两个操作是有可能同时发生的，因此需要保护。

测试程序
~~~~~~~~~~~~~

和 **gpio输入** 的测试程序相同。

运行测试
~~~~~~~~~~~~~

测试目标是用板子上的ps key1去控制ps led1，测试步骤如下：

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
| insmod ./ax_irq_drv.ko                                                |
|                                                                       |
| cd ./build-ax-key-test-ZYNQ-Debug                                     |
|                                                                       |
| ./ax-key-test /dev/interrupt_led                                      |
+-----------------------------------------------------------------------+

IP和路径根据实际情况调整。测试现象也与 **gpio输入** 章节相同。

