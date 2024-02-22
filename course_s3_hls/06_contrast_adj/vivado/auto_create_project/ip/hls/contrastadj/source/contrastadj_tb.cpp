#include"contrastadj.h"
#include"xf_headers.hpp"

int main(void)
{
	int adj=10;
	cv::Mat in_img,out_img;
	xf::Mat<XF_8UC3,IMG_MAX_HEIGHT,IMG_MAX_WIDTH,XF_NPPC1> imgInput,imgOutput;
	in_img=cv::imread("E:/xfopencv-master/timg.jpg",1);
	imgInput.copyTo(in_img.data);
	contrastadj(imgInput,imgOutput,3);
	xf::imwrite("out_hls.jpg",imgOutput);
	return 0;
}
