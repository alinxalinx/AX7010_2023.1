#include <string.h>

double sum;

void float_sum(float *src, int num)
{
	int len;
	float cachebuff[64];
#pragma HLS STREAM variable=cachebuff depth=64

	for(int i=0;i<num;i+=64)
	{
#pragma HLS loop_tripcount min=0 max=1024
		len = ((num-i) >= 64) ? 64 : num-i;
		memcpy(cachebuff, src+i, len*4);
		for(int j=0;j<len;j++)
		{
#pragma HLS pipeline
			sum += cachebuff[j];
		}
	}
}

float average_float(float *src, int num)
{
#pragma HLS INTERFACE m_axi depth=1024 offset=slave port=src
#pragma HLS INTERFACE s_axilite port=num
#pragma HLS INTERFACE s_axilite port=return

	sum = 0;
	float_sum(src, num);
	return (float)(sum/num);
}

