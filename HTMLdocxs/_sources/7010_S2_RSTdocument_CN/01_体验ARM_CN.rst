体验ARM，裸机输出“Hello World”
================================

**实验Vivado工程为“ps_hello”。**

**从本章开始由FPGA工程师与软件开发工程师协同实现。**

前面的实验都是在PL端进行的，可以看到和普通FPGA开发流程没有任何区别，ZYNQ的主要优势就是FPGA和ARM的合理结合，这对开发人员提出了更高的要求。从本章开始，我们开始使用ARM，也就是我们说的PS，本章我们使用一个简单的串口打印来体验一下Vivado
Vitis和PS端的特性。

前面的实验都是FPGA工程师应该做的事情，从本章节开始就有了分工，FPGA工程师负责把Vivado工程搭建好，提供好硬件给软件开发人员，软件开发人员便能在这个基础上开发应用程序。做好分工，也有利于项目的推进。如果是软件开发人员想把所有的事情都做了，可能需要花费很多时间和精力去学习FPGA的知识，由软件思维转成硬件思维是个比较痛苦的过程，如果纯粹的学习，又有时间，就另当别论了。专业的人做专业的事，是个很好的选择。

硬件介绍
--------

我们从原理图中可以看到ZYNQ芯片分为PL和PS，PS端的IO分配相对是固定的，不能任意分配，而且不需要在Vivado软件里分配管脚，虽然本实验仅仅使用了PS，但是还要建立一个Vivado工程，用来配置PS管脚。虽然PS端的ARM是硬核，但是在ZYNQ当中也要将ARM硬核添加到工程当中才能使用。前面章节介绍的是代码形式的工程，本章开始介绍ZYNQ的图形化方式建立工程。

FPGA工程师工作内容
------------------

下面介绍FPGA工程师负责内容。

Vivado工程建立
--------------

1) 创建一个名为“ps_hello”的工程，建立过程不再赘述，参考“PL的”Hello World”LED实验”。

2) 点击“Create Block Design”，创建一个Block设计，也就是图形化设计

.. image:: images/01_media/image1.png
      
3) “Design name”这里不做修改，保持默认“design_1”，这里可以根据需要修改，不过名字要尽量简短，否则在Windows下编译会有问题。

.. image:: images/01_media/image2.png
      
4) 点击“Add IP”快捷图标

.. image:: images/01_media/image3.png
      
5) 搜索“zynq”，在搜索结果列表中双击“ZYNQ7 Processing System”

.. image:: images/01_media/image4.png
      
6) 双击Block图中的“processing_system7_0”，配置相关参数

.. image:: images/01_media/image5.png
      
7) 首先出现的界面是ZYNQ硬核的架构图，可以很清楚看到它的结构，可以参考ug585文档，里面有对ZYNQ的详细介绍。图中绿色部分是可配置模块，可以点击进入相应的编辑界面，当然也可以在左侧的窗口进入编辑。下面对各个窗口的功能一一介绍。

.. image:: images/01_media/image6.png
      
8) 接下来是PS-PL
Configuration界面，这个界面主要是进行PS与PL之间接口的配置，主要是AXI接口，这些接口可以扩展PL端的AXI接口外设，所以PL如果要和PS进行数据交互，都要按照AXI总线协议进行，xilinx为我们提供了大量的AXI接口的IP
核。在这里保持默认，在后面的章节中会对其配置，本章节不与PL端进行交互，保持默认。

.. image:: images/01_media/image7.png
      
9) 之后进入PS端外设的配置阶段，一开始接触ZYNQ可能会很疑惑，看到密密麻麻的外设，无从下手。这里解释一下，ZYNQ的PS端外设很多是复用的，相同的引脚标号可以配置成不一样的功能，比如下图中的16-27可以配置成Enet0，也可以配置成SD0、SD1，但只能配置成一种外设，比如如果配置Enet0，也就不能再选择SD0、SD1了。
至于该怎么去选择，是由原理图和PCB决定的，可以通过查看原理图或用户手册选择。

.. image:: images/01_media/image8.png
      
.. image:: images/01_media/image9.png
      
PS端外设原理图

PS端外设配置
~~~~~~~~~~~~

