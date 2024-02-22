#include <stdio.h>
#include <unistd.h>
#include "platform.h"
#include "xil_printf.h"
#include "vtc_control.h"
#include "xclk_control.h"
#include "xmem2stream.h"
#include "xstream2mem.h"
#include "xdetectcorner.h"
#include "xil_cache.h"

const char *videoMode[] = {"1920x1080@60Hz", "1280x720@60Hz", "800x600@60Hz"};

unsigned int frameA[1920*1080*3/4];
unsigned int frameB[1920*1080*3/4];
unsigned int frameC[1920*1080*3/4];

XMem2stream mem2streamInstance;
XStream2mem stream2memInstance;
XDetectcorner detectcornerA;

void ov5640_init(void);
void ov5640_resize(int w, int h);

int main()
{
	const vtc_video_t *pVtcVideo;

	init_platform();

	ov5640_init();

	unsigned int ptr[3] = {(unsigned int)frameA, (unsigned int)frameB, (unsigned int)frameC};

	if (XMem2stream_Initialize(&mem2streamInstance, XPAR_MEM2STREAM_0_DEVICE_ID) != XST_SUCCESS)
	{
		printf("XMem2stream_Initialize fail\n");
		return -1;
	}
	if (XStream2mem_Initialize(&stream2memInstance, XPAR_STREAM2MEM_0_DEVICE_ID) != XST_SUCCESS)
	{
		printf("XStream2mem_Initialize fail\n");
		return -1;
	}
	if (XDetectcorner_Initialize(&detectcornerA, XPAR_DETECTCORNER_0_DEVICE_ID) != XST_SUCCESS)
	{
		printf("XDetectCorner_Initialize 0 fail\n");
		return -1;
	}
	XMem2stream_Write_baseAddr_Words(&mem2streamInstance, 0, (int *)ptr, 3);
	XStream2mem_Write_baseAddr_Words(&stream2memInstance, 0, (int *)ptr, 3);

	XDetectcorner_Set_threshold(&detectcornerA, 5);
	XMem2stream_EnableAutoRestart(&mem2streamInstance);
	XMem2stream_Start(&mem2streamInstance);

	pVtcVideo = look_vtc_video(videoMode[0]);
	if(pVtcVideo)
	{
		set_xclk_wiz(100, pVtcVideo->freq);
		video_tc_set(pVtcVideo);
		ov5640_resize(pVtcVideo->width, pVtcVideo->height);
		//��������
		XStream2mem_Set_cols(&stream2memInstance, pVtcVideo->width);
		XStream2mem_Set_rows(&stream2memInstance, pVtcVideo->height);
		//�������
		XMem2stream_Set_cols(&mem2streamInstance, pVtcVideo->width);
		XMem2stream_Set_rows(&mem2streamInstance, pVtcVideo->height);
	}
	while(1);
	cleanup_platform();
	return 0;
}
