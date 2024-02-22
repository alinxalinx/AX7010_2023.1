QT在ZYNQ上的应用
================

Qt是跨平台C++图形用户界面应用程序开发框架，可以简单的将它理解为用于图形开发的库。如果我们使用Qt库为板卡开发带界面的应用程序，则需要交叉编译Qt库。OpenCV是视频处理中有名的库，很多应用程序需要使用OpenCV库，以往QT和OpenCV库都需要自己下载代码编译，非常麻烦。本章讲解如何使用Petalinux配置OpenCV和QT的开发环境，再次体现出Petalinux开发环境的优势，只需简单的配置就可以解决很复杂的问题。

QT Creator安装
--------------

我们在Ubuntu中安装QT
Creator，安装文件名称为“qt-opensource-linux-x64-5.7.1.run”，从文件名我们可以看出QT版本为5.7.1，这些版本也是我们精心挑选，适合当前环境的版本。

1) 将安装文件复制到Ubuntu主机中

.. image:: images/11_media/image1.png

2) 添加运行权限

+-----------------------------------------------------------------------+
| sudo chmod +x qt-opensource-linux-x64-5.7.1.run                       |
+-----------------------------------------------------------------------+

.. image:: images/11_media/image2.png

3) 运行安装软件

+-----------------------------------------------------------------------+
| sudo ./qt-opensource-linux-x64-5.7.1.run                              |
+-----------------------------------------------------------------------+

.. image:: images/11_media/image3.png

4) 点击Next开始安装

.. image:: images/11_media/image4.png

5) 点击“Skip”跳过账号信息填写

.. image:: images/11_media/image5.png

6) 点击“Next”继续安装

.. image:: images/11_media/image6.png

7) 安装路径保持默认，点击“Next”继续安装

.. image:: images/11_media/image7.png

8) 保持默认安装选项，点击“Next”继续安装

.. image:: images/11_media/image8.png

9) 选择同意License许可

.. image:: images/11_media/image9.png

10) 点击“Install”安装

.. image:: images/11_media/image10.png

11) 点击“Finish”完成安装

.. image:: images/11_media/image11.png

QT库交叉编译
------------

前面安装的QT可以创建在x86处理器上运行的应用程序，不能建立ZYNQ能运行的程序，我们需要交叉编译QT的源代码才能在zynq上运行。为了简化编译流程，芯驿电子准备好了QT
5.7.1的源代码包，并制作了一些编译脚本。

1) 将压缩包复制到Ubuntu主机中

.. image:: images/11_media/image12.png

2) 将压缩包解压

+-----------------------------------------------------------------------+
| tar -zxvf alinx_qt_5.7.1.tar.gz                                       |
+-----------------------------------------------------------------------+

.. image:: images/11_media/image13.png

3) 解压后的文件夹，“fonts”是QT应用程序显示需要用到的字体文件，“qt-everywhere-opensource-src-5.7.1”是QT源代码文件夹，“build.sh”是编译脚本，“make_img.sh”是把编译的库打包成img镜像文件。

.. image:: images/11_media/image14.png

4) “build.sh”脚本中指定了XSDK的安装目录，主要使用XSDK自带的交叉编译器，如果你的SDK安装目录和脚本里不同，请修改XSDK路径，同时指定ZYNQ版本QT库的安装路径为“/opt/alinx/zynq_qt5.7.1”,编译完成以后可以在这个路径里找到交叉编译过的QT库，不建议修改此路径。

.. image:: images/11_media/image15.png

5) 运行编译脚本

+-----------------------------------------------------------------------+
| ./build.sh                                                            |
+-----------------------------------------------------------------------+

.. image:: images/11_media/image16.png

6) 等待一段时间，编译快完成时需要输入Ubuntu账户密码

.. image:: images/11_media/image17.png

7) 输入密码后，编译安装完成

.. image:: images/11_media/image18.png

