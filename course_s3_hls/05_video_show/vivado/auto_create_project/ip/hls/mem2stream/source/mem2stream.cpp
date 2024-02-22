#include "mem2stream.h"

unsigned int cache_len=0;

void readmem(unsigned int *pMemPort, unsigned int base, int row, int rows, unsigned int *to, int line_len)
{
	if(cache_len < (2*line_len))
	{
		if((row+1) == rows)
		{
			memcpy(to, pMemPort+base, (2*line_len-cache_len)*4);
		}
		else
		{
			memcpy(to, pMemPort+base+(row+1)*line_len, (2*line_len-cache_len)*4);
		}
		cache_len = line_len;
	}
	else
	{
		cache_len -= line_len;
	}
}

template<int ROWS, int COLS>
void mem2mat(xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1> &img, unsigned int *pMemPort,int baseAddr[3],int w, int &r)
{
	XF_TNAME(XF_8UC3,XF_NPPC1) pixel;
	unsigned int cacheBuff[COLS];
	int local_rows = img.rows;
	int local_cols = img.cols;
	int line_len   = img.cols*3/4;
	static int index=2;
	int n = (index<2)?(index+1):0;
	index = (n == w)?index:n;
	r = index;
#pragma HLS STREAM variable=cacheBuff depth=COLS*2
	for(int row=0; row<local_rows; row++)
	{
#pragma HLS loop_tripcount min=12 max=1080
#pragma HLS dataflow
		readmem(pMemPort, baseAddr[index]>>2, row, local_rows, cacheBuff, line_len);
		for(int col=0; col<local_cols; col+=4)
		{
#pragma HLS loop_tripcount min=3 max=480
			pixel.range(7,0) = cacheBuff[0]>>0;
			pixel.range(15,8) = cacheBuff[0]>>8;
			pixel.range(23,16) = cacheBuff[0]>>16;
			img.write(row*local_cols+col,pixel);
			pixel.range(7,0) = cacheBuff[0]>>24;
			pixel.range(15,8) = cacheBuff[1]>>0;
			pixel.range(23,16) = cacheBuff[1]>>8;
			img.write(row*local_cols+col+1,pixel);
			pixel.range(7,0) = cacheBuff[1]>>16;
			pixel.range(15,8) = cacheBuff[1]>>24;
			pixel.range(23,16) = cacheBuff[2]>>0;
			img.write(row*local_cols+col+2,pixel);
			pixel.range(7,0) = cacheBuff[2]>>8;
			pixel.range(15,8) = cacheBuff[2]>>16;
			pixel.range(23,16) = cacheBuff[2]>>24;
			img.write(row*local_cols+col+3,pixel);
		}
	}
}

void mem2stream(vstream_t &vstream, unsigned int *pMemPort, int rows, int cols,int baseAddr[3],int indexw, int &indexr)
{
#pragma HLS INTERFACE mode=s_axilite port=baseAddr
#pragma HLS INTERFACE axis port=vstream
#pragma HLS INTERFACE m_axi port=pMemPort
#pragma HLS INTERFACE s_axilite port=rows
#pragma HLS INTERFACE s_axilite port=cols
#pragma HLS INTERFACE s_axilite port=return
#pragma HLS INTERFACE ap_none port=indexw
#pragma HLS INTERFACE ap_none port=indexr
	xf::cv::Mat<XF_8UC3,IMG_MAX_ROWS,IMG_MAX_COLS,XF_NPPC1> img;
#pragma HLS STREAM depth=1080 type=fifo variable=img

#pragma HLS dataflow
	mem2mat<IMG_MAX_ROWS,IMG_MAX_COLS>(img, pMemPort,baseAddr,indexw,indexr);
	xf::cv::xfMat2AXIvideo(img, vstream);
}
