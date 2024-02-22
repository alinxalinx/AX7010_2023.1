Petalinux下的HDMI显示
=====================

**实验Vivado工程为“linux_base” ,在vivado.zip压缩包中。**

**实验petalinux工程相关文件夹为“ax_peta_hdmi”**

前面的教程中我们已经体验了使用Petalinux开发嵌入式Linux系统，但我们使用的功能仅仅是Petalinux冰山一角，Petalinux的强大功能需要我们不断的探索，本实验讲解如何使用一个自己的内核来做Linux，这样我们可以在内核里添加很多驱动，例如HDMI显示。

开发板使用的没有HDMI接口芯片，但是使用了PFGA去完成编码，芯驿电子将Xilinx提供的内核中加入了HDMI编码IP的驱动。\ **请使用其他版本软件开发者注意，本教程只提供修改版linux-xlnx-xlnx_rebase_v6.1_LTS内核，不提供其他版本修改版，也不提供修改说明**\ 。

Petalinux配置
-------------

本实验还是在前面实验的Petalinux工程修改，需要先掌握前面的实验内容。

1) 打开终端，设置petalinux环境变量，运行下面命令

+-----------------------------------------------------------------------+
| source /opt/pkg/petalinux/settings.sh                                 |
+-----------------------------------------------------------------------+

2) 运行下面命令设置vivado环境变量

+-----------------------------------------------------------------------+
| source /tools/Xilinx/Vivado/2023.1/settings64.sh                      |
+-----------------------------------------------------------------------+

.. image:: images/08_media/image1.png
   
3) 将资料中第八章HDMI显示的bsp包复制到虚拟机里，运行命令，用bsp生成PetaLinux工程

+-----------------------------------------------------------------------+
| petalinux-create -t project -n ax_peta -s ./hdmi.bsp                  |
+-----------------------------------------------------------------------+

.. image:: images/08_media/image2.png
   
4) 控制台进入新生成的ax_peta目录，使用下面命令配置petalinux内核来源以及离线编译，具体配置过程参考第五章的5.2和5.3，由于这里我们用的是bsp包，所以这些内容都已经配置好了，如果用户是用xsa文件生成的PetaLinux工程，就需要重新配置这些项。

+-----------------------------------------------------------------------+
| petalinux-config                                                      |
+-----------------------------------------------------------------------+

.. image:: images/08_media/image3.png
   
5) 然后保存退出

.. image:: images/08_media/image4.png
   
配置Linux内核
-------------

1) 运行下面的命令配置内核

+-----------------------------------------------------------------------+
| petalinux-config -c kernel                                            |
+-----------------------------------------------------------------------+

.. image:: images/08_media/image5.png

2) 在弹出的窗口中，进入Device Drivers → Graphics
   support，分别选择以下5项

Xilinx DRM KMS Driver

Xilinx DRM KMS bridge

Digilent DRM Driver

Xilinx DRM PL display driver

Xilinx DRM VTC Driver

.. image:: images/08_media/image6.png
   
3) 在Device Drivers → Graphics support → Frame buffer
   Devices中选择Support for frame buffer devices按y

.. image:: images/08_media/image7.png
   
4) 在Device Drivers → Graphics support →Console display driver
   support选项中选择Framebuffer Console support按y

.. image:: images/08_media/image8.png
   
5) 在Device Drivers → Common Clock Framework选项中选择Digilent
   axi_dynclk Driver按y

.. image:: images/08_media/image9.png
   
6) 保存并退出

.. image:: images/08_media/image10.png
   
修改设备树
----------

设备树是描述设备信息的一种格式化文本，这种文本结构对类似于XML和JSON，
什么？XML和JSON也不会？如果这些基础配置数据格式都没接触过学习设备树是要很长时间摸索的。每个驱动要求的设备树节点也是不同的，对于没接触过设备的开发人员，需要慢慢熟悉，在一次一次的使用种慢慢掌握。

1) 打开petalinux工程文件中的名为system-user.dtsi的文件

.. image:: images/08_media/image11.png

2) 修改设备树内容如下

