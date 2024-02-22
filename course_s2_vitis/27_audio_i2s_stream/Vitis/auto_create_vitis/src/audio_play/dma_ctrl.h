/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "math.h"
#include "xscugic.h"
#include "xaxidma.h"
#include "sleep.h"
#include "audio.h"

/*
 *DMA redefines
 */
#define MAX_DMA_LEN		   0x800000      /* DMA max length in byte */
#define DMA_DEV_ID		   XPAR_AXIDMA_0_DEVICE_ID
#define S2MM_INTR_ID       XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR
#define MM2S_INTR_ID       XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR

/*
 * GPIO defines
 */
#define KEY            54
#define RECORD_LED     56
#define PLAY_LED       55
#define LED_ON		   0x0
#define LED_OFF		   0x1
/*
 *DMA BD defines
 */
#define BD_COUNT         16

/*
 *Function defines
 */
int XAxiDma_Audio_Play(XScuGic *InstancePtr, Audio *AudioInstance, u32 length, u32 *Databuf) ;


