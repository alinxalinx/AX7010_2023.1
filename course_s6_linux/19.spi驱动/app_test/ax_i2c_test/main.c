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
#include "assert.h"

int main(int argc, char *argv[])
{
    int fd, ret;
    char *filename;
    char buffer[3] = {0};

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

    /* 随便写入一些数据 */
    buffer[0] = 0x5A;
    buffer[1] = 0x55;
    buffer[2] = 0xAA;
    ret = write(fd, buffer, sizeof(buffer));
    if(ret < 0)
    {
        printf("write failed\r\n");
    }
    /* 在控制台打印写入的数据 */
    printf("write data %X, %X, %X\r\n", buffer[0], buffer[1], buffer[2]);

    /* 初始化buffer, 再用来读取数据 */
    memset(buffer, 0, sizeof(buffer));

    /* 读出数据 */
    ret = read(fd, buffer, sizeof(buffer));
    if(ret < 0)
    {
        printf("read failed\r\n");
    }
    /* 在控制台打印读出的数据 */
    printf("read data %X, %X, %X\r\n", buffer[0], buffer[1], buffer[2]);

    close(fd);

    return 0;
}
