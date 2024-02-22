自动运行的petalinux应用程序
===========================

前面的教程中我们使用了大量petalinux来创建Linux应用，而且很多时候把根文件系统选为ramdisk类型，不能保存我们配置数据，所以我们需要一个上电能自动运行程序的shell文件。

例程中给了一个做好的应用程序，可以完成上电自动挂载sd卡第一分区到/sd，然后运行/sd下的startup.sh文件。

准备工作
--------

在xilinx提供的petalinux资料\ `UG1144 <https://www.xilinx.com/support/documentation/sw_manuals/xilinx2017_4/ug1144-petalinux-tools-reference-guide.pdf>`__\ 中，有个章节“Creating
and Adding Custom
Applications”，将如何创建一个自定义应用程序，通过下面命令来创建

+-----------------------------------------------------------------------+
| $ petalinux-create -t apps [--template TYPE] --name --enable          |
+-----------------------------------------------------------------------+

对于专业的软件开发人员来说，学习起来可能比较简单，所以这里不再描述细节，我们把已经做好的app提供给大家。

autostart 应用程序
------------------

1) 创建好的应用程序都会在文件夹project-spec/meta-user/recipes-apps下出现，我们也可以直接把app复制到这个目录下

.. image:: images/18_media/image1.png
   
2) startup文件夹下有个autostart.bb文件

.. image:: images/18_media/image2.png
   
3) 用文本工具打开，do_install函数是安装应用的shell，我们可以大致猜测，安装过程会把files目录中的autostart.sh文件复制到根文件系统的init.d文件夹下，这样就可以上电自动运行这个文件。

.. image:: images/18_media/image3.png
   
4) files目录中主要文件是autostart.sh，它是系统启动后会自动运行的脚本。

.. image:: images/18_media/image4.png
   
5) autostart.sh是先判断挂载在系统下的SD卡第一分区和第二分区autostart.sh文件是不是存在，如果存在就运行。所以只要我们在sd的分区任意一个放一个startup.sh，就可以实现上电自动运行。

.. image:: images/18_media/image5.png
   