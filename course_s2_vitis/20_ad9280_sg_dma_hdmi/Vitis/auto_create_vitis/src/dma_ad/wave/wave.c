/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */
#include "wave.h"
#include "math.h"
/*
 *  Canvas description
 *
 *				|
 * 				|
 *			---------------------------------------------------->  hor_x
 *				|	   							           |
 *				|                                          |
 *              |               width                      |
 *              |      --------------------------          |
 *              |      |                        |          |
 *              |      |                        |          |
 *              |      |                        |          |
 *              |      |         Canvas         | height   |
 *              |      |                        |          |
 *              |      |                        |          |
 *              |      |                        |          |
 *              |      --------------------------          |
 *              |                                          |
 *              |                              frame       |
 *				--------------------------------------------
 *				|
 *				ver_y
 */


/*
 * Draw wave on canvas
 *
 *@param BufferPtr        data buffer for drawing wave
 *@param CanvasBufferPtr  this is CanvasBuffer pointer, draw wave on CanvasBuffer
 *@param Sign             data sign: unsigned char 0; char 1; unsigned short 2 ;short 3
 *@param Bits             data valid bits
 *@param color            color select for wave
 *@param coe              coefficient
 *
 *@note  this function draw line between two point through checking last data and current data value,
 *		 convert data to u8 by adder and coe
 */
void draw_wave(u32 width, u32 height,  void *BufferPtr, u8 *CanvasBufferPtr, u8 Sign, u8 Bits, u8 color, u16 coe)
{

	u8 last_data ;
	u8 curr_data ;
	u32 i,j ;
	u8 wRed, wBlue, wGreen;
	u16 adder ;

	char *CharBufferPtr ;
	short *ShortBufferPtr ;

	if(Sign == UNSIGNEDCHAR || Sign == CHAR)
		CharBufferPtr = (char *)BufferPtr ;
	else
		ShortBufferPtr = (short *)BufferPtr ;



	float data_coe = 1.00/coe ;

	switch(color)
	{
	case 0 : wRed = 255; wGreen = 255;	wBlue = 0;	    break ;     //YELLOW color
	case 1 : wRed = 0;   wGreen = 255;	wBlue = 255;	break ;     //CYAN color
	case 2 : wRed = 0;   wGreen = 255;	wBlue = 0;	    break ;     //GREEN color
	case 3 : wRed = 255; wGreen = 0;	wBlue = 255;	break ;     //MAGENTA color
	case 4 : wRed = 255; wGreen = 0;	wBlue = 0;	    break ;     //RED color
	case 5 : wRed = 0;   wGreen = 0;	wBlue = 255;	break ;     //BLUE color
	case 6 : wRed = 255; wGreen = 255;	wBlue = 255 ;	break ;     //WRITE color
	case 7 : wRed = 150; wGreen = 150;	wBlue = 0;	    break ;     //DARK_YELLOW color
	default: wRed = 255; wGreen = 255;  wBlue = 0;	    break ;
	}
	/* if sign is singed, adder will be 1/2 of 2^Bits, for example, Bits equals to 8, adder will be 2^8/2 = 128 */
	if (Sign == CHAR || Sign == SHORT)
		adder = pow(2, Bits)/2 ;
	else
		adder = 0 ;

	for(i = 0; i < width ; i++)
	{
		/* Convert char data to u8 */
		if (i == 0)
		{
			if(Sign == UNSIGNEDCHAR || Sign == CHAR)
			{
				last_data = (u8)(CharBufferPtr[i] + adder)*data_coe ;
				curr_data = (u8)(CharBufferPtr[i] + adder)*data_coe ;
			}
			else
			{
				last_data = (u8)((u16)(ShortBufferPtr[i] + adder)*data_coe) ;
				curr_data = (u8)((u16)(ShortBufferPtr[i] + adder)*data_coe) ;
			}
		}
		else
		{
			if(Sign == UNSIGNEDCHAR || Sign == CHAR)
			{
				last_data = (u8)(CharBufferPtr[i-1] + adder)*data_coe ;
				curr_data = (u8)(CharBufferPtr[i] + adder)*data_coe ;
			}
			else
			{
				last_data = (u8)((u16)(ShortBufferPtr[i-1] + adder)*data_coe) ;
				curr_data = (u8)((u16)(ShortBufferPtr[i] + adder)*data_coe) ;
			}
		}
		/* Compare last data value and current data value, draw point between two point */
		if (curr_data >= last_data)
		{
			for (j = 0 ; j < (curr_data - last_data + 1) ; j++)
				draw_point(CanvasBufferPtr, i, (height - 1 - curr_data) + j, width, wBlue, wGreen, wRed) ;
		}
		else
		{
			for (j = 0 ; j < (last_data - curr_data + 1) ; j++)
				draw_point(CanvasBufferPtr, i, (height - 1 - last_data) + j, width, wBlue, wGreen, wRed) ;
		}
	}

}


/*
 * Draw point on point buffer
 *
 *@param PointBufferPtr     point buffer pointer
 *@param hor_x  			horizontal position
 *@param ver_y              vertical position
 *@param width              canvas width
 *
 *@note  none
 */
void draw_point(u8 *PointBufferPtr, u32 hor_x, u32 ver_y, u32 width, u8 wBlue, u8 wGreen, u8 wRed)
{
	PointBufferPtr[(hor_x + ver_y*width)*BYTES_PIXEL + 0] = wBlue;
	PointBufferPtr[(hor_x + ver_y*width)*BYTES_PIXEL + 1] = wGreen;
	PointBufferPtr[(hor_x + ver_y*width)*BYTES_PIXEL + 2] = wRed;
}


/*
 * Draw grid on point buffer
 *
 *@param width              canvas width
 *@param height             canvas height
 *@param CanvasBufferPtr    canvas buffer pointer
 *
 *@note  in horizontal direction, every 32 vertical lines, draw one point in every 4 point
 *       in vertical direction, every 32 horizontal points, draw one point in every 4 point
 */
void draw_grid(u32 width, u32 height, u8 *CanvasBufferPtr)
{

	u32 xcoi, ycoi;
	u8 wRed, wBlue, wGreen;
	/*
	 * overlay grid on canvas, background set to black color, grid color is gray.
	 */
	for(ycoi = 0; ycoi < height; ycoi++)
	{
		for(xcoi = 0; xcoi < width; xcoi++)
		{

			if (((ycoi == 0 || (ycoi+1)%32 == 0) && (xcoi == 0 || (xcoi+1)%4 == 0))
					|| ((xcoi == 0 || (xcoi+1)%32 == 0) && (ycoi+1)%4 == 0))
			{
				/* gray */
				wRed = 150;
				wGreen = 150;
				wBlue = 150;
			}
			else
			{
				/* Black */
				wRed = 0;
				wGreen = 0;
				wBlue = 0;
			}
			draw_point(CanvasBufferPtr, xcoi, ycoi, width, wBlue, wGreen, wRed);
		}
	}
}

