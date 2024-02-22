/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "xil_types.h"

#define BYTES_PIXEL     3
/*
 * Color definitions
 */
#define YELLOW           0
#define CYAN             1
#define GREEN            2
#define MAGENTA          3
#define RED              4
#define BLUE             5
#define WRITE            6
#define DARK_YELLOW      7

#define UNSIGNEDCHAR     0
#define CHAR             1
#define UNSIGNEDSHORT    2
#define SHORT            3
/*
 * Functions declaration
 */
void draw_grid(u32 width, u32 height, u8 *CanvasBufferPtr) ;
void draw_wave(u32 width, u32 height, void *BufferPtr, u8 *CanvasBufferPtr,  u8 Sign, u8 Bits, u8 color, u16 coe) ;
void draw_point(u8 *PointBufferPtr, u32 hor_x, u32 ver_y, u32 width, u8 wBlue, u8 wGreen, u8 wRed);
