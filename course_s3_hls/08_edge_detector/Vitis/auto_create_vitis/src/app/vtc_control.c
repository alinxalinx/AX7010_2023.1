#include <stdio.h>
#include <string.h>
#include <xvtc.h>
#include "vtc_control.h"

const vtc_video_t vtc_video_table[] = {
		{
				.label 	= "640x480@60Hz",
				.width 	= 640,
				.height = 480,
				.hps 	= 656,
				.hpe 	= 752,
				.hmax 	= 799,
				.hpol 	= 0,
				.vps 	= 490,
				.vpe 	= 492,
				.vmax 	= 524,
				.vpol 	= 0,
				.freq 	= 25.0
		},
		{
				.label 	= "800x600@60Hz",
				.width 	= 800,
				.height = 600,
				.hps 	= 840,
				.hpe 	= 968,
				.hmax 	= 1055,
				.hpol 	= 1,
				.vps 	= 601,
				.vpe 	= 605,
				.vmax 	= 627,
				.vpol 	= 1,
				.freq 	= 40.0
		},
		{
				.label 	= "1280x1024@60Hz",
				.width 	= 1280,
				.height = 1024,
				.hps 	= 1328,
				.hpe 	= 1440,
				.hmax 	= 1687,
				.hpol 	= 1,
				.vps 	= 1025,
				.vpe 	= 1028,
				.vmax 	= 1065,
				.vpol 	= 1,
				.freq 	= 108.0
		},
		{
				.label 	= "1280x720@60Hz",
				.width 	= 1280,
				.height = 720,
				.hps 	= 1390,
				.hpe 	= 1430,
				.hmax 	= 1649,
				.hpol 	= 1,
				.vps 	= 725,
				.vpe 	= 730,
				.vmax 	= 749,
				.vpol 	= 1,
				.freq 	= 74.25, //74.2424 is close enough
		},
		{
				.label 	= "1920x1080@60Hz",
				.width 	= 1920,
				.height = 1080,
				.hps 	= 2008,
				.hpe 	= 2052,
				.hmax 	= 2199,
				.hpol 	= 1,
				.vps 	= 1084,
				.vpe 	= 1089,
				.vmax 	= 1124,
				.vpol 	= 1,
				.freq 	= 148.5 //148.57 is close enough
		}
};

const vtc_video_t *look_vtc_video(const char *name)
{
	for(int i=0;i<(sizeof(vtc_video_table)/sizeof(vtc_video_t));i++)
	{
		if(strcmp(name, vtc_video_table[i].label) == 0)
		{
			return &vtc_video_table[i];
		}
	}
	return NULL;
}

void video_tc_set(const vtc_video_t *pVMode)
{
	int Status;
	XVtc 				vtc;
	XVtc_Config 		*vtcConfig;
	XVtc_Timing 		vtcTiming;
	XVtc_SourceSelect 	SourceSelect;

	vtcConfig = XVtc_LookupConfig(XPAR_VTC_0_DEVICE_ID);
	if (NULL == vtcConfig)
	{
		printf("vtc init fail 1\n");
		return;
	}

	Status = XVtc_CfgInitialize(&vtc, vtcConfig, vtcConfig->BaseAddress);
	/* Checking status */
	if (Status != (XST_SUCCESS))
	{
		printf("vtc init fail 2\n");
		return;
	}

	/*
	 * Configure the vtc core with the display mode timing parameters
	 */
	vtcTiming.HActiveVideo 	= pVMode->width;					/**< Horizontal Active Video Size */
	vtcTiming.HFrontPorch 	= pVMode->hps - pVMode->width;		/**< Horizontal Front Porch Size */
	vtcTiming.HSyncWidth 	= pVMode->hpe - pVMode->hps;		/**< Horizontal Sync Width */
	vtcTiming.HBackPorch 	= pVMode->hmax - pVMode->hpe + 1;	/**< Horizontal Back Porch Size */
	vtcTiming.HSyncPolarity = pVMode->hpol;						/**< Horizontal Sync Polarity */
	vtcTiming.VActiveVideo 	= pVMode->height;					/**< Vertical Active Video Size */
	vtcTiming.V0FrontPorch 	= pVMode->vps - pVMode->height;		/**< Vertical Front Porch Size */
	vtcTiming.V0SyncWidth 	= pVMode->vpe - pVMode->vps;		/**< Vertical Sync Width */
	vtcTiming.V0BackPorch 	= pVMode->vmax - pVMode->vpe + 1;;	/**< Horizontal Back Porch Size */
	vtcTiming.V1FrontPorch 	= pVMode->vps - pVMode->height;		/**< Vertical Front Porch Size */
	vtcTiming.V1SyncWidth 	= pVMode->vpe - pVMode->vps;		/**< Vertical Sync Width */
	vtcTiming.V1BackPorch 	= pVMode->vmax - pVMode->vpe + 1;;	/**< Horizontal Back Porch Size */
	vtcTiming.VSyncPolarity = pVMode->vpol;						/**< Vertical Sync Polarity */
	vtcTiming.Interlaced = 0;									/**< Interlaced / Progressive video */


	/* Setup the VTC Source Select config structure. */
	/* 1=Generator registers are source */
	/* 0=Detector registers are source */
	memset((void *)&SourceSelect, 0, sizeof(SourceSelect));
	SourceSelect.VBlankPolSrc = 1;
	SourceSelect.VSyncPolSrc = 1;
	SourceSelect.HBlankPolSrc = 1;
	SourceSelect.HSyncPolSrc = 1;
	SourceSelect.ActiveVideoPolSrc = 1;
	SourceSelect.ActiveChromaPolSrc= 1;
	SourceSelect.VChromaSrc = 1;
	SourceSelect.VActiveSrc = 1;
	SourceSelect.VBackPorchSrc = 1;
	SourceSelect.VSyncSrc = 1;
	SourceSelect.VFrontPorchSrc = 1;
	SourceSelect.VTotalSrc = 1;
	SourceSelect.HActiveSrc = 1;
	SourceSelect.HBackPorchSrc = 1;
	SourceSelect.HSyncSrc = 1;
	SourceSelect.HFrontPorchSrc = 1;
	SourceSelect.HTotalSrc = 1;

	XVtc_SelfTest(&vtc);
	XVtc_RegUpdateEnable(&vtc);
	XVtc_SetGeneratorTiming(&vtc, &vtcTiming);
	XVtc_SetSource(&vtc, &SourceSelect);
	/*
	 * Enable VTC core, releasing backpressure on VDMA
	 */
	XVtc_EnableGenerator(&vtc);
}



