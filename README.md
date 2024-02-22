# Xilinx Zynq 7000 Series Development Board AX7010
## Development board introduction
### Development board introduction
This development board uses Xilinx’s Zynq7000 series chip, model XC7Z010-1CLG400I.
400-pin FBGA package. The ZYNQ7000 chip can be divided into the processor system part Processor System (PS)
and Programmable Logic (PL), the programmable logic part. On the AX7010 development board, the PS of ZYNQ7000
Both the part and the PL part are equipped with a wealth of external interfaces and equipment to facilitate user use and function verification. In addition, the development board
Integrated Xilinx USB Cable downloader circuit, users only need to use a USB cable to download and debug the development board.
try.
### Key Features
1. +5V power input, maximum 2A current protection;
2. Xilinx ARM+FPGA chip Zynq-7000 XC7Z010-1CLG400C
3. Two large-capacity 2Gbit (4Gbit in total) high-speed DDR3 SDRAM, which can be used as a cache for ZYNQ chip data and can also be used as memory for operating system running;
4. A 256Mbit QSPI FLASH, which can be used to store system files and user data of the ZYNQ chip;
5. One 10/100M/1000M Ethernet RJ-45 interface, which can be used for Ethernet data exchange with computers or other network devices;
6. One HDMI image video input and output interface, capable of 1080P video image transmission;
7. One high-speed USB2.0 HOST interface, which can be used to connect the development board to USB peripherals such as mouse, keyboard, and U disk;
8. One high-speed USB2.0 OTG interface for OTG communication with PC or USB devices;
9. One USB Uart interface for serial communication with PC or external devices;
10. One-piece RTC real-time clock, equipped with a battery holder, the battery model is CR1220.
11. A piece of EEPROM 24LC04 with IIC interface;
12. 6 user light-emitting diodes LED, 2 PS control, 4 PL control;
13. 7 buttons, 1 CPU reset button, 2 PS control buttons, 4 PL control buttons;
14. The board has a 33.333Mhz active crystal oscillator to provide a stable clock source for the PS system, and a 50MHz active crystal oscillator to provide an additional clock for the PL logic;
15. 2-way 40-pin expansion port (2.54mm pitch), used to expand the IO of the PL part of ZYNQ. Can be connected to expansion modules such as 7-inch TFT module, camera module and AD/DA module;
16. A 12-pin expansion port (2.54mm pitch), used to expand the MIO of ZYNQ's PS system;
17. One USB JTAG port allows debugging and downloading the ZYNQ system through the USB cable and the onboard JTAG circuit. 1-way Micro SD card holder (on the back of the development board), used to store operating system images and file systems.


# AX7010 document tutorial link


 Note: You can switch between Chinese and English languages at the footer at the end of the document

# AX7010 routine
## Routine description
This project is the factory routine of the development board and supports most peripherals on the board.
## Development environment and requirements
* Vivado 2023.1
* AX7010 development board
## Create Vivado project
* Download the latest ZIP package.
* Create a new project folder.
* Unzip the downloaded ZIP package into this project folder.


There are two ways to create a Vivado project, as follows:
### Use Vivado tcl console to create a Vivado project
1. Open the Vivado software and use the **cd** command to enter the "**auto_create_project**" directory and press Enter
```
cd \<archive extracted location\>/vivado/auto_create_project
```
2. Enter **source ./create_project.tcl** and press Enter
```
source ./create_project.tcl
```

### Use bat to create a Vivado project
1. In the "**auto_create_project**" folder, there is a "**create_project.bat**" file, right-click to open it in edit mode, and modify the vivado path to the vivado installation path of this host, save and close.
```
CALL E:\XilinxVitis\Vivado\2023.1\bin\vivado.bat -mode batch -source create_project.tcl
PAUSE
```
2. Double-click the bat file under Windows.


For more information, please visit [ALINX website](https://www.alinx.com)