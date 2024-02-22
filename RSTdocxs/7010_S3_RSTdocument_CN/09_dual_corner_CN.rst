角点检测
==============================================

角点检测(Corner Detection)是计算机视觉系统中用来获得图像特征的一种方法,广泛应用于
运动检测、图像匹配、视频跟踪、三维建模和目标识别等领域中。也称为特征点检测。
FAST(Features fromaccelerated segment test)是一种角点检测方法,最初是由Edward Rosten和Tom Drummond提出,该算法最突出的优点是它的计算效率。正如它的缩写名字,它很快而且事实上它比其他著名的特征点提取方法(如SIFT,SUSAN,Harris)都要快。如果应用于机器学习方法的话,该算法能够取得更佳的效果。正因为它的快速特点,FAST角点检测方法非常适用于实时视频处理的领域。
FAST算法步骤

1) 从图片中选取一个像素P,下面我们将判断它是否是一个特征点。我们首先把它的亮度值设为Ip。
2) 设定一个合适的阈值t。
3) 考虑以该像素点为中心的一个半径等于3像素的离散化的Bresenham圆,这个圆的边界上有16个像素(如图1所示)。
    
.. image:: images/images8/image66.png
         
4) 现在,如果在这个大小为16个像素的圆上有n个连续的像素点,它们的像素值要么都比Ip+t大,要么都比Ip−t小,那么它就是一个角点。(如图1中的白色虚线所示)。n的值可以设置为12或者9,实验证明选择9可能会有更好的效果。
 
上面的算法中,对于图像中的每一个点,我们都要去遍历其邻域圆上的16个点的像素,效率较低。我们下面提出了一种高效的测试(high-speed test)来快速排除一大部分非角点的像素。该方法仅仅检查在位置1,9,5和13四个位置的像素,首先检测位置1和位置9,如果它们都比阈值暗或比阈值亮,再检测位置5和位置13。如果PP是一个角点,那么上述四个像素点中至少有3个应该必须都大于Ip+t或者小于Ip−t,因为若是一个角点,超过四分之三圆的部分应该满足判断条件。如果不满足,那么p不可能是一个角点。对于所有点做上面这一部分初步的检测后,符合条件的将成为候选的角点,我们再对候选的角点,做完整的测试,即检测圆上的所有点。
上面的算法效率实际上是很高的,但是有一些缺点：

1) 当我们设置n<12时就不能使用快速算法来过滤非角点的点；
2) 检测出来的角点不是最优的,这是因为它的效率取决于问题的排序与角点的分布;
3) 对于角点分析的结果被丢弃了;
4) 多个特征点容易挤在一起。 

可以通过机器学习和非极大值抑制的方法来增强鲁棒性。由于opencv中相关的函数没有使用机器学习,因此我们这里只介绍非极大值抑制的方法。由于分割测试并没有计算角点响应函数,因此常规的非极大值抑制方法并不适用于FAST算法。下面是FAST的非极大值抑制方法：

1) 计算得分函数,它的值V是特征点与其圆周上16个像素点的绝对差值中所有连续10个像素中的最小值的最大值,而且该值还要大于阈值t；  
2) 在3×3的特征点邻域内(而不是图像邻域),比较V；
3) 剔除掉非极大值的特征点。

在opencv中,实现FAST算法的核心函数有两个,它们的原型为：
void FAST(InputArray image, vector<KeyPoint>& keypoints, int threshold, bool nonmaxSuppression=true )
void FASTX(InputArray image, vector<KeyPoint>& keypoints, int threshold, bool nonmaxSuppression, int type)
image为输入图像,要求是灰度图像,keypoints为检测到的特征点向量,threshold为阈值t,nonmaxSuppression为是否进行非极大值抑制,true表示进行非极大值抑制,type为选取圆周像素点的个数,是8(FastFeatureDetector::TYPE_5_8)、12(FastFeatureDetector::TYPE_7_12)还是16(FastFeatureDetector::TYPE_9_16)。该参数是FAST函数和FASTX函数的区别,事实上,FAST函数是调用FASTX函数,而传入的type值为FastFeatureDetector::TYPE_9_16。
本节实验,我们创建一个detectCorner的HLS模块,做了角点检测之后将图像叠加在原图上

模块主要代码
====================================================

.. code:: c

    
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

工程路径 
=====================================================

.. csv-table:: 
  :header: "名称", "路径"
  :widths: 20, 20

  "vivado 工程","vivado/dual_corner"
  "HLS工程","hls/dual_corner"
  "HLS工程","hls/mem2stream"
  "HLS工程","hls/stream2mem"
  "BOOT.bin文件","bootimage"

实验结果
=======================================================

.. image:: images/images8/image67.png
       
这里角点多少与聚焦位置及阀值有关。需要根据场景调整这两个参数。