8) 到目录“/opt/alinx/zynq_qt5.7.1”下我们可以找到bin目录，里面有我们要用到的qmake文件，和lib目录，这个目录就是我们需要的QT库。

.. image:: images/11_media/image19.png

9) 运行脚本制作QT库的img文件，需要输入账号密码

+-----------------------------------------------------------------------+
| ./make_img.sh                                                         |
+-----------------------------------------------------------------------+

.. image:: images/11_media/image20.png

10) 得到qt_lib.img可以在zynq板上挂载

.. image:: images/11_media/image21.png

配置ZYNQ版QT Kits
-----------------

1) 运行QT Creator，找不到应用程序快捷方式，可以搜索一下。

.. image:: images/11_media/image22.png

2) 点击Tools -> Options

.. image:: images/11_media/image23.png

3) 在Build & Run选项的Qt Versions页点击Add..

.. image:: images/11_media/image24.png

4) 选择前面编译生成的qmake文件

.. image:: images/11_media/image25.png

5) 添加qmake以后，保持默认name，不修改

.. image:: images/11_media/image26.png

6) 在Compilers页面，点击Add..，选择GCC -> C

.. image:: images/11_media/image27.png

7) Name修改为ZYNQ_GCC，Compiler
   path选择/tools/Xilinx/Vitis/2023.1/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin/arm-linux-gnueabihf-gcc

.. image:: images/11_media/image28.png
   
8) 在Compilers页面，点击Add..，选择GCC ->
   C++，Name修改为ZYNQ_C++，路径选择/tools/Xilinx/Vitis/2023.1/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin/arm-linux-gnueabihf-g++

.. image:: images/11_media/image29.png
   
9) 再点击“Apply”，更新信息

.. image:: images/11_media/image30.png
   
在Kits页，点击Add添加一个新的Kit，Name修改为ZYNQ，Compiler
C：选择ZYNQ_GCC，Compiler C++选择ZYNQ_C++，Qt version选择Qt
5.7.1(zynq_qt5.7.1)

.. image:: images/11_media/image31.png

10) 点击OK配置Kits完成

创建QT测试工程
--------------

1) 点击File -> New File or Project

.. image:: images/11_media/image32.png

2) 工程模板选择“Application”“Qt Widgets
   Application”，然后点击“Choose...”

.. image:: images/11_media/image33.png

3) Name修改为qt_test，路径本实验选择/home/alinx/work

.. image:: images/11_media/image34.png

4) kit选择，这里选择ZYNQ版本

.. image:: images/11_media/image35.png

5) 选择Next继续

.. image:: images/11_media/image36.png

6) 选择Finish结束工程创建向导

.. image:: images/11_media/image37.png

7) 双击mainwindow.ui文件

.. image:: images/11_media/image38.png

8) 拖拽一个Push Button到主界面中

.. image:: images/11_media/image39.png

9) 双击文字部分，可以修改按钮文字

.. image:: images/11_media/image40.png

10) 在Projects选择，选择“Desktop Qt 5.7.1 GCC
    64bit”,然后点击绿色三角运行Host版本

.. image:: images/11_media/image41.png

11) 运行效果

.. image:: images/11_media/image42.png

12) 选择ZYNQ Kit，点击锤子图标，只编译程序，不运行

.. image:: images/11_media/image43.png

13) 在build-qt_test-ZYNQ-Debug目录可以看到生成了一个qt_test的文件，这个文件要在ZYNQ上运行。

.. image:: images/11_media/image44.png

常见问题
--------

如何使用开发板Debian系统自带的QT Creator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1) 配置编译器

.. image:: images/11_media/image45.png

2) 查看qmake路径是否正确

.. image:: images/11_media/image46.png

3) 查看Kits设置是否和下图一致

.. image:: images/11_media/image47.png

4) 配置完成后就可以建立一个工程测试一下

.. image:: images/11_media/image48.png

系统运行打印I2C错误信息
~~~~~~~~~~~~~~~~~~~~~~~

可以忽略这个错误信息

.. image:: images/11_media/image49.png
