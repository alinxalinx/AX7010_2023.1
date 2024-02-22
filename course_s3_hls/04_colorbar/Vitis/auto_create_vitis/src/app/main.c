#include <stdio.h>
#include <unistd.h>
#include "platform.h"
#include "xil_printf.h"
#include "vtc_control.h"
#include "xclk_control.h"
#include "xcolorbar.h"

const char *videoMode[] = {"1920x1080@60Hz", "1280x720@60Hz", "800x600@60Hz"};

int main()
{
	XColorbar colorbarInstance;
	const vtc_video_t *pVtcVideo;

	init_platform();

	if(XColorbar_Initialize(&colorbarInstance, XPAR_XCOLORBAR_0_DEVICE_ID) != XST_SUCCESS)
	{
		printf("XColorbar_Initialize fail\n");
		return -1;
	}
	while(1)
	{
		for(int i=0; i<(int)sizeof(videoMode)/sizeof(const char *);i++)
		{
			pVtcVideo = look_vtc_video(videoMode[i]);
			if(pVtcVideo)
			{
				set_xclk_wiz(100, pVtcVideo->freq);
				video_tc_set(pVtcVideo);

				XColorbar_Set_cols(&colorbarInstance, pVtcVideo->width);
				XColorbar_Set_rows(&colorbarInstance, pVtcVideo->height);
				printf("set video %s\r\n", videoMode[i]);
			}
			sleep(20);
		}
	}
	cleanup_platform();
	return 0;
}