1)  从原理图中我们可以找到串口连接在PS的MIO48-MIO49上，所以在“Peripheral I/O Pins”选项中使能UART1（MIO48 MIO49），PS端MIO分为两个Bank，Bank 0 ，也就是原理图中的BANK500，电压选择“LVCMOS 3.3V”，Bank 1，也就是原理图中的BANK501，电压选择“LVCOMS 1.8 V”。\ **如果不配置Bank1电平标准，可能导致串口无法接收**\ 。

.. image:: images/01_media/image10.png
      
11) 配置QSPI，QSPI可以作为ZYNQ的启动存储设备，ZYNQ可以通过读取QSPI中存储的启动文件加载ARM和FPGA，从原理图得知，我们选择Quad SPI Flash为Single SS 4bit IO

.. image:: images/01_media/image11.png
      
12) 配置以太网，在PS端设计有以太网接口，根据原理图选择Ethernet 0到MIO16-MIO27

.. image:: images/01_media/image12.png
      
MDIO为以太网PHY寄存器配置接口，选择MDIO并配置到MIO52-MIO53

.. image:: images/01_media/image13.png
      
13) 配置USB0到MIO28-MIO39

.. image:: images/01_media/image14.png
      
14) 除了QSPI启动ZYNQ，还有SD卡模式启动ZYNQ，选择SD 0，配置到MIO40-MIO45，选择Card Detection MIO47，用于检测SD卡的插入。

.. image:: images/01_media/image15.png
      
15) 打开GPIO MIO，PS便可以控制剩余未分配的MIO，用作GPIO

.. image:: images/01_media/image16.png
      
在GPIO MIO中选择MIO46作为USB PHY的复位

.. image:: images/01_media/image17.png
      
至此，外设配置结束。

MIO配置
~~~~~~~

修改Enet0的电平标准为HSTL 1.8V，Speed 为
fast，这些参数非常重要，如果不修改，网络可能不通。其他部分保持默认。

.. image:: images/01_media/image18.png
      
时钟配置
~~~~~~~~

16) 在“Clock Configuration”选项卡中我们可以配置PS时钟输入时钟频率，这里默认是33.333333，和板子上一致，不用修改，CPU频率默认666.666666Mhz，这里也不修改。同时PS还可以给PL端提供4路时钟，频率可以配置，这里不需要，所以保持默认即可。还有PS端外设的时钟等也可以进行配置，这里保持默认。

.. image:: images/01_media/image19.png
      
DDR3配置
~~~~~~~~

17) 在“DDR Configuration”选项卡中可以配置PS端ddr的参数，AX7010配置DDR3型号为“MT41J128M16 HA-125”， AX7020配置DDR3型号为“MT41J256M16 RE-125”，\ **这里ddr3型号并不是板子上的ddr3型号，而是参数最接近的型号**\ 。Effective DRAM Bus Width”，选择“32 Bit”

.. image:: images/01_media/image20.png
      
AX7010 DDR3配置

.. image:: images/01_media/image21.png
      
AX7020 DDR3配置

其他部分保持默认，点击OK。至此ZYNQ核的配置结束。

18) 点击“Run Block Automation”，vivado软件会自动完成一些导出端口的工作

.. image:: images/01_media/image22.png
      
19) 按照默认点击“OK”

.. image:: images/01_media/image23.png
      
20) 点击“OK”以后我们可以看到PS端导出一些管脚，包括DDR还有FIXED_IO，DDR是DDR3的接口信号，FIXED_IO为PS端固定的一些接口，比如输入时钟，PS端复位信号，MIO等。

.. image:: images/01_media/image24.png
      
21) 连接FCLK_CLK0到M_AXI_GP0_ACLK，按Ctrl+S保存设计

.. image:: images/01_media/image25.png
      
*知识点：DDR和FIXED_IO是PS端引脚，PS_PORB为PS端上电复位信号，不能用于PL端复位，不要将PL端的复位绑定到这个引脚号上，切记！！！*

.. image:: images/01_media/image26.png
      
22) 选择Block设计，右键“Create HDL Wrapper...”,创建一个Verilog或VHDL文件，为block design生成HDL顶层文件。

