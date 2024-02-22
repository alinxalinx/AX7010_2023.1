/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */
#include "display_demo.h"
#include "display_ctrl/display_ctrl.h"
#include <stdio.h>
#include "math.h"
#include <ctype.h>
#include <stdlib.h>
#include "xil_types.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "ugui.h"
#include "touch/touch.h"
#include "xscutimer.h"
#include "ax_pwm.h"
#include "zynq_interrupt.h"
#include "xtime_l.h"
/*
 * XPAR redefines
 */
#define DYNCLK_BASEADDR XPAR_AXI_DYNCLK_0_BASEADDR
#define VGA_VDMA_ID XPAR_AXIVDMA_0_DEVICE_ID
#define DISP_VTC_ID XPAR_VTC_0_DEVICE_ID


/* ------------------------------------------------------------ */
/*				Global Variables								*/
/* ------------------------------------------------------------ */

/*
 * Display Driver structs
 */
DisplayCtrl dispCtrl;
XAxiVdma vdma;
XIicPs ps_i2c0;
XScuGic XScuGicInstance;

/*
 * Framebuffers for video data
 */
u8 frameBuf[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME];
u8 *pFrames[DISPLAY_NUM_FRAMES]; //array of pointers to the frame buffers
u8 *cpFrames;
XScuTimer Timer;//timer
UG_GUI gui ; // Global GUI structure
/* ------------------------------------------------------------ */
/*				Procedure Definitions							*/
/* ------------------------------------------------------------ */

extern u8 ReadBuffer[50];
int touched_x1;
int touched_y1;
extern u16 current_x1;
extern u16 current_y1;
extern u16 last_x1;
extern u16 last_y1;

XTime TimerCurr, TimerLast;

/* Window 1 */
#define MAX_OBJECTS        10
UG_WINDOW window_1;
UG_OBJECT obj_buff_wnd_1[MAX_OBJECTS];
UG_BUTTON button1_1;
UG_BUTTON button1_2;
UG_BUTTON button1_3;
UG_BUTTON button1_4;
UG_BUTTON button1_5;
UG_BUTTON button1_6;

u8 str[128];
float duty;
/* Callback function for the main menu */
void window_1_callback( UG_MESSAGE* msg )
{
	if ( msg->type == MSG_TYPE_OBJECT )
	{
		if ( msg->id == OBJ_TYPE_BUTTON )
		{
			switch( msg->sub_id )
			{
			case BTN_ID_0: /* Toggle green LED */
			{
				static int i;
				i++;
				sprintf(str,"GR%d\nLED",i);
				UG_ButtonSetText( &window_1, BTN_ID_0, str );
				break;
			}
			case BTN_ID_1: /* Toggle red LED */
			{
				break;
			}
			case BTN_ID_2: /* Show µGUI info */
			{
				break;
			}
			case BTN_ID_3: /* pwm + */
			{
				if(duty + 0.05 <= 0.85)
				{
					duty = duty + 0.05;
					set_pwm_duty(XPAR_AX_PWM_0_S00_AXI_BASEADDR,duty);
				}
				break;
			}
			case BTN_ID_4: /*pwm - */
			{
				if(duty - 0.05 >= 0.0)
				{
					duty = duty - 0.05;
					set_pwm_duty(XPAR_AX_PWM_0_S00_AXI_BASEADDR,duty);
				}
				break;
			}
			case BTN_ID_5: /* Resize window */
			{
				static UG_U32 tog;

				if ( !tog )
				{
					UG_WindowResize( &window_1, 0, 40, 799-200, 479-40 );
				}
				else
				{
					UG_WindowResize( &window_1, 0, 0, 799, 479 );
				}
				tog = ! tog;
				break;
			}

			}
		}
	}
}


void PixelSet(UG_S16 x , UG_S16 y ,UG_COLOR c)
{
	u32 iPixelAddr;
	iPixelAddr = (y * 800 + x) * 3;
	cpFrames[iPixelAddr] = c;
	cpFrames[iPixelAddr + 1] = c>>8;
	cpFrames[iPixelAddr + 2] = c>>16;
}
static void Timer_Handler(void *CallBackRef)

