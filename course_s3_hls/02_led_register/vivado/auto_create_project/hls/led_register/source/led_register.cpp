#include <ap_int.h>

void led_register(ap_int<1> &led, int total_cnt, int high_cnt)
{
#pragma HLS INTERFACE ap_none port=led
#pragma HLS INTERFACE s_axilite port=total_cnt
#pragma HLS INTERFACE s_axilite port=high_cnt
#pragma HLS INTERFACE ap_ctrl_none port=return
	led = 0;
	for(int i=0;i<total_cnt;i++)
	{
#pragma HLS LOOP_TRIPCOUNT avg=100000000 max=100000000 min=100000000
		if(i == high_cnt)
		led = ~led;
	}
}
