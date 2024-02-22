#ifndef VTC_CONTROL_H
#define VTC_CONTROL_H

typedef struct
{
	char	label[64];	/*Label describing the resolution */
	u32 	width; 		/*Width of the active video frame*/
	u32 	height; 	/*Height of the active video frame*/
	u32 	hps; 		/*Start time of Horizontal sync pulse, in pixel clocks (active width + H. front porch)*/
	u32 	hpe; 		/*End time of Horizontal sync pulse, in pixel clocks (active width + H. front porch + H. sync width)*/
	u32 	hmax; 		/*Total number of pixel clocks per line (active width + H. front porch + H. sync width + H. back porch) */
	u32 	hpol; 		/*hsync pulse polarity*/
	u32 	vps; 		/*Start time of Vertical sync pulse, in lines (active height + V. front porch)*/
	u32 	vpe; 		/*End time of Vertical sync pulse, in lines (active height + V. front porch + V. sync width)*/
	u32 	vmax; 		/*Total number of lines per frame (active height + V. front porch + V. sync width + V. back porch) */
	u32 	vpol; 		/*vsync pulse polarity*/
	double 	freq; 		/*Pixel Clock frequency*/
}vtc_video_t;

const vtc_video_t *look_vtc_video(const char *name);
void video_tc_set(const vtc_video_t *pVMode);

#endif