{
	XScuTimer *TimerInstancePtr = (XScuTimer *) CallBackRef;
	XScuTimer_ClearInterruptStatus(TimerInstancePtr);
	XScuTimer_DisableInterrupt(TimerInstancePtr);

	if (touch_sig > 0)
	{
		touch_sig=0;
		UG_TouchUpdate(current_x1,current_y1,TOUCH_STATE_PRESSED);

	}
	else if (touch_sig < 0)
	{
		touch_sig = 0 ;
		UG_TouchUpdate(-1,-1,TOUCH_STATE_RELEASED);
	}

	UG_Update();
	Xil_DCacheFlushRange((unsigned int) dispCtrl.framePtr[dispCtrl.curFrame], DEMO_MAX_FRAME);
	XScuTimer_EnableInterrupt(TimerInstancePtr);
}
int main(void)
{

	int Status;
	XAxiVdma_Config *vdmaConfig;
	int i;
	/*
	 * Initialize an array of pointers to the 3 frame buffers
	 */
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = frameBuf[i];
	}
	set_pwm_frequency(XPAR_AX_PWM_0_S00_AXI_BASEADDR,100000000,200);
	duty = 0.5;
	set_pwm_duty(XPAR_AX_PWM_0_S00_AXI_BASEADDR,duty);
	InterruptInit(XPAR_XSCUTIMER_0_DEVICE_ID,&XScuGicInstance);
	i2c_init(&ps_i2c0, XPAR_XIICPS_0_DEVICE_ID,200000);
	touch_init(&ps_i2c0,&XScuGicInstance,63);
	PS_timer_init(&Timer, XPAR_XSCUTIMER_0_DEVICE_ID ,XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ/200 - 1);
	InterruptConnect(&XScuGicInstance,XPAR_SCUTIMER_INTR,Timer_Handler,(void *)&Timer);
	XScuTimer_EnableInterrupt(&Timer);
	/*
	 * Initialize VDMA driver
	 */
	vdmaConfig = XAxiVdma_LookupConfig(VGA_VDMA_ID);
	if (!vdmaConfig)
	{
		xil_printf("No video DMA found for ID %d\r\n", VGA_VDMA_ID);

	}
	Status = XAxiVdma_CfgInitialize(&vdma, vdmaConfig, vdmaConfig->BaseAddress);
	if (Status != XST_SUCCESS)
	{
		xil_printf("VDMA Configuration Initialization failed %d\r\n", Status);

	}

	/*
	 * Initialize the Display controller and start it
	 */
	Status = DisplayInitialize(&dispCtrl, &vdma, DISP_VTC_ID, DYNCLK_BASEADDR, pFrames, DEMO_STRIDE);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Display Ctrl initialization failed during demo initialization%d\r\n", Status);

	}
	Status = DisplayStart(&dispCtrl);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Couldn't start display during demo initialization%d\r\n", Status);

	}

	cpFrames =(u8 *)dispCtrl.framePtr[dispCtrl.curFrame];
	UG_Init(&gui , PixelSet, 800 , 480);
	UG_FillScreen ( 0xFF0000 );
	UG_DrawCircle(100 , 100 , 30 , C_WHITE) ;
	Xil_DCacheFlushRange((unsigned int) dispCtrl.framePtr[dispCtrl.curFrame], DEMO_MAX_FRAME);
	/* Create Window 1 */
	UG_WindowCreate( &window_1, obj_buff_wnd_1, MAX_OBJECTS, window_1_callback );
	UG_WindowSetTitleText( &window_1, "µGUI For ALINX!" );
	UG_WindowSetTitleTextFont( &window_1, &FONT_12X20 );

	/* Create some Buttons */
	UG_ButtonCreate( &window_1, &button1_1, BTN_ID_0, 10, 10, 110, 60 );
	UG_ButtonCreate( &window_1, &button1_2, BTN_ID_1, 10, 80, 110, 130 );
	UG_ButtonCreate( &window_1, &button1_3, BTN_ID_2, 10, 150, 110,200 );
	UG_ButtonCreate( &window_1, &button1_4, BTN_ID_3, 120, 10, 360 , 60 );
	UG_ButtonCreate( &window_1, &button1_5, BTN_ID_4, 120, 80, 360, 130 );
	UG_ButtonCreate( &window_1, &button1_6, BTN_ID_5, 120, 150,360, 200 );

	/* Configure Button 1 */
	UG_ButtonSetFont( &window_1, BTN_ID_0, &FONT_12X20 );
	UG_ButtonSetBackColor( &window_1, BTN_ID_0, C_LIME );
	UG_ButtonSetText( &window_1, BTN_ID_0, "Green\nLED" );
	/* Configure Button 2 */
	UG_ButtonSetFont( &window_1, BTN_ID_1, &FONT_12X20 );
	UG_ButtonSetBackColor( &window_1, BTN_ID_1, C_RED );
	UG_ButtonSetText( &window_1, BTN_ID_1, "Red\nLED" );
	/* Configure Button 3 */
	UG_ButtonSetFont( &window_1, BTN_ID_2, &FONT_12X20 );
	UG_ButtonSetText( &window_1, BTN_ID_2, "About\nµGUI" );
	UG_WindowShow( &window_1 );
	/* Configure Button 4 */
	UG_ButtonSetFont( &window_1, BTN_ID_3, &FONT_12X20 );
	UG_ButtonSetForeColor( &window_1, BTN_ID_3, C_RED );
	UG_ButtonSetText( &window_1, BTN_ID_3, "LCD brightness\n - " );
	/* Configure Button 5 */
	UG_ButtonSetFont( &window_1, BTN_ID_4, &FONT_8X14 );
	UG_ButtonSetText( &window_1, BTN_ID_4, "LCD brightness\n + " );
	/* Configure Button 6 */
	UG_ButtonSetFont( &window_1, BTN_ID_5, &FONT_10X16 );
	UG_ButtonSetText( &window_1, BTN_ID_5, "Resize\nWindow" );

	UG_WindowShow( &window_1 );
	UG_WaitForUpdate();

	while(1){
	}

	return 0;
}