.. image:: images/01_media/image27.png
      
23) 保持默认选项，点击“OK”

.. image:: images/01_media/image28.png
      
24) 展开设计可以看到PS被当成一个普通IP 来使用。

.. image:: images/01_media/image29.png
      
25) 选择block设计，右键“Generate Output Products”，此步骤会生成block的输出文件，包括IP，例化模板，RTL源文件，XDC约束，第三方综合源文件等等。供后续操作使用。

.. image:: images/01_media/image30.png
      
26) 点击“Generate”

.. image:: images/01_media/image31.png
      
27) 其实并不是说PS端的引脚不需要绑定，而是在IP生成的输出文件里已经包含了PS端引脚分配的XDC文件，在IP Sources，Block Designsdesign_1Synthesis中，可以看到处理器的XDC文件，绑定了PS端的IO，因此不需要再新建XDC绑定这些引脚。

.. image:: images/01_media/image32.png
      
28) 在菜单栏“File -> Export -> Export Hardware...”导出硬件信息，这里就包含了PS端的配置信息。

.. image:: images/01_media/image33.png
      
29) 在弹出的对话框中点击“OK”，因为实验仅仅是使用了PS的串口，不需要PL参与，这里就没有使能“Include bitstream”，导出路径可以自由选择，本实验保存在工程路径下面新建文件夹vitis，这个文件夹可以根据自己的需要在合适的位置新建，不一定要放在vivado工程下面，vivado和vitis软件是独立的。

.. image:: images/01_media/image34.png
      
.. image:: images/01_media/image35.png
      
此时在新建的vitis文件夹下可以看到xsa文件，这个文件就是这个文件就包含了Vivado硬件设计的信息，供软件开发人员使用。

.. image:: images/01_media/image36.png
      
到此为止，FPGA工程师工作告一段落。

软件工程师工作内容
------------------

以下为软件工程师负责内容。

Vitis调试
---------

创建Application工程
~~~~~~~~~~~~~~~~~~~

1) Vitis是独立的软件，我们可以通过ToolsLaunch Vitis打开Vitis软件

.. image:: images/01_media/image37.png
      
也可以需要双击Vitis软件打开

.. image:: images/01_media/image38.png
         
选择之前新建的文件夹，点击”Launch”

.. image:: images/01_media/image39.png
         
2) 启动Vitis之后界面如下，点击“Create Application Project”，这个选项会生成APP工程以及Platfrom工程，Platform工程类似于以前版本的hardware platform，包含了硬件支持的相关文件以及BSP。

.. image:: images/01_media/image40.png
         
3) 点击Next

.. image:: images/01_media/image41.png
         
4) 点击“Create a new platform hardware(XSA)，软件已经提供了一些板卡的硬件平台，但对于我们自己的硬件平台，可以选择”+”

.. image:: images/01_media/image42.png
         
5) 选择之前生成的xsa，点击打开

.. image:: images/01_media/image43.png
         
6) 最下面的Generate boot components选项，如果勾选上，软件会自动生成fsbl工程，我们一般选择默认勾选上。点击Next

.. image:: images/01_media/image44.png
         
7) 项目名称填入“hello”，也可以根据自己的需要填写,CPU默认选择ps7_cortexa9_0，OS选择standalone，点击Next

.. image:: images/01_media/image45.png
         
.. image:: images/01_media/image46.png
         
8) 模板选择Hello World，点击Finish

.. image:: images/01_media/image47.png
         
9) 完成之后可以看到生成了两个工程，一个是硬件平台工程，即之前所说的Platfrom工程，一个是APP工程

.. image:: images/01_media/image48.png
         
10) 展开Platform工程后可以看到里面包含有BSP工程，以及zynq_fsbl工程（此工程即选择Generate boot components之后的结果）,双击platform.spr即可看到Platform对应生成的BSP工程，可以在这里对BSP进行配置。软件开发人员比较清楚，BSP也就是Board Support Package板级支持包的意思，里面包含了开发所需要的驱动文件，用于应用程序开发。可以看到Platform下有多个BSP，这是跟以往的Vitis软件不一样的，其中zynq_fsbl即是fsbl的BSP，standalone on ps7_cortexa9_0即是APP工程的BSP。也可以在Platform里添加BSP，在以后的例程中再讲。

