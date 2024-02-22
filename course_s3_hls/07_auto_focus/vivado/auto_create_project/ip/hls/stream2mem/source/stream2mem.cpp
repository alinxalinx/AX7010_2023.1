#include "stream2mem.h"


void writemem(unsigned int *pMemPort, unsigned int to, unsigned int *from, int len)
{
	if(len > 0)
	{
		memcpy(pMemPort+to, from, len);
	}
}

template<int ROWS, int COLS>
void mat2mem(xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1> &img, unsigned int *pMemPort,int baseAddr[3],int &w, int r)
{
	XF_TNAME(XF_8UC3,XF_NPPC1) pixelA, pixelB, pixelC, pixelD;
	unsigned int cacheBuff[COLS*3/4];
	int local_rows = img.rows;
	int local_cols = img.cols;
	int line_len   = img.cols*3/4;
	static int index=0;
	int n = (index<2)?(index+1):0;
	index = (n == r)?index:n;
	w = index;
#pragma HLS STREAM variable=cacheBuff depth=COLS/4
	for(int row=0; row<local_rows; row++)
	{
#pragma HLS loop_tripcount min=12 max=1080
#pragma HLS dataflow
		for(int col=0; col<local_cols; col+=4)
		{
#pragma HLS loop_tripcount min=3 max=480
			pixelA = img.read(row*local_cols+col);
			pixelB = img.read(row*local_cols+col+1);
			cacheBuff[0] = (pixelA.range(7,0)<<0)|(pixelA.range(15,8)<<8)|(pixelA.range(23,16)<<16)|(pixelB.range(7,0)<<24);
			pixelC = img.read(row*local_cols+col+2);
			cacheBuff[1] = (pixelB.range(15,8)<<0)|(pixelB.range(23,16)<<8)|(pixelC.range(7,0)<<16)|(pixelC.range(15,8)<<24);
			pixelD = img.read(row*local_cols+col+3);
			cacheBuff[2] = (pixelC.range(23,16)<<0)|(pixelD.range(7,0)<<8)|(pixelD.range(15,8)<<16)|(pixelD.range(23,16)<<24);
		}
		writemem(pMemPort, (baseAddr[index]>>2)+(row*line_len), cacheBuff, line_len*4);
	}
}

void stream2mem(vstream_t &vstream, unsigned int *pMemPort, int rows, int cols, int baseAddr[3],int &indexw, int indexr)
{
#pragma HLS INTERFACE mode=s_axilite port=baseAddr
#pragma HLS INTERFACE axis port=vstream
#pragma HLS INTERFACE m_axi port=pMemPort
#pragma HLS INTERFACE s_axilite port=rows
#pragma HLS INTERFACE s_axilite port=cols
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE ap_none port=indexw
#pragma HLS INTERFACE ap_none port=indexr

	xf::cv::Mat<XF_8UC3,IMG_MAX_ROWS,IMG_MAX_COLS,XF_NPPC1> img;
#pragma HLS STREAM depth=1920 type=pipo variable=img

#pragma HLS dataflow
	xf::cv::AXIvideo2xfMat(vstream, img);
	mat2mem(img, pMemPort,baseAddr,indexw, indexr);
}
