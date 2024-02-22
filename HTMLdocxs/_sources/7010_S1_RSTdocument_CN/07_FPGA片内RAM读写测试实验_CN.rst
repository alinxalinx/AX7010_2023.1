FPGA片内RAM读写测试实验
===========================

**实验Vivado工程为“ram_test”。**

RAM是FPGA中常用的基础模块，可广泛用于缓存数据的情况，同样它也是ROM，FIFO的基础。本实验将为大家介绍如何使用FPGA内部的RAM以及程序对该RAM的数据读写操作。

实验原理
--------

Xilinx在VIVADO里为我们已经提供了RAM的IP核,
我们只需通过IP核例化一个RAM，根据RAM的读写时序来写入和读取RAM中存储的数据。实验中会通过VIVADO集成的在线逻辑分析仪ila，我们可以观察RAM的读写时序和从RAM中读取的数据。

创建Vivado工程
--------------

在添加RAM IP之前先新建一个ram_test的工程, 然后在工程中添加RAM IP，方法如下：

1. 点击下图中IP Catalog，在右侧弹出的界面中搜索ram，找到Block Memory Generator,双击打开。

.. image:: images/07_media/image1.png
      
2. 将Component Name改为ram_ip,在Basic栏目下，将Memory Type改为Simple Dual Prot RAM，也就是伪双口RAM。一般来讲"Simple Dual Port RAM"是最常用的，因为它是两个端口，输入和输出信号独立。

.. image:: images/07_media/image2.png
      
3. 切换到Port A Options栏目下，将RAM位宽Port A
Width改为16，也就是数据宽度。将RAM深度Port A
Depth改为512，深度指的是RAM里可以存放多少个数据。使能管脚Enable Port
Type改为Always Enable。\ |image1|

4. 切换到Port B Options栏目下，将RAM位宽Port B
Width改为16，使能管脚Enable Port Type改为Always Enable，当然也可以Use
ENB Pin，相当于读使能信号。而Primitives Output
Register取消勾选，其功能是在输出数据加上寄存器，可以有效改善时序，但读出的数据会落后地址两个周期。很多情况下，不使能这项功能，保持数据落后地址一个周期。

.. image:: images/07_media/image4.png
      
5. 在Other Options栏目中，这里不像ROM那样需要初始化RAM的数据，我们可以在程序中写入，所以配置默认即可，直接点击OK。

.. image:: images/07_media/image5.png
      
6) 点击“Generate”生成RAM IP。

.. image:: images/07_media/image6.png
      
RAM的端口定义和时序
-------------------

Simple Dual Port RAM 模块端口的说明如下：

+-----------------+-------------+-------------------------------------+
| 信号名称        | 方向        | 说明                                |
+=================+=============+=====================================+
| clka            | in          | 端口A时钟输入                       |
+-----------------+-------------+-------------------------------------+
| wea             | in          | 端口A使能                           |
+-----------------+-------------+-------------------------------------+
| addra           | in          | 端口A地址输入                       |
+-----------------+-------------+-------------------------------------+
| dina            | in          | 端口A数据输入                       |
+-----------------+-------------+-------------------------------------+
| clkb            | in          | 端口B时钟输入                       |
+-----------------+-------------+-------------------------------------+
| addrb           | in          | 端口B地址输入                       |
+-----------------+-------------+-------------------------------------+
| doutb           | out         | 端口B数据输输出                     |
+-----------------+-------------+-------------------------------------+

RAM的数据写入和读出都是按时钟的上升沿操作的，端口A数据写入的时候需要置高wea信号，同时提供地址和要写入的数据。下图为输入写入到RAM的时序图。

.. image:: images/07_media/image7.png
      
**RAM写时序**

而端口B是不能写入数据的，只能从RAM中读出数据，只要提供地址就可以了，一般情况下可以在下一个周期采集到有效的数据。

.. image:: images/07_media/image8.png
      
**RAM读时序**

测试程序编写
------------

下面进行RAM的测试程序的编写，由于测试RAM的功能，我们向RAM的端口A写入一串连续的数据，只写一次，并从端口B中读出，使用逻辑分析仪查看数据。代码如下

