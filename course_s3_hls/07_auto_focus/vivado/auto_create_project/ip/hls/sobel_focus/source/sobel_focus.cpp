#include "sobel_focus.h"

void ExtractPixel(XF_TNAME(XF_8UC3,XF_NPPC1)&src,ap_uint<8>src_value[3])
{
#pragma HLS INLINE off
	unsigned int i,j=0;
	for(i=0;i<24;i+=8)
	{
#pragma HLS UNROLL
		src_value[j]=src.range(i+7,i);
		j++;
	}
}

template<int ROWS, int COLS>
void sum_of_stream(xf::cv::Mat<XF_8UC1,ROWS,COLS,XF_NPPC1>	&_src, unsigned int &average)
{
	XF_TNAME(XF_8UC1,XF_NPPC1)pix;
	unsigned int sum=0;

	for(int v=0; v<ROWS; v++)
	{
		for(int h=0; h<COLS; h++)
		{
#pragma HLS pipeline
			pix = _src.read(v*COLS+h);
			sum += pix.range(7,0);
		}
	}
	average = sum;
}

template<int ROWS,int COLS>
void xfrgb2gray(xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1> &src,xf::cv::Mat<XF_8UC1,ROWS,COLS,XF_NPPC1> &dst)
{
	XF_TNAME(XF_8UC3,XF_NPPC1)rgb_packed;
	XF_TNAME(XF_8UC1,XF_NPPC1)gray_packed;
	ap_uint<8>rgb[3];
	ap_uint<8>gray;
	unsigned int i,j=0;
	for(i=0;i<ROWS;i++)
	{
		for(j=0;j<COLS;j++)
		{
#pragma HLS PIPELINE
			rgb_packed=src.read(i*COLS+j);
			ExtractPixel(rgb_packed,rgb);
			gray=CalculateGRAY(rgb[0],rgb[1],rgb[2]);
			gray_packed.range(7,0)=gray;
			dst.write(i*COLS+j,gray_packed);
		}
	}
}

template<int ROWS,int COLS>
void AddWeightedKernel(xf::cv::Mat<XF_8UC1,ROWS,COLS,XF_NPPC1>&src1,
					   float alpha,
					   xf::cv::Mat<XF_8UC1,ROWS,COLS,XF_NPPC1>&src2,
					   float beta,
					   float gamma,
					   xf::cv::Mat<XF_8UC1,ROWS,COLS,XF_NPPC1>&dst
					)
{
	ap_fixed<16,8,AP_RND>value_src1=alpha;
	ap_fixed<16,8,AP_RND>value_src2=beta;
	ap_fixed<16,8,AP_RND>value_src3=gamma;
	XF_TNAME(XF_8UC1,XF_NPPC1)pixel1;
	XF_TNAME(XF_8UC1,XF_NPPC1)pixel2;
	XF_TNAME(XF_8UC1,XF_NPPC1)pixel3;
	ap_int<24>firstcmp;
	ap_int<24>secondcmp;
	ap_int<16>thirdcmp;
	ap_uint<8>value;
	ap_uint<8>value_cmp1;
	ap_uint<8>value_cmp2;
	unsigned int i,j=0;
	for(i=0;i<ROWS;i++)
	{
		for(j=0;j<COLS;j++)
		{
#pragma HLS pipeline
			pixel1=src1.read(i*COLS+j);
			pixel2=src2.read(i*COLS+j);
			value_cmp1=pixel1.range(7,0);
			value_cmp2=pixel2.range(7,0);
			firstcmp=(ap_int<24>)value_cmp1*value_src1;
			secondcmp=(ap_int<24>)value_cmp2*value_src2;
			thirdcmp=(ap_int<16>)firstcmp+secondcmp+value_src3;
			if(thirdcmp>255)
			{
				thirdcmp=255;
			}
			else if(thirdcmp<0)
			{
				thirdcmp=0;
			}
			value=thirdcmp;
			pixel3.range(7,0)=value;
			dst.write(i*COLS+j,pixel3);
		}
	}
}

template<int ROWS,int COLS>
void duplicate(xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1>&src,xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1>&dst1,xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1>&dst2)
{
	unsigned int i,j=0;
	XF_TNAME(XF_8UC3,XF_NPPC1)pixel_src;
	for(i=0;i<ROWS;i++)
	{
		for(j=0;j<COLS;j++)
		{
#pragma HLS PIPELINE
			pixel_src=src.read(i*COLS+j);
			dst1.write(i*COLS+j,pixel_src);
			dst2.write(i*COLS+j,pixel_src);
		}
	}
}


void sobel_focus(ustream_t &src, ustream_t &dst, unsigned int &average)
{
#pragma HLS INTERFACE axis port=src
#pragma HLS INTERFACE axis port=dst
#pragma HLS INTERFACE s_axilite port=average
#pragma HLS INTERFACE ap_ctrl_none port=return

	xf::cv::Mat<XF_8UC3,IMG_MAX_ROWS,IMG_MAX_COLS,XF_NPPC1> srcImg, split0, split1;
#pragma HLS STREAM depth=1920 type=fifo variable=split1
#pragma HLS STREAM depth=1920 type=fifo variable=split0
#pragma HLS STREAM depth=1920 type=fifo variable=srcImg
	xf::cv::Mat<XF_8UC1,IMG_MAX_ROWS,IMG_MAX_COLS,XF_NPPC1>grayImg,sobelImg_x,sobelImg_y,sobelImg;
#pragma HLS STREAM depth=1920 type=fifo variable=sobelImg
#pragma HLS STREAM depth=1920 type=fifo variable=sobelImg_y
#pragma HLS STREAM depth=1920 type=fifo variable=sobelImg_x
#pragma HLS STREAM depth=1920 type=fifo variable=grayImg
#pragma HLS DATAFLOW
	xf::cv::AXIvideo2xfMat(src, srcImg);
	duplicate<IMG_MAX_ROWS,IMG_MAX_COLS>(srcImg, split0, split1);
	xfrgb2gray<IMG_MAX_ROWS,IMG_MAX_COLS>(split0, grayImg);
    xf::cv::xFSobelFilter3x3<XF_8UC1, XF_8UC1,IMG_MAX_ROWS, IMG_MAX_COLS, XF_CHANNELS(XF_8UC1,XF_NPPC1), XF_DEPTH(XF_8UC1,XF_NPPC1), XF_DEPTH(XF_8UC1,XF_NPPC1),
                    XF_NPPC1, _XFCVDEPTH_DEFAULT,_XFCVDEPTH_DEFAULT,_XFCVDEPTH_DEFAULT,XF_WORDWIDTH(XF_8UC1,XF_NPPC1), XF_WORDWIDTH(XF_8UC1,XF_NPPC1), (IMG_MAX_COLS >> XF_BITSHIFT(XF_NPPC1)),false>(
        grayImg,sobelImg_x,sobelImg_y,grayImg.rows,grayImg.cols>>XF_BITSHIFT(XF_NPPC1));
	AddWeightedKernel<IMG_MAX_ROWS,IMG_MAX_COLS>(sobelImg_x,0.5f,sobelImg_y,0.5f,0.0f,sobelImg);
	sum_of_stream(sobelImg, average);
	xf::cv::xfMat2AXIvideo(split1, dst);
}