+-----------------------------------------------------------------------+
| /include/ "system-conf.dtsi"                                          |
|                                                                       |
| / {                                                                   |
|                                                                       |
| model = "Zynq ALINX Development Board";                               |
|                                                                       |
| compatible = "alinx,zynq", "xlnx,zynq-7000";                          |
|                                                                       |
| aliases {                                                             |
|                                                                       |
| ethernet0 = "&gem0";                                                  |
|                                                                       |
| serial0 = "&uart1";                                                   |
|                                                                       |
| };                                                                    |
|                                                                       |
| usb_phy0: usb_phy@0 {                                                 |
|                                                                       |
| compatible = "ulpi-phy";                                              |
|                                                                       |
| #phy-cells = <0>;                                                     |
|                                                                       |
| reg = <0xe0002000 0x1000>;                                            |
|                                                                       |
| view-port = <0x0170>;                                                 |
|                                                                       |
| drv-vbus;                                                             |
|                                                                       |
| };                                                                    |
|                                                                       |
| };                                                                    |
|                                                                       |
| &i2c0 {                                                               |
|                                                                       |
| clock-frequency = <100000>;                                           |
|                                                                       |
| };                                                                    |
|                                                                       |
| &usb0 {                                                               |
|                                                                       |
| dr_mode = "host";                                                     |
|                                                                       |
| usb-phy = <&usb_phy0>;                                                |
|                                                                       |
| };                                                                    |
|                                                                       |
| &sdhci0 {                                                             |
|                                                                       |
| u-boot,dm-pre-reloc;                                                  |
|                                                                       |
| };                                                                    |
|                                                                       |
| &uart1 {                                                              |
|                                                                       |
| u-boot,dm-pre-reloc;                                                  |
|                                                                       |
| };                                                                    |
|                                                                       |
| &flash0 {                                                             |
|                                                                       |
| compatible = "micron,m25p80", "w25q256", "spi-flash";                 |
|                                                                       |
| };                                                                    |
|                                                                       |
| &gem0 {                                                               |
|                                                                       |
| phy-handle = <&ethernet_phy>;                                         |
|                                                                       |
| ethernet_phy: ethernet-phy@1 {                                        |
|                                                                       |
| reg = <1>;                                                            |
|                                                                       |
| device_type = "ethernet-phy";                                         |
|                                                                       |
| };                                                                    |
|                                                                       |
| };                                                                    |
|                                                                       |
| &amba_pl {                                                            |
|                                                                       |
| digilent_hdmi {                                                       |
|                                                                       |
| compatible = "digilent,hdmi";                                         |
|                                                                       |
| clocks = <&axi_dynclk_0>;                                             |
|                                                                       |
| clock-names = "clk";                                                  |
|                                                                       |
| digilent,edid-i2c = <&i2c0>;                                          |
|                                                                       |
| digilent,fmax = <150000>;                                             |
|                                                                       |
| port@0 {                                                              |
|                                                                       |
| #address-cells = <1>;                                                 |
|                                                                       |
| #size-cells = <0>;                                                    |
|                                                                       |
| hdmi_ep: endpoint {                                                   |
|                                                                       |
| remote-endpoint = <&pl_disp_ep>;                                      |
|                                                                       |
| };                                                                    |
|                                                                       |
| };                                                                    |
|                                                                       |
| };                                                                    |
|                                                                       |
| xlnx_pl_disp {                                                        |
|                                                                       |
| compatible = "xlnx,pl-disp";                                          |
|                                                                       |
| dmas = <&axi_vdma_0 0>;                                               |
|                                                                       |
| dma-names = "dma0";                                                   |
|                                                                       |
| xlnx,vformat = "RG24";                                                |
|                                                                       |
| xlnx,bridge = <&v_tc_0>;                                              |
|                                                                       |
| port@0 {                                                              |
|                                                                       |
| reg = <0>;                                                            |
|                                                                       |
| pl_disp_ep: endpoint {                                                |
|                                                                       |
| remote-endpoint = <&hdmi_ep>;                                         |
|                                                                       |
| };                                                                    |
|                                                                       |
| };                                                                    |
|                                                                       |
| };                                                                    |
|                                                                       |
| };                                                                    |
|                                                                       |
| &axi_dynclk_0 {                                                       |
|                                                                       |
| compatible = "dglnt,axi-dynclk";                                      |
|                                                                       |
| #clock-cells = <0>;                                                   |
|                                                                       |
| clocks = <&clkc 15>;                                                  |
|                                                                       |
| };                                                                    |
|                                                                       |
| &v_tc_0 {                                                             |
|                                                                       |
| compatible = "xlnx,bridge-v-tc-6.1";                                  |
|                                                                       |
| xlnx,pixels-per-clock = <1>;                                          |
|                                                                       |
| };                                                                    |
+-----------------------------------------------------------------------+

编译测试Petalinux工程
---------------------

1) 使用下面命令配置编译uboot、内核、根文件系统、设备树等。

+-----------------------------------------------------------------------+
|   petalinux-build                                                     |
+-----------------------------------------------------------------------+

.. image:: images/08_media/image12.png

2) 运行下面命令生成BOOT文件，注意空格和短线

+-----------------------------------------------------------------------+
| petalinux-package --boot --fsbl ./images/linux/zynq_fsbl.elf --fpga   |
| --u-boot --force                                                      |
+-----------------------------------------------------------------------+

3) 把BOOT.bin，iamge.ub和boot.scr复制到sd中，设置开发板sd模式启动，插上HDMI显示器，启动开发板。

.. image:: images/08_media/image13.png
   
4) 显示器会显示出如下内容

.. image:: images/08_media/image14.png
   
常见问题
--------

如何防止系统休眠
~~~~~~~~~~~~~~~~

休眠之前运行命令

echo -e " \\033[9;0]\\033[?33l\\033[?25h\\033[?1c" > /dev/tty0

echo -e " \\033[9;0]\\033[?33l\\033[?25h\\033[?1c" > /dev/tty1

echo -e " \\033[9;0]\\033[?33l\\033[?25h\\033[?1c" > /dev/tty

echo -e " \\033[9;0]\\033[?33l\\033[?25h\\033[?1c" > /dev/console
