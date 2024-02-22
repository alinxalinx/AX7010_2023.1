/*
 * audio.c
 *
 *  Created on: 2019Äê7ÔÂ18ÈÕ
 *      Author: myj
 */
#include "xiicps.h"
#include "audio.h"


#define WM8731_DEVADDR  ( 0x34>>1 )

struct reginfo wm8731_init_data[] =
{
		{0x1e,0x00},          //reset
		{0x00,0x97},          //(Left Line In) = 0x97: left line in mute
		{0x02,0x97},          //(Right Line In) = 0x97: right line in mute
		{0x04,0x7f},          //(Left Headphone out) = 0x7f :left headphone +6dB
		{0x06,0x7f},          //(right Headphone out) = 0x7f :right headphone +6dB
		{0x08,0x15},          //(analogue audio path control) = 0x15 : MIC select to DAC
		{0x0a,0x07},          //(digital Audio path control) = 0x07  high pass filter
		{0x0c,0x00},          //(Power down control) = 0x00
		{0x0e,0x02},          //(Digital Audio interface format) = 0x02 : i2s slave mode;
		{0x10,0x00},          //(Sampling control) = 0x00  48KHz
		{0x12,0x01},          //(Active control) = 0x01
		{SEQUENCE_END, 0x00}
};


int audio_i2c_read(XIicPs *IicInstance, char iic_addr, u8 reg_addr,u8 *read_buf)
{
	*read_buf = i2c_reg8_read(IicInstance,iic_addr, reg_addr);
	return XST_SUCCESS;
}

int audio_i2c_write(XIicPs *IicInstance, char iic_addr, u8 reg_addr,u8 data)
{

	return i2c_reg8_write(IicInstance,iic_addr,reg_addr,data);
}

/* write a array of registers  */
void audio_reg_init(XIicPs *IicInstance, Audio *AudioPtr, struct reginfo *regarray)
{
	int i = 0;
	while (regarray[i].reg != SEQUENCE_END) {
		audio_i2c_write(IicInstance, 0x34>>1, regarray[i].reg, regarray[i].val);
		i++;
	}

}

/*
 * Audio reset
 * data : TX_FIFO_RESET_MASK; RX_FIFO_RESET_MASK
 * flag : 1 if reset
 * 		  0 if reset over
 */
void audio_txrx_reset(Audio *AudioPtr, u32 data, u8 flag)
{
	unsigned int value = 0;
	/* Read register value  */
	value = Audio_ReadReg(AudioPtr->BaseAddr, AUDIO_REG_I2S_RESET) ;

	if (flag)
		value |= data ;
	else
		value &= ~data ;
	/* write register  */
	Audio_WriteReg(AudioPtr->BaseAddr, AUDIO_REG_I2S_RESET, data) ;
}
/*
 * Audio tx and rx enable
 * channel : TX_ENABLE_MASK or RX_ENABLE_MASK
 */
void audio_txrx_enable(Audio *AudioPtr, u32 channel)
{
	unsigned int value = 0;
	/* Read register value  */
	value = Audio_ReadReg(AudioPtr->BaseAddr, AUDIO_REG_I2S_CTRL) ;

	value |= channel ;
	/* write register  */
	Audio_WriteReg(AudioPtr->BaseAddr, AUDIO_REG_I2S_CTRL, channel) ;
}
/*
 * Audio tx and rx disable
 * channel : TX_ENABLE_MASK or RX_ENABLE_MASK
 */
void audio_txrx_disable(Audio *AudioPtr, u32 channel)
{
	unsigned int value = 0;
	/* Read register value  */
	value = Audio_ReadReg(AudioPtr->BaseAddr, AUDIO_REG_I2S_CTRL) ;

	value &= ~channel ;
	/* write register  */
	Audio_WriteReg(AudioPtr->BaseAddr, AUDIO_REG_I2S_CTRL, value) ;
}
/*
 * Audio rx stream length setting
 */
void Audio_RxStreamLengthSetting(Audio *AudioPtr, u32 length)
{
	/* write register  */
	Audio_WriteReg(AudioPtr->BaseAddr, AUDIO_REG_I2S_PERIOD, length) ;
}
/*
 * axi memory write; only available in pl330 dma mode
 */
void audio_mem_write(Audio *AudioPtr, u32 data)
{
	Audio_WriteReg(AudioPtr->BaseAddr, AUDIO_REG_I2S_TX_FIFO, data) ;
}
/*
 * axi memory read; only available in pl330 dma mode
 */
int audio_mem_read(Audio *AudioPtr)
{
	return Audio_ReadReg(AudioPtr->BaseAddr, AUDIO_REG_I2S_RX_FIFO) ;
}
/*
 * axi memory write, left and right sound track
 * only available in pl330 dma mode
 */
void audio_mem_write_lr(Audio *AudioPtr, u32 *writebuf)
{
	audio_mem_write(AudioPtr, writebuf[0]) ;
	audio_mem_write(AudioPtr, writebuf[1]) ;
}
/*
 * axi memory read, left and right sound track
 * only available in pl330 dma mode
 */
void audio_mem_read_lr(Audio *AudioPtr, u32 *readbuf)
{
	readbuf[0] = audio_mem_read(AudioPtr) ;
	readbuf[1] = audio_mem_read(AudioPtr) ;
}
/*
 * Inital audio register and setting I2S to 48KHz
 */
int audio_init(Audio *AudioPtr, XIicPs *IicInstance)
{
	AudioPtr->BaseAddr = XPAR_AXI_I2S_ADI_0_BASEADDR ;
	AudioPtr->IicDevAddr = WM8731_DEVADDR ;
	/* Initial audio registers */
	audio_reg_init(IicInstance, AudioPtr, wm8731_init_data);
	/* MCLK:12.288MHz£¬256fs£¬ setting to 48KHz */
	Audio_WriteReg(AudioPtr->BaseAddr, AUDIO_REG_I2S_CLK_CTRL, (64/2 - 1)<<16 | (4/2 - 1)) ;/* LRCLK = BCLK / 64 and BCLK = MCLK / 4. */

	return XST_SUCCESS ;
}