.. code:: verilog

 `timescale 1ns / 1ps
 //////////////////////////////////////////////////////////////////////////////////
 module ram_test(
 			input      sys_clk_p,            //system clock 200Mhz on board
             input      sys_clk_n,            //system clock 200Mhz on board
 			input rst_n	             	//复位信号，低电平有效	
 		);
 
 //-----------------------------------------------------------
 reg		[8:0]  		w_addr;	   		//RAM PORTA写地址
 reg		[15:0] 		w_data;	   		//RAM PORTA写数据
 reg 	      		wea;	    	//RAM PORTA使能
 reg		[8:0]  		r_addr;	  	 	//RAM PORTB读地址
 wire	[15:0] 		r_data;			//RAM PORTB读数据
 
 
 wire clk ;
 
    IBUFDS #(
       .DIFF_TERM("FALSE"),       // Differential Termination
       .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
       .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
    ) IBUFDS_inst (
       .O(clk),  // Buffer output
       .I(sys_clk_p),  // Diff_p buffer input (connect directly to top-level port)
       .IB(sys_clk_n) // Diff_n buffer input (connect directly to top-level port)
    );
 
 //产生RAM PORTB读地址
 always @(posedge clk or negedge rst_n)
 begin
   if(!rst_n) 
 	r_addr <= 9'd0;
   else if (|w_addr)			//w_addr位或，不等于0
     r_addr <= r_addr+1'b1;
   else
 	r_addr <= 9'd0;	
 end
 
 //产生RAM PORTA写使能信号
 always@(posedge clk or negedge rst_n)
 begin	
   if(!rst_n) 
   	  wea <= 1'b0;
   else 
   begin
      if(&w_addr) 			//w_addr的bit位全为1，共写入512个数据，写入完成
         wea <= 1'b0;                 
      else               
         wea	<= 1'b1;        //ram写使能
   end 
 end 
 
 //产生RAM PORTA写入的地址及数据
 always@(posedge clk or negedge rst_n)
 begin	
   if(!rst_n) 
   begin
 	  w_addr <= 9'd0;
 	  w_data <= 16'd1;
   end
   else 
   begin
      if(wea) 					//ram写使能有效
 	 begin        
 		if (&w_addr)			//w_addr的bit位全为1，共写入512个数据，写入完成
 		begin
 			w_addr <= w_addr ;	//将地址和数据的值保持住，只写一次RAM
 			w_data <= w_data ;
 		end
 		else
 		begin
 			w_addr <= w_addr + 1'b1;
 			w_data <= w_data + 1'b1;
 		end
 	 end
   end 
 end 
 
 //-----------------------------------------------------------
 //实例化RAM	
 ram_ip ram_ip_inst (
   .clka      (clk          ),     // input clka
   .wea       (wea          ),     // input [0 : 0] wea
   .addra     (w_addr       ),     // input [8 : 0] addra
   .dina      (w_data       ),     // input [15 : 0] dina
   .clkb      (clk          ),     // input clkb
   .addrb     (r_addr       ),     // input [8 : 0] addrb
   .doutb     (r_data       )      // output [15 : 0] doutb
 );
 
 //实例化ila逻辑分析仪
 ila_0 ila_0_inst (
 	.clk	(clk	), 
 	.probe0	(r_data	), 
 	.probe1	(r_addr	) 
 );
 
 	
 endmodule

为了能实时看到RAM中读取的数据值，我们这里添加了ila工具来观察RAM PORTB的数据信号和地址信号。关于如何生成ila大家请参考”PL的”Hello World”LED实验”。

.. image:: images/07_media/image9.png
      
程序结构如下：

.. image:: images/07_media/image10.png
      
绑定引脚

::

 ############## clock and reset define##################
 create_clock -period 20 [get_ports clk]
 set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
 set_property PACKAGE_PIN U18 [get_ports {clk}]
 
 set_property IOSTANDARD LVCMOS33 [get_ports {rst_n}]
 set_property PACKAGE_PIN N15 [get_ports {rst_n}]

仿真
----

仿真方法参考”PL的”Hello World”LED实验”，仿真结果如下，从图中可以看出地址1写入的数据是0002，在下个周期，也就是时刻2，有效数据读出。

.. image:: images/07_media/image11.png
      
板上验证
--------

生成bitstream，并下载bit文件到FPGA。接下来我们通过ila来观察一下从RAM中读出的数据是否为我们初始化的数据。

在Waveform的窗口设置r_addr地址为0作为触发条件，我们可以看到r_addr在不断的从0累加到1ff,随着r_addr的变化, r_data也在变化,
r_data的数据正是我们写入到RAM中的512个数据，这里需要注意，r_addr出现新地址时，r_data对应的数据要延时两个时钟周期才会出现，数据比地址出现晚两个时钟周期，与仿真结果一致。

.. image:: images/07_media/image12.png
      
.. |image1| image:: images/07_media/image3.png
      