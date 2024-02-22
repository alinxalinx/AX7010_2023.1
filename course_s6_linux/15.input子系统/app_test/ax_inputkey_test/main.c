/** ===================================================== **
 *Author : ALINX Electronic Technology (Shanghai) Co., Ltd.
 *Website: http://www.alinx.com
 *Address: Room 202, building 18,
           No.518 xinbrick Road,
           Songjiang District, Shanghai
 *Created: 2020-3-2
 *Version: 1.0
 ** ===================================================== **/

#include "stdio.h"
#include "unistd.h"
#include <fcntl.h>
#include <linux/input.h>

static struct input_event inputevent;

/* 点亮火熄灭led */
int led_change_sts()
{
    int fd, ret;
    static char led_value = 0;

    fd = open("/dev/gpio_leds", O_RDWR);
    if(fd < 0)
    {
        printf("file /dev/gpio_leds open failed\r\n");
    }

    led_value = !led_value;
    ret = write(fd, &led_value, sizeof(led_value));

    if(ret < 0)
    {
        printf("write failed\r\n");
    }

    ret = close(fd);
    if(ret < 0)
    {
        printf("file /dev/gpio_leds close failed\r\n");
    }

    return ret;
}

int main(int argc, char *argv[])
{
    int fd;
    int err = 0;
    char *filename;

    filename = argv[1];

    /* 验证输入参数个数 */
    if(argc != 2) {
        printf("Error Usage\r\n");
        return -1;
    }

    /* 打开输入的设备文件, 获取文件句柄 */
    fd = open(filename, O_RDWR);
    if(fd < 0) {
        /* 打开文件失败 */
        printf("can not open file %s\r\n", filename);
        return -1;
    }

    while(1)
    {
        err = read(fd, &inputevent, sizeof(inputevent));
        if(err > 0)
        {
            switch(inputevent.type)
            {
                case EV_KEY:
                    if(KEY_0 == inputevent.code)
                    {
                        if(0 == inputevent.value)
                        {
                            /* 按键抬起 */
                            err = led_change_sts();
                        }
                        else
                        {
                            /* 按键按下 */
                        }
                    }
                    else
                    {
                        /* ignore */
                    }
                    break;

                default :
                    /* ignore */
                    break;
            }

            if(err < 0)
            {
                printf("led open filed");
            }
        }
        else
        {
            printf("get data failed\r\n");
        }
    }

    return 0;
}


