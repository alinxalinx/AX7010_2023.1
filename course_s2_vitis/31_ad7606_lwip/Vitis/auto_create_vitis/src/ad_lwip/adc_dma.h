/*
 * adc_dma.h
 *
 *  Created on: 2018Äê8ÔÂ14ÈÕ
 *      Author: Administrator
 */

#ifndef SRC_ADC_DMA_H_
#define SRC_ADC_DMA_H_

#include "ad7606_sample.h"

/*
 *DMA redefines
 */
#define MAX_DMA_LEN		   0x800000      /* DMA max length in byte */
#define DMA_DEV_ID		   XPAR_AXIDMA_0_DEVICE_ID
#define S2MM_INTR_ID       XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR

/*
 *ADC defines
 */
#define AD7606_BASE        XPAR_AD7606_SAMPLE_0_S00_AXI_BASEADDR
#define AD7606_START       AD7606_SAMPLE_S00_AXI_SLV_REG0_OFFSET
#define AD7606_LENGTH      AD7606_SAMPLE_S00_AXI_SLV_REG1_OFFSET

#define ADC_BYTE           2              /* ADC data byte number */
#define ADC_BITS           16
#define ADC_CH_COUNT       8


/*
 *DMA BD defines
 */
#define BD_COUNT         4


#define ADC_SAMPLE_NUM  (1024*32)

#endif /* SRC_ADC_DMA_H_ */