.. image:: images/01_media/image49.png
         
11) 点开BSP，即可看到工程带有的外设驱动，其中Documentation是xilinx提供的驱动的说明文档，Import Examples是xilinx提供的example工程，加快学习。

.. image:: images/01_media/image50.png
      
12) 选中APP工程，右键Build Project，或者点击菜单栏的“锤子”按键，进行工程编译

.. image:: images/01_media/image51.png
      
13) 可以在Console看到编译过程

.. image:: images/01_media/image52.png
      
编译结束，生成elf文件

.. image:: images/01_media/image53.png
      
14) 连接JTAG线到开发板、UART的USB线到PC

15) 使用PuTTY软件做为串口终端调试工具，PuTTY是一个免安装的小软件

.. image:: images/01_media/image54.png
      
16) 选择Serial，Serial line填写COM3，Speed填写115200，COM3串口号根据设备管理器里显示的填写，点击“Open”

.. image:: images/01_media/image55.png
      
17) 在上电之前最好将开发板的启动模式设置到JTAG模式

.. image:: images/01_media/image56.png
      
18) 给开发板上电，准备运行程序，开发板出厂时带有程序，这里可以把运行模式选择JTAG模式，然后重新上电。选择“hello”，右键，可以看到很多选项，本实验要用到这里的“Run as”，就是把程序运行起来，“Run as”里又有很对选项，选择第一个“Launch on Hardware(Single Application Debug)”，使用系统调试，直接运行程序。

.. image:: images/01_media/image57.png
      
19) 这个时候观察PuTTY软件，即可以看到输出”Hello World”

.. image:: images/01_media/image58.png
      
20) 为了保证系统的可靠调试，最好是右键“Run As -> Run Configuration...”

.. image:: images/01_media/image59.png
      
21) 我们可以看一下里面的配置，其中Reset entire system是默认选中的，这是跟以前的Vitis软件不同的。如果系统中还有PL设计，还必须选择“Program FPGA”。

.. image:: images/01_media/image60.png
      
22) 除了“Run As”，还可以“Debug As”，这样可以设置断点，单步运行

.. image:: images/01_media/image61.png
      
23) 进入Debug模式

.. image:: images/01_media/image62.png
      
24) 和其他C语言开发IDE一样，可以逐步运行、设置断点等

.. image:: images/01_media/image63.png
      
25) 右上角可以切换IDE模式

.. image:: images/01_media/image64.png
      
固化程序
--------

普通的FPGA一般是可以从flash启动，或者被动加载，ZYNQ的启动是由ARM主导的，包括FPGA程序的加载，ZYNQ启动一般为最少两个步骤，在UG585中也有介绍：

Stage 0
:在上电复位或者热复位之后，处理器首先执行BootRom里的代码，这一步是最初始启动设置。BootRom存放了一段用户不可更改的代码，当然是在非JTAG模式下才执行，代码里包含了最基本的NAND，NOR，Quad-SPI，SD和PCAP的驱动。另外一个很重要的作用就是把stage 1的代码搬运到OCM中，就是FSBL代码（First Stage Boot Loader）,空间限制为192KB。

Stage 1:
接下来进入最重要的一步，当BootRom搬运FSBL到OCM后，处理开始执行FSBL代码，FSBL主要有以下几个作用：

-  初始化PS端配置，这些配置也就是在Vivado工程中对ZYNQ核的配置。包括初始化DDR，MIO，SLCR寄存器。主要是执行ps7_init.c和ps7_init.h，ps7_init.tcl的执行效果跟ps7_init.c是一样的。

-  如果有PL端程序，加载PL端bitstream

-  加载second stage bootloader或者bare-metal应用程序到DDR存储器

-  交接给second stage bootloader或bare-metal应用程序

.. image:: images/01_media/image65.png
      
Stage 2: 
Second stage bootloader是可选项，一般是在跑系统的情况下使用，比如linux系统的u-boot，在这里不再介绍，后面会使用petalinux工具制作linux系统。

生成FSBL
~~~~~~~~

