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
#include "sys/types.h"
#include "sys/stat.h"
#include "fcntl.h"
#include "stdlib.h"
#include "string.h"
#include "sys/ioctl.h"

#define FREQ_DEFAULT   1717900
/* 设置频率 */
#define PWM_FREQ       0x100001
/* 设置占空比 */
#define PWM_DUTY       0x100002

int main(int argc, char *argv[])
{
    int fd, retvalue, flag = 0;
    char *filename;
    unsigned int duty = 0x0fffffff;

    if(argc != 2)
    {
        printf("Error Usage\r\n");
        return -1;
    }

    filename = argv[1];
    fd = open(filename, O_RDWR);
    if(fd < 0)
    {
        printf("file %s open failed\r\n", argv[1]);
        return -1;
    }

    /* 设置频率 */
    retvalue = ioctl(fd, PWM_FREQ, FREQ_DEFAULT);
    if(retvalue < 0)
    {
        printf("pwm Failed\r\n");
        close(fd);
        return -1;
    }

    while(1)
    {
        if(duty <= 0xefffffff && 0 == flag)
        {
            duty += 2000000;
        }
        else if(duty >= 0x0fffffff)
        {
            duty -= 500000;
            flag = 1;
        }
        else
        {
            flag = 0;
        }

        /* 设置占空比 */
        retvalue = ioctl(fd, PWM_DUTY, duty);
        if(retvalue < 0)
        {
            printf("pwm Failed\r\n");
            close(fd);
            return -1;
        }
        usleep(5);
    }


    return 0;
}


























