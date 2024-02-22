#include "ps_iic_control.h"

int ps_iic_init(unsigned int devID, XIicPs *pIicInstance, int rate)
{
    XIicPs_Config *Config;
    int Status;

    Config = XIicPs_LookupConfig(devID);
    if (NULL == Config)
    {
        xil_printf("XIicPs_LookupConfig failure\r\n");
        return -1;
    }

    Status = XIicPs_CfgInitialize(pIicInstance, Config, Config->BaseAddress);
    if (Status != XST_SUCCESS)
    {
        xil_printf("XIicPs_CfgInitialize failure\r\n");
        return -2;
    }
    XIicPs_SetSClk(pIicInstance, rate);
    while (XIicPs_BusIsBusy(pIicInstance));	// Wait
    return 0;
}

unsigned char ps_iic_read(XIicPs *pIicInstance, unsigned iic_addr, unsigned int addr, int num)
{
	unsigned char wr_data, rd_data;

	wr_data = addr;
	XIicPs_MasterSendPolled(pIicInstance, &wr_data, 1, iic_addr>>1);
	XIicPs_MasterRecvPolled(pIicInstance, &rd_data, 1, iic_addr>>1);
	while (XIicPs_BusIsBusy(pIicInstance));
	return rd_data;
}

int ps_iic_write(XIicPs *pIicInstance, unsigned iic_addr, unsigned int addr, unsigned char data, int num)
{
	u8 sendBuffer[3];
	int n = 0;

	for(int i=0;i<num;i++)
	{
		sendBuffer[n++] = addr>>(8*(num-i-1));
	}
	sendBuffer[n++] = data;
	XIicPs_MasterSendPolled(pIicInstance, sendBuffer, n, iic_addr>>1);
	while (XIicPs_BusIsBusy(pIicInstance));
    return 0;
}