FSBL是一个二级引导程序，完成MIO的分配、时钟、PLL、DDR控制器初始化、SD、QSPI控制器初始化，通过启动模式查找bitstream配置FPGA，然后搜索用户程序加载到DDR，最后交接给应用程序执行。详情请参考ug821文档。

1) 由于在新建时选择了Generate boot components选项，所以Platform已经导入了fsbl的工程，并生成了相应的elf文件。

.. image:: images/01_media/image66.png
      
2) 添加调试宏定义FSBL_DEBUG_INFO，可以在启动输出FSBL的一些状态信息，有利于调试，但是会导致启动时间变长。保存文件。可以看一下fsbl里包含了很多外设的文件，包括ps7_init.c，nand，nor，qspi，sd等，在fsbl的main.c中，第一个运行的函数就是ps7_init，至于后面的工作，大家可以再仔细读读代码。当然这个fsbl模板也是可以修改的，至于怎么修改根据自己的需求来做。

.. image:: images/01_media/image67.png
      
3) 重新Build Project

.. image:: images/01_media/image68.png
      
4) 接下来我们可以点击APP工程的system，右键选择Build project

.. image:: images/01_media/image69.png
      
5) 这个时候就会多出一个Debug文件夹，生成了对应的BOOT.BIN

.. image:: images/01_media/image70.png
      
6) 还有一种方法就是，点击APP工程的system右键选择Creat Boot Image，弹出的窗口中可以看到生成的BIF文件路径，BIF文件是生成BOOT文件的配置文件，还有生成的BOOT.bin文件路径，BOOT.bin文件是我们需要的启动文件，可以放到SD卡启动，也可以烧写到QSPI Flash。

.. image:: images/01_media/image71.png
      
.. image:: images/01_media/image72.png
      
7) 在Boot image partitions列表中有要合成的文件，第一个文件一定是bootloader文件，就是上面生成的fsbl.elf文件，第二个文件是FPGA配置文件bitstream，在本实验中由于没有FPGA的bitstream，不需要添加，第三个是应用程序，在本实验中为hello.elf，由于没有bitstream，在本实验中只添加bootloader和应用程序。点击Create Image生成。

.. image:: images/01_media/image73.png
      
8) 在生成的目录下可以找到BOOT.bin文件

.. image:: images/01_media/image74.png
      
SD卡启动测试
~~~~~~~~~~~~

1) 格式化SD卡，只能格式化为FAT32格式，其他格式无法启动

.. image:: images/01_media/image75.png
      
2) 放入BOOT.bin文件，放在根目录

.. image:: images/01_media/image76.png
      
3) SD卡插入开发板的SD卡插槽

4) 启动模式调整为SD卡启动

.. image:: images/01_media/image56.png
      
5) 打开putty软件，上电启动，即可看到打印信息，红色框为FSBL启动信息，黄色箭头部分为执行的应用程序helloworld

.. image:: images/01_media/image77.png
      
QSPI启动测试
~~~~~~~~~~~~

1) 在Vitis菜单Xilinx -> Program Flash

.. image:: images/01_media/image78.png
      
1) Hardware Platform选择最新的，Image FIle文件选择要烧写的BOOT.bin，FSBL file选择fsbl.elf。选择Verify after flash，在烧写完成后校验flash。

.. image:: images/01_media/image79.png
      
2) 点击Program等待烧写完成

.. image:: images/01_media/image80.png
      
3) 设置启动模式为QSPI，再次启动，可以在putty里看到与SD同样的启动效果。

.. image:: images/01_media/image81.png
      
.. image:: images/01_media/image82.png
      
Vivado下烧写QSPI 
~~~~~~~~~~~~~~~~~

1) 在HARDWARE MANGER下选择器件，右键Add Configuration Memory Device

.. image:: images/01_media/image83.png
      
2) 选择尝试Winbond，类型选择qspi，宽度选择x4-single，这时候出现w25q128，选择红框型号，开发板使用w25q256，但是不影响烧录。

.. image:: images/01_media/image84.png
      
3) 右键选择编程文件

.. image:: images/01_media/image85.png
      
4) 选择要烧写的文件和fsbl文件，就可以烧写了，如果烧写时不是JTAG启动模式，软件会给出一个警告，所以建议烧写QSPI的时候设置到JTAG启动模式

