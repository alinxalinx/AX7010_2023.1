#include "contrastadj.h"

void ExtractPixel(XF_TNAME(XF_8UC3,XF_NPPC1) &src_axi,ap_uint<8> dst[3])
{
	unsigned int i,j=0;
	for(i=0;i<24;i+=8)
	{
#pragma HLS PIPELINE
		dst[j]=src_axi.range(i+7,i);
		j++;
	}
}

void PackPixel(XF_TNAME(XF_8UC3,XF_NPPC1)&dst_axi,ap_uint<8>src[3])
{
	unsigned int i,j=0;
	for(i=0;i<24;i+=8)
	{
#pragma HLS PIPELINE
		dst_axi.range(i+7,i)=src[j];
		j++;
	}
}

template<int ROWS, int COLS, int N>
void dualAryEqualize(
		xf::cv::Mat<XF_8UC3,ROWS, COLS,XF_NPPC1>	&_src,
		xf::cv::Mat<XF_8UC3,ROWS, COLS,XF_NPPC1>	&_dst,
		int filter)
{
	static ap_uint<8> map[N];
	ap_uint<32>hist_out1[N];
#pragma HLS ARRAY_PARTITION variable=hist_out1 dim=1 complete
	ap_uint<32>hist_out2[N];
#pragma HLS ARRAY_PARTITION variable=hist_out2 dim=1 complete
	unsigned int i,j=0;
	XF_TNAME(XF_8UC3,XF_NPPC1)src1;
	XF_TNAME(XF_8UC3,XF_NPPC1)src2;
	XF_TNAME(XF_8UC3,XF_NPPC1)dst1;
	XF_TNAME(XF_8UC3,XF_NPPC1)dst2;
	ap_uint<8> value1[3];
	ap_uint<8> value2[3];
	int pos1,pos2;
	for(i=0;i<N;i++)
	{
		hist_out1[i]=0;
		hist_out2[i]=0;
	}


	for(i=0;i<ROWS;i++)
	{
		for(j=0;j<COLS;j+=2)
		{
#pragma HLS DEPENDENCE variable=src1 intra false
#pragma HLS DEPENDENCE variable=src2 intra false

#pragma HLS PIPELINE II=2
			src1=_src.read(i*COLS+j);
			src2=_src.read(i*COLS+j+1);
			ExtractPixel(src1,value1);
			ExtractPixel(src2,value2);
			pos1=(int)value1[0];
			pos2=(int)value2[0];
			hist_out1[pos1]+=1;
			hist_out2[pos2]+=1;
			value1[0]=map[pos1];
			value2[0]=map[pos2];
			PackPixel(dst1,value1);
			PackPixel(dst2,value2);
			_dst.write(i*COLS+j,dst1);
			_dst.write(i*COLS+j+1,dst2);
		}
	}
	int count_total = 0, tmp_hist;
	float scale;
	for(int i=0;i<N;i++)
	{
#pragma HLS PIPELINE
		tmp_hist=hist_out1[i]+hist_out2[i];
		count_total += tmp_hist;
		scale = count_total*255/ROWS/COLS;
		scale=(scale-i)*0.01*filter+i;
		if(scale < 16)scale = 16;
		if(scale > 255)scale = 235;
		map[i] =  ap_uint<8>  (scale);
	}
}

template <int ROWS, int COLS>
void xfrgb2ycrcb(xf::cv::Mat<XF_8UC3, ROWS, COLS,XF_NPPC1>& src,
                 xf::cv::Mat<XF_8UC3, ROWS, COLS,XF_NPPC1>& dst)
{
	XF_TNAME(XF_8UC3,XF_NPPC1)rgb_packed;
	XF_TNAME(XF_8UC3,XF_NPPC1)ycrcb_packed;
	ap_uint<8>rgb[3];
	ap_uint<8>ycrcb[3];
	unsigned int i,j=0;
	for(i=0;i<ROWS;i++)
	{
		for(j=0;j<COLS;j++)
		{
#pragma HLS PIPELINE
			rgb_packed=src.read(i*COLS+j);
			ExtractPixel(rgb_packed,rgb);
			ycrcb[0]=CalculateGRAY(rgb[0],rgb[1],rgb[2]);
			ycrcb[1]=Calculate_CR(rgb[0],ycrcb[0]);
			ycrcb[2]=Calculate_CB(rgb[2],ycrcb[0]);
			PackPixel(ycrcb_packed,ycrcb);
			dst.write(i*COLS+j,ycrcb_packed);
		}
	}
}

