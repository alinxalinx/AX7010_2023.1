#ifndef PS_IIC_CONTROL_H
#define PS_IIC_CONTROL_H

#include <stdio.h>
#include <unistd.h>
#include "xil_types.h"
#include "xiicps.h"

int ps_iic_init(unsigned int devID, XIicPs *pIicInstance, int rate);
unsigned char ps_iic_read(XIicPs *pIicInstance, unsigned iic_addr, unsigned int addr, int num);
int ps_iic_write(XIicPs *pIicInstance, unsigned iic_addr, unsigned int addr, unsigned char data, int num);

#endif
