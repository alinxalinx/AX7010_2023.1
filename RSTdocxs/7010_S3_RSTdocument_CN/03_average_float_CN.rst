浮点协处理
========================================

实验介绍
========================================
在应用中,有时会出现需要进行大量浮点或其它类型数据运算的情况,此时将占用大量cpu的时间。若将此类运算放至fpga端,cpu仅需发起请求和读取结果,将节约大量cpu宝贵时间,特别在有多组相同类型操作需求的时候,我们利用fpga多个模块并发操作,将会大大缩短总时间,提高处理任务的实时性。
这里,我们设计一个模块,由cpu指定float类型数据存放地址和数据长度,求它们的平均值。计算完成后,通过中断方式,通知cpu。

IP创建
========================================

HLS源代码
----------------------------------------

.. code:: c

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

接口介绍
----------------------------------------
这里共生成两个端口,axi4和axi4-lite。模块从传递进来的src地址处,通过axi4端口主动读取数据,数组长度“num”与控制接口“return”通过axi4-lite端口管理。

运算
----------------------------------------
for循环内,dataflows可以使memcpy与子for循环形成流水。插入“#pragma HLS pipeline“,作用是使本循环形成流水线,提高运算速度。

其它说明
----------------------------------------

“depth=1024“与” #pragma HLS loop_tripcount min=0 max=1024”仅作用于TestBench,前者表示当前数组最大长度为1024,后者表示for循环最少循环0次,最多循环1024次。

工程路径
========================================

.. csv-table:: 
  :header: "名称", "路径"
  :widths: 20, 20

  "Vivado工程","vivado/average_float"
  "HLS工程","hls/average_float"
  "BOOT.bin文件","bootimage"

运行效果
========================================
vitis运行后,串口将会打印出arm和fpga进行1024个浮点数求和平均数用时




