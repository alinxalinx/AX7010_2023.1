
#include "detectCorner.h"

void ExtractPixel(XF_TNAME(XF_8UC3,XF_NPPC1)&src,ap_uint<8> value[3])
{
#pragma HLS INLINE off
	unsigned i,j=0;
	for(i=0;i<24;i+=8)
	{
#pragma HLS UNROLL
		value[j]=src.range(i+7,i);
		j++;
	}
}

void PackPixel(XF_TNAME(XF_8UC3,XF_NPPC1)&dst,ap_uint<8> value[3])
{
#pragma HLS INLINE off
	unsigned int i,j=0;
	for(i=0;i<24;i+=8)
	{
#pragma HLS UNROLL
		dst.range(i+7,i)=value[j];
		j++;
	}
}

template<int ROWS,int COLS>
void xfrgb2gray(xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1>&src,xf::cv::Mat<XF_8UC1,ROWS,COLS,XF_NPPC1>&dst1,xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1>&dst2)
{
	XF_TNAME(XF_8UC3,XF_NPPC1)pixel_src;
	XF_TNAME(XF_8UC1,XF_NPPC1)pixel_dst1;
	XF_TNAME(XF_8UC3,XF_NPPC1)pixel_dst2;
	ap_uint<8>rgb[3];
	ap_uint<8>gray;
	unsigned int i,j=0;
	for(i=0;i<ROWS;i++)
	{
		for(j=0;j<COLS;j++)
		{
			pixel_src=src.read(i*COLS+j);
			ExtractPixel(pixel_src,rgb);
			gray=CalculateGRAY(rgb[0],rgb[1],rgb[2]);
			pixel_dst1.range(7,0)=gray;
			pixel_dst2=pixel_src;
			dst1.write(i*COLS+j,pixel_dst1);
			dst2.write(i*COLS+j,pixel_dst2);
		}
	}
}

template<int ROWS,int COLS>
void xfgray2rgb(xf::cv::Mat<XF_8UC1,ROWS,COLS,XF_NPPC1>&src1,xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1>&src2,xf::cv::Mat<XF_8UC3,ROWS,COLS,XF_NPPC1>&dst)
{
	unsigned int i,j=0;
	XF_TNAME(XF_8UC1,XF_NPPC1)pixel_src1;
	XF_TNAME(XF_8UC3,XF_NPPC1)pixel_src2;
	XF_TNAME(XF_8UC3,XF_NPPC1)pixel_dst;
	for(i=0;i<ROWS;i++)
	{
		for(j=0;j<COLS;j++)
		{
			pixel_src1=src1.read(i*COLS+j);
			pixel_src2=src2.read(i*COLS+j);
			if(pixel_src1==255)
			{
			pixel_dst.range(7,0)=0x00;
			pixel_dst.range(15,8)=pixel_src1;
			pixel_dst.range(23,16)=0x00;
			}
			else
			{
				pixel_dst=pixel_src2;
			}
			dst.write(i*COLS+j,pixel_dst);
		}
	}
}

void detectCorner(hls::stream<ap_axiu<24,1,1,1>>&video_in, hls::stream<ap_axiu<24,1,1,1>>&video_out,int threshold)
{
#pragma HLS INTERFACE mode=s_axilite port=threshold register
#pragma HLS INTERFACE axis port=video_out register_mode=both register
#pragma HLS INTERFACE axis port=video_in register_mode=both register
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS DATAFLOW


	xf::cv::Mat<XF_8UC3,IMG_MAX_ROWS, IMG_MAX_COLS, XF_NPPC1> img_in;
#pragma HLS STREAM depth=1920 type=fifo variable=img_in
	xf::cv::Mat<XF_8UC3,IMG_MAX_ROWS, IMG_MAX_COLS, XF_NPPC1> img_out;
#pragma HLS STREAM depth=1920 type=fifo variable=img_out
	xf::cv::Mat<XF_8UC3,IMG_MAX_ROWS, IMG_MAX_COLS, XF_NPPC1> img_rgb_src;
#pragma HLS STREAM depth=1920 type=fifo variable=img_rgb_src
	xf::cv::Mat<XF_8UC3,IMG_MAX_ROWS, IMG_MAX_COLS, XF_NPPC1> img_rgb_dst;
#pragma HLS STREAM depth=1920 type=fifo variable=img_rgb_dst
	xf::cv::Mat<XF_8UC1,IMG_MAX_ROWS, IMG_MAX_COLS, XF_NPPC1> img_gray_src;
#pragma HLS STREAM depth=1920 type=fifo variable=img_gray_src
	xf::cv::Mat<XF_8UC1,IMG_MAX_ROWS, IMG_MAX_COLS, XF_NPPC1> img_gray_dst;
#pragma HLS STREAM depth=1920 type=fifo variable=img_gray_dst


	unsigned char kernel[NEW_K_ROWS][NEW_K_COLS];
	#pragma HLS array_partition variable=kernel dim=0
	// clang-format on
	for (unsigned char i = 0; i < NEW_K_ROWS; i++) {
		for (unsigned char j = 0; j < NEW_K_COLS; j++) {
			kernel[i][j] = 1; // _kernel[i*NEW_K_COLS+j];
		}
	}

	xf::cv::AXIvideo2xfMat(video_in,img_in);
	xfrgb2gray<IMG_MAX_ROWS,IMG_MAX_COLS>(img_in,img_gray_src,img_rgb_src);
	xf::cv::fast<0,XF_8UC1,IMG_MAX_ROWS,IMG_MAX_COLS,XF_NPPC1>(img_gray_src,img_rgb_src,img_gray_dst,img_rgb_dst,threshold);
//	xf::cv::xfdilate<IMG_MAX_ROWS,IMG_MAX_COLS, XF_CHANNELS(XF_8UC1, XF_NPPC1), XF_8UC1, XF_NPPC1, 0, (IMG_MAX_COLS >> XF_BITSHIFT(XF_NPPC1)) + (NEW_K_ROWS >> 1),
//	                 NEW_K_ROWS, NEW_K_COLS>(mask,dmask,matGray.rows,matGray.cols>>XF_BITSHIFT(XF_NPPC1),kernel);
//	overlyOnMat<IMG_MAX_ROWS,IMG_MAX_COLS>(img_rgb_dst,img_gray_dst,img_out,overly_alpha,overly_x,overly_y,overly_h,overly_w);
	xfgray2rgb<IMG_MAX_ROWS,IMG_MAX_COLS>(img_gray_dst,img_rgb_dst,img_out);
	xf::cv::xfMat2AXIvideo(img_out,video_out);
}
