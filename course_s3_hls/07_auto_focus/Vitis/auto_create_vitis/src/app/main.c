#include <stdio.h>
#include <unistd.h>
#include "platform.h"
#include "xil_printf.h"
#include "vtc_control.h"
#include "xclk_control.h"
#include "xmem2stream.h"
#include "xstream2mem.h"
#include "xsobel_focus.h"
#include "xil_cache.h"

const char *showStr = "�۽�����demo";

unsigned int frameA[1920*1080*3/4];
unsigned int frameB[1920*1080*3/4];
unsigned int frameC[1920*1080*3/4];
unsigned int overlayDomain[1920*1080];

XMem2stream mem2streamInstance;
XStream2mem stream2memInstance;
XSobel_focus sobel_focusInstance;


void ov5640_init(void);
void ov5640_resize(int w, int h);
int setIcon_alinx(unsigned int *region, int w, char isClear);
int uArgbPrintf(const char *str, unsigned int *region, int w, unsigned int a, unsigned int b);

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
	if (XSobel_focus_Initialize(&sobel_focusInstance, XPAR_SOBEL_FOCUS_0_DEVICE_ID) != XST_SUCCESS)
	{
		printf("XSobel_focus_Initialize fail\n");
		return -1;
	}

	XMem2stream_Write_baseAddr_Words(&mem2streamInstance, 0, (int *)ptr, 3);
	XStream2mem_Write_baseAddr_Words(&stream2memInstance, 0, (int *)ptr, 3);

	XMem2stream_EnableAutoRestart(&mem2streamInstance);
	XMem2stream_Start(&mem2streamInstance);

	pVtcVideo = look_vtc_video("1920x1080@60Hz");
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
	//������ʾ����
	memset(overlayDomain, 0, sizeof(overlayDomain));
	//����alinx logo
	setIcon_alinx(overlayDomain, pVtcVideo->width, 0);
	//��ʾ����
	uArgbPrintf(showStr, overlayDomain+pVtcVideo->width*20+(pVtcVideo->width-32*6)/2, pVtcVideo->width, 0xff000000, 0x50ffffff);
	uArgbPrintf("˵�����ֶ�������߾�ͷ���㣬�ɿ�����ǰ�����½�������������ֵ��ֵԽ��Խ����", overlayDomain+pVtcVideo->width*100+64, pVtcVideo->width, 0xffffff00, 0x00000000);
	//����
	int posx = (pVtcVideo->width-32*8)/2;
	for(int i=0;i<340;i++)
	{
		overlayDomain[pVtcVideo->width*190+posx-20+i] = 0xffffff00;
		overlayDomain[pVtcVideo->width*290+posx-20+i] = 0xffffff00;
	}
	for(int i=0;i<100;i++)
	{
		overlayDomain[pVtcVideo->width*(190+i)+posx-20] = 0xffffff00;
		overlayDomain[pVtcVideo->width*(190+i)+posx-20+340] = 0xffffff00;
	}
	Xil_DCacheFlushRange((INTPTR)overlayDomain, sizeof(overlayDomain));
	u32 max = 0;
	char valueBuff[30];
	u32 cotdly = 0;
	//��ȡֵ����ʾ
	while(1)
	{
		u32 curr = XSobel_focus_Get_average(&sobel_focusInstance);
		sprintf(valueBuff, "��ǰֵ:%010u", (unsigned int)curr);
		uArgbPrintf(valueBuff, overlayDomain+pVtcVideo->width*200+posx, pVtcVideo->width, 0xff00ffff, 0x00000000);
		if(max < curr)
		{
			if(cotdly < 20)
			{
				cotdly++;
			}
			else
			{
				max = curr;
			}
		}
		sprintf(valueBuff, "���ֵ:%010u", (unsigned int)max);
		uArgbPrintf(valueBuff, overlayDomain+pVtcVideo->width*240+posx, pVtcVideo->width, 0xff00ffff, 0x00000000);
		Xil_DCacheFlushRange((INTPTR)overlayDomain, sizeof(overlayDomain));
		usleep(100000);
	}
	cleanup_platform();
	return 0;
}
