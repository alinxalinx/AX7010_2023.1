/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "xaxidma.h"
#include "xparameters.h"
/*
 * BD definitions
 */
#define BD_ALIGNMENT     0x40
#define TXPATH           1
#define RXPATH           0

/*
 * Functions declaration
 */
int CreateBdChain(u32 *BdDesptr, u16 BdCount, u32 TotalByteLen, u8 *DmaBufferPtr, u32 Direction) ;
int Bd_Start(u32 *BdDesptr, u16 BdCount, XAxiDma *XAxiDmaPtr, u32 Direction) ;
void Bd_StatusClr(u32 *BdDesptr, u16 BdCount) ;


