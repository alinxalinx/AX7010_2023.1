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
#include <linux/slab.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/usb/input.h>
#include <linux/hid.h>

/* 定义一个输入事件, 表示鼠标的点击事件 */
static struct input_dev *mouse_dev;
/* 定义缓冲区首地址 */
static char             *usb_buf;
/* dma缓冲区 */
static dma_addr_t       usb_buf_dma;
/* 缓冲区长度 */
static int              usb_buf_len;
/* 定义一个urb */
static struct urb       *mouse_urb;

static void ax_usb_irq(struct urb *urb)
{
    static unsigned char pre_sts;
    int i;

    /* 左键发生了变化 */
    if ((pre_sts & 0x01) != (usb_buf[0] & 0x01))
    {
        printk("lf click\n");
        input_event(mouse_dev, EV_KEY, KEY_L, (usb_buf[0] & 0x01) ? 1 : 0);
        input_sync(mouse_dev);
    }

    /* 右键发生了变化 */
    if ((pre_sts & 0x02) != (usb_buf[0] & 0x02))
    {
        printk("rt click\n");
        input_event(mouse_dev, EV_KEY, KEY_S, (usb_buf[0] & 0x02) ? 1 : 0);
        input_sync(mouse_dev);
    }
    
    /* 记录当前状态 */
    pre_sts = usb_buf[0];

    /* 重新提交urb */
    usb_submit_urb(mouse_urb, GFP_KERNEL);
}

static int ax_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
{
    /* 获取usb_device */
    struct usb_device *dev = interface_to_usbdev(intf);
    struct usb_host_interface *interface;
    struct usb_endpoint_descriptor *endpoint;
    int pipe;
        
    /* 获取端点 */
    interface = intf->cur_altsetting;
    endpoint = &interface->endpoint[0].desc;

    /* 分配input_dev */
    mouse_dev = input_allocate_device();
    /* 设置input_dev */
    set_bit(EV_KEY, mouse_dev->evbit);
    set_bit(EV_REP, mouse_dev->evbit);
    set_bit(KEY_L, mouse_dev->keybit);
    set_bit(KEY_S, mouse_dev->keybit);
    /* 注册input_dev */
    input_register_device(mouse_dev);
    
    /* 获取USB设备端点对应的管道 */
    pipe = usb_rcvintpipe(dev, endpoint->bEndpointAddress);

    /* 获取端点最大长度作为缓冲区长度 */
    usb_buf_len = endpoint->wMaxPacketSize;

    /* 分配缓冲区 */
    usb_buf = usb_alloc_coherent(dev, usb_buf_len, GFP_ATOMIC, &usb_buf_dma);

    /* 创建urb */
    mouse_urb = usb_alloc_urb(0, GFP_KERNEL);
    
    /* 分配urb" */
    usb_fill_int_urb(mouse_urb, dev, pipe, usb_buf, usb_buf_len, ax_usb_irq, NULL, endpoint->bInterval);
    mouse_urb->transfer_dma = usb_buf_dma;
    mouse_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;

    /* 提交urb */
    usb_submit_urb(mouse_urb, GFP_KERNEL);
    
    return 0;
}

static void ax_usb_disconnect(struct usb_interface *intf)
{
    struct usb_device *dev = interface_to_usbdev(intf);

    /* 主动结束urb */
    usb_kill_urb(mouse_urb);
    /* 释放urb */
    usb_free_urb(mouse_urb);
    /* 释放缓冲区 */
    usb_free_coherent(dev, usb_buf_len, usb_buf, &usb_buf_dma);
    /* 注销输入事件 */
    input_unregister_device(mouse_dev);
    /* 释放输入事件 */
    input_free_device(mouse_dev);
}

/* 定义初始化id_table */
static struct usb_device_id ax_usb_id_table [] = {
    /* 鼠标mouse接口描述符里类是HID类，子类boot，协议mouse */
    { 
        USB_INTERFACE_INFO(USB_INTERFACE_CLASS_HID, 
                           USB_INTERFACE_SUBCLASS_BOOT, 
                           USB_INTERFACE_PROTOCOL_MOUSE) 
    }, { }
};

/* 定义并初始化usb_driver */
static struct usb_driver ax_usb_driver = {
    .name       = "ax_usb_test",
    .probe      = ax_usb_probe,
    .disconnect = ax_usb_disconnect,
    .id_table   = ax_usb_id_table,
};

/* 驱动入口函数 */
static int ax_usb_init(void)
{
    /* 注册usb_driver */
    return usb_register(&ax_usb_driver);
}

/* 驱动出口函数 */
static void ax_usb_exit(void)
{
    /* 注销usb_driver */
    usb_deregister(&ax_usb_driver);    
}

/* 标记加载、卸载函数 */ 
module_init(ax_usb_init);
module_exit(ax_usb_exit);

/* 驱动描述信息 */  
MODULE_AUTHOR("Alinx");  
MODULE_ALIAS("pwm_led");  
MODULE_DESCRIPTION("USB TEST driver");  
MODULE_VERSION("v1.0");  
MODULE_LICENSE("GPL"); 



