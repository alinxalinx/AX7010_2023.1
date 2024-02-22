#include <stdio.h>
#include <unistd.h>
#include "dynclk.h"
#include "xparameters.h"
#include "xclk_control.h"


void set_xclk_wiz(double in, double out)
{
	ClkConfig clkReg;
	ClkMode clkMode;

	ClkFindParams(out, &clkMode);
	if (!ClkFindReg(&clkReg, &clkMode))
	{
		printf("set_xclk_wiz = %lf fail\n", out);
		return;
	}
	ClkWriteReg(&clkReg, XPAR_AXI_DYNCLK_0_BASEADDR);
	ClkStop(XPAR_AXI_DYNCLK_0_BASEADDR);
	ClkStart(XPAR_AXI_DYNCLK_0_BASEADDR);
}

