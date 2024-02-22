
#include "colorbar.h"

template<int ROWS, int COLS>
void createColorBar(xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1> &imgColorbar)
{
	XF_TNAME(XF_8UC3,XF_NPPC1) pixel;
	int move, wBar;
	int rows = imgColorbar.rows;
	int cols = imgColorbar.cols;
	static int moving = 0;

	for(int row=0;row<rows;row++)
	{
#pragma HLS loop_flatten off
		if( (row < rows/3) || (row >= rows/3*2) )
		{
			move = 0;
		}
		else
		{
			move = moving;
		}
		wBar = cols>>3;
		for(int col=0;col<cols;col++)
		{
#pragma HLS pipeline
			int index = ((col+move)/wBar)&0x7;
			switch(index)
			{
			case 0:
				pixel.range(7,0) = 0xff;
				pixel.range(15,8) = 0xff;
				pixel.range(23,16) = 0xff; //white
				break;
			case 1:
				pixel.range(7,0) = 0x00;
				pixel.range(15,8) = 0xff;
				pixel.range(23,16) = 0xff; //yellow
				break;
			case 2:
				pixel.range(7,0) = 0xff;
				pixel.range(15,8) = 0xff;
				pixel.range(23,16) = 0x00; //cyan
				break;
			case 3:
				pixel.range(7,0) = 0x00;
				pixel.range(15,8) = 0xff;
				pixel.range(23,16) = 0x00; //green
				break;
			case 4:
				pixel.range(7,0) = 0xff;
				pixel.range(15,8) = 0x00;
				pixel.range(23,16) = 0xff; //magenta
				break;
			case 5:
				pixel.range(7,0) = 0x0;
				pixel.range(15,8) = 0x0;
				pixel.range(23,16) = 0xff; //red
				break;
			case 6:
				pixel.range(7,0) = 0xff;
				pixel.range(15,8) = 0x00;
				pixel.range(23,16) = 0x00; //blue
				break;
			default:
				pixel.range(7,0) = 0x00;
				pixel.range(15,8) = 0x00;
				pixel.range(23,16) = 0x00; //black
				break;
			}

			imgColorbar.write(row*cols+col,pixel);
		}
	}
	if(!moving)
	{
		moving = cols;
	}
	else
	{
		moving--;
	}
}

void colorbar(pixel_stream &dst, int rows, int cols)
{
#pragma HLS INTERFACE axis port=dst
#pragma HLS INTERFACE s_axilite port=rows
#pragma HLS INTERFACE s_axilite port=cols
#pragma HLS INTERFACE s_axilite port=return
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS dataflow
	xf::cv::Mat<XF_8UC3,IMG_MAX_ROWS,IMG_MAX_COLS,XF_NPPC1>imgColorbar;
	createColorBar<IMG_MAX_ROWS,IMG_MAX_COLS>(imgColorbar);
	xf::cv::xfMat2AXIvideo(imgColorbar, dst);
}

