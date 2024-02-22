/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "math.h"
#include "xscugic.h"
#include "ad9280_sample.h"
#include "xaxidma.h"
#include "sleep.h"

/*
 *DMA redefines
 */
#define MAX_DMA_LEN		   0x800000      /* DMA max length in byte */
#define DMA_DEV_ID		   XPAR_AXIDMA_0_DEVICE_ID
#define S2MM_INTR_ID       XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR
/*
 *ADC defines
 */
#define AD9280_BASE        XPAR_AD9280_SAMPLE_0_S00_AXI_BASEADDR
#define AD9280_START       AD9280_SAMPLE_S00_AXI_SLV_REG0_OFFSET
#define AD9280_LENGTH      AD9280_SAMPLE_S00_AXI_SLV_REG1_OFFSET
#define ADC_CAPTURELEN     1920           /* ADC capture length */
#define ADC_COE            1              /* ADC coefficient */
#define ADC_BYTE           1              /* ADC data byte number */
#define ADC_BITS           8
/*
 *Wave defines
 */
#define WAVE_LEN            1920*256*3     /* Wave total length in byte */
#define WAVE_START_ROW      50             /* Grid and Wave start row in frame */
#define WAVE_START_COLUMN   0              /* Grid and Wave start column in frame */
#define WAVE_HEIGHT         256   		   /* Grid and Wave height */
/*
 *Function defines
 */
int XAxiDma_Adc_Wave(u32 width, u8 *frame, u32 stride, XScuGic *InstancePtr);