template<int ROWS,int COLS>
void xfycrcb2rgb(xf::cv::Mat<XF_8UC3, ROWS, COLS,XF_NPPC1>& src,
        		 xf::cv::Mat<XF_8UC3, ROWS, COLS,XF_NPPC1>& dst)
{
	XF_TNAME(XF_8UC3,XF_NPPC1)rgb_packed;
	XF_TNAME(XF_8UC3,XF_NPPC1)ycrcb_packed;
	ap_uint<8>rgb[3];
	ap_uint<8>ycrcb[3];
	unsigned int i,j=0;
	for(i=0;i<ROWS;i++)
	{
		for(j=0;j<COLS;j++)
		{
#pragma HLS PIPELINE
			ycrcb_packed=src.read(i*COLS+j);
			ExtractPixel(ycrcb_packed,ycrcb);
			rgb[0]=Calculate_Ycrcb2R(ycrcb[0],ycrcb[1]);
			rgb[1]=Calculate_Ycrcb2G(ycrcb[0],ycrcb[1],ycrcb[2]);
			rgb[2]=Calculate_Ycrcb2B(ycrcb[0],ycrcb[2]);
			PackPixel(rgb_packed,rgb);
			dst.write(i*COLS+j,rgb_packed);
		}
	}
}

void contrastadj(hls::stream<ap_axiu<24,1,1,1>> &src_axi,hls::stream<ap_axiu<24,1,1,1>> &dst_axi,int adj)
{

#pragma HLS INTERFACE mode=s_axilite port=return
#pragma HLS INTERFACE mode=s_axilite port=adj register

#pragma HLS INTERFACE axis port=src_axi
#pragma HLS INTERFACE axis port=dst_axi

	xf::cv::Mat<XF_8UC3,IMG_MAX_HEIGHT, IMG_MAX_WIDTH, XF_NPPC1> img1;
#pragma HLS STREAM depth=1920 type=fifo variable=img1
	xf::cv::Mat<XF_8UC3,IMG_MAX_HEIGHT, IMG_MAX_WIDTH, XF_NPPC1> img2;
#pragma HLS STREAM depth=1920 type=fifo variable=img2
	xf::cv::Mat<XF_8UC3,IMG_MAX_HEIGHT, IMG_MAX_WIDTH, XF_NPPC1> img3;
#pragma HLS STREAM depth=1920 type=fifo variable=img3
	xf::cv::Mat<XF_8UC3,IMG_MAX_HEIGHT, IMG_MAX_WIDTH, XF_NPPC1> img4;
#pragma HLS STREAM depth=1920 type=fifo variable=img4

#pragma HLS dataflow

// AXIvideoTest<IMG_MAX_HEIGHT,IMG_MAX_WIDTH>(src_axi,dst_axi);
 xf::cv::AXIvideo2xfMat<24,XF_8UC3,IMG_MAX_HEIGHT,IMG_MAX_WIDTH,XF_NPPC1>(src_axi, img1);
	xfrgb2ycrcb<IMG_MAX_HEIGHT,IMG_MAX_WIDTH>(img1, img2);
	dualAryEqualize<IMG_MAX_HEIGHT, IMG_MAX_WIDTH, 256>(img2, img3,adj);
   xfycrcb2rgb<IMG_MAX_HEIGHT,IMG_MAX_WIDTH>(img3, img4);
 xf::cv::xfMat2AXIvideo<24,XF_8UC3,IMG_MAX_HEIGHT,IMG_MAX_WIDTH,XF_NPPC1>(img4,dst_axi);
}
