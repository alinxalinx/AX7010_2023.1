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
#include "linux/ioctl.h"

int main(int argc, char *argv[])
{
    int fd, ret;
    char *filename;
    unsigned int interval_new, interval_old = 0;

    /* 验证输入参数个数 */
    if(argc != 2)
    {
        printf("Error Usage!\r\n");
        return -1;
    }

    /* 打开输入的设备文件, 获取文件句柄 */
    filename = argv[1];
    fd = open(filename, O_RDWR);
    if(fd < 0)
    {
        /* 打开文件失败 */
        printf("can not open file %s\r\n", filename);
        return -1;
    }

    while(1)
    {
        /* 等待输入led闪烁的时间间隔 */
        printf("Input interval:");
        scanf("%d", &interval_new);

        /* 时间间隔更新了 */
        if(interval_new != interval_old)
        {
            interval_old = interval_new;
            /* 写入新的时间间隔 */
            ret = write(fd, &interval_new, sizeof(interval_new));
            if(ret < 0)
            {
                printf("write failed\r\n");
            }
            else
            {
                printf("interval refreshed!\r\n");
            }
        }
        else
        {
            printf("same interval!");
        }
    }
    close(fd);
}


