.. image:: images/01_media/image86.png
      
使用批处理文件快速烧写QSPI
~~~~~~~~~~~~~~~~~~~~~~~~~~

1) 新建一个program_qspi.txt文本文件，扩展名改为bat,内容填写如下，其中set
XIL_CSE_ZYNQ_DISPLAY_UBOOT_MESSAGES=1设置显示烧写过程中的uboot打印信息，

..

   F:\\Xilinx_Vitis\\Vitis\\2023.1\\bin\\program_flash
   为我们工具路径，按照安装路径适当修改，-f
   为要烧写的文件，-fsbl为要烧写使用的fsbl文件，-verify为校验选项。

::

 call F:\Xilinx_Vitis\Vitis\2023.1\bin\program_flash -f BOOT.bin    -offset 0 -flash_type qspi-x4-single  -fsbl fsbl.elf -verify
 pause

1) 把要烧录的BOOT.bin、fsbl、bat文件放在一起

.. image:: images/01_media/image87.png
      
2) 插上JTAG线后上电，双击bat文件即可烧写flash。

.. image:: images/01_media/image88.png
      
常见问题
--------

仅有PL端逻辑的固化
~~~~~~~~~~~~~~~~~~

有很多人会问，如果只有PL端的逻辑，不需要PS端该怎么固化程序呢？不带ARM的FPGA固化是没问题的，但是对于ZYNQ来说，必须要有PS端的配合才能固化程序。那么对于前面的”PL的“Hello World”LED实验”该怎么固化程序呢？

1. 根据本章的PS端添加ZYNQ核并配置，最简单的方法就是在本章工程的基础上添加LED实验的verilog源文件，并进行例化，组成一个系统，并需要生成bitstream。

.. image:: images/01_media/image89.png
      
.. image:: images/01_media/image90.png
      
2. 生成bitstream之后，导出硬件，选择include bitstream

.. image:: images/01_media/image91.png
         
3. 在生成BOOT.BIN时，还是需要一个app工程hello，仅仅是为了生成BOOT.BIN，默认情况下在system右键Build Project，即可生成包含bitstream的BOOT.BIN。

.. image:: images/01_media/image92.png
      
打开Create Boot Image界面可以看到，Boot Image Partitions的文件顺序是fsbl、bitstream、app，注意顺序不要颠倒，利用这样生成的BOOT.BIN就可以按照前面的启动方式测试启动了

.. image:: images/01_media/image93.png
      
在course_s2文件夹，我们提供了一个名为led_qspi_sd的工程，大家可以参考。

使用技巧分享
------------

在频繁的修改源文件，并进行编译的时候，最好选择APP工程进行Build Project，这种情况下只会生成elf文件。

.. image:: images/01_media/image94.png
      
如果想生成BOOT.BIN文件，可以选择system进行编译，这种情况既会生成elf也会生成BOOT.BIN，笔者最开始用的时候就吃过亏，每次编译都是选择system，结果每次都要等待生成BOOT.BIN，浪费时间，大家可以注意一下。

.. image:: images/01_media/image95.png
      
本章小结
--------

本章从FPGA工程师和软件工程师两者角度出发，介绍了ZYNQ开发的经典流程，FPGA工程师的主要工作是搭建好硬件平台，提供硬件描述文件xsa给软件工程师，软件工程师在此基础上开发应用程序。本章是一个简单的例子介绍了FPGA和软件工程师协同工作，后续还会牵涉到PS与PL之间的联合调试，较为复杂，也是ZYNQ开发的核心部分。

同时也介绍了FSBL，启动文件的制作，SD卡启动方式，QSPI下载及启动方式，Vivado下载BOOT.BIN方式，本章没有FPGA加载文件，后面的应用中会再介绍添加FPGA加载文件制作BOOT.BIN。

后续的工程都会以本章节的配置为准，后面不再介绍ZYNQ的基本配置。

千里之行，始于足下，相信经过本章的学习，大家对ZYNQ开发有了基本概念，高楼稳不稳，要看地基打的牢不牢，虽然本章较为简单，但也有很多知识点待诸位慢慢消化。加油！！！
