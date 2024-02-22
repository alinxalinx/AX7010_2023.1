/***************************** Include Files *********************************/

#include "qspi.h"
#include "xtime_l.h"
#include "stdio.h"


/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/
void FlashWriteEnable(XQspiPs *QspiPtr);

void FlashWriteDisable(XQspiPs *QspiPtr) ;

void FlashErase(XQspiPs *QspiPtr, u32 Address, u32 ByteCount);

void FlashWrite(XQspiPs *QspiPtr, u32 Address, u32 ByteCount, u8 Command);

void FlashRead(XQspiPs *QspiPtr, u32 Address, u32 ByteCount, u8 Command);

int FlashReadID(void);

void print_percent(int percent) ;

/************************** Variable Definitions *****************************/

/*
 * The instances to support the device drivers are global such that they
 * are initialized to zero each time the program runs. They could be local
 * but should at least be static so they are zeroed.
 */
XQspiPs QspiInstance;

/*
 * The following variables are used to read and write to the flash and they
 * are global to avoid having large buffers on the stack
 */
u8 ReadBuffer[PAGE_SIZE + DATA_OFFSET + DUMMY_SIZE];
u8 WriteBuffer[PAGE_SIZE + DATA_OFFSET];


/*****************************************************************************/
/**
 *
 * The purpose of this function is to illustrate how to use the XQspiPs
 * device driver in polled mode. This function writes and reads data
 * from a serial FLASH.
 *
 * @param	None.
 *
 * @return	XST_SUCCESS if successful, else XST_FAILURE.
 *
 * @note		None.
 *
 *****************************************************************************/
int update_qspi(XQspiPs *QspiInstancePtr, u16 QspiDeviceId, unsigned int TotoalLen, char *FlashDataToSend)
{
	int Status;
	int i ;
	unsigned int HasSendNum = 0 ;
	unsigned int WriteAddr = 0 ;
	unsigned int HasRecvNum = 0 ;
	unsigned int ReadAddr = 0 ;
	XTime TimerStart, TimerEnd;
	float elapsed_time ;

	int PercentCurr = -1 ;
	int PercentLast = -1 ;

	XQspiPs_Config *QspiConfig;

	/*
	 * Initialize the QSPI driver so that it's ready to use
	 */
	QspiConfig = XQspiPs_LookupConfig(QspiDeviceId);
	if (NULL == QspiConfig) {
		return XST_FAILURE;
	}

	Status = XQspiPs_CfgInitialize(QspiInstancePtr, QspiConfig,
			QspiConfig->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Set Manual Start and Manual Chip select options and drive HOLD_B
	 * pin high.
	 */
	XQspiPs_SetOptions(QspiInstancePtr, XQSPIPS_MANUAL_START_OPTION |
			XQSPIPS_FORCE_SSELECT_OPTION |
			XQSPIPS_HOLD_B_DRIVE_OPTION);

	/*
	 * Set the prescaler for QSPI clock
	 */
	XQspiPs_SetClkPrescaler(QspiInstancePtr, XQSPIPS_CLK_PRESCALE_8);

	/*
	 * Assert the FLASH chip select.
	 */
	XQspiPs_SetSlaveSelect(QspiInstancePtr);


	FlashReadID();

	/*
	 * Erase the flash.
	 */
	printf("Performing Erase Operation...\r\n") ;

	XTime_SetTime(0) ;
	XTime_GetTime(&TimerStart) ;
	FlashErase(QspiInstancePtr, 0, TotoalLen);
	XTime_GetTime(&TimerEnd) ;
	printf("100%%\r\n") ;
	elapsed_time = ((float)(TimerEnd-TimerStart))/((float)COUNTS_PER_SECOND) ;
	printf("INFO:Elapsed time = %.2f sec\r\n", elapsed_time) ;
	printf("Erase Operation Successful.\r\n") ;

	/*
	 * Initialize the write buffer for a pattern to write to the FLASH
	 * and the read buffer to zero so it can be verified after the read,
	 * the test value that is added to the unique value allows the value
	 * to be changed in a debug environment to guarantee
	 */



	printf("Performing Program Operation...\r\n") ;
	XTime_SetTime(0) ;
	XTime_GetTime(&TimerStart) ;
	do{
		PercentCurr = (int)(((float)HasSendNum/(float)TotoalLen)*10) ;

		if (PercentCurr != PercentLast)
			print_percent(PercentCurr) ;

		PercentLast = PercentCurr ;

		if ((HasSendNum+PAGE_SIZE) > TotoalLen)
		{
			for (i = 0 ; i < PAGE_SIZE ; i++)
			{
				if (i >= TotoalLen-HasSendNum)
				{
					WriteBuffer[DATA_OFFSET + i] = 0 ;
				}
				else
				{
					WriteBuffer[DATA_OFFSET + i] = (u8)(FlashDataToSend[HasSendNum+i]);
				}
			}
			FlashWrite(QspiInstancePtr, WriteAddr, PAGE_SIZE, WRITE_CMD);
			printf("100%%\r\n") ;
			XTime_GetTime(&TimerEnd) ;
			elapsed_time = (float)(TimerEnd-TimerStart)/(COUNTS_PER_SECOND) ;
			printf("INFO:Elapsed time = %.2f sec\r\n", elapsed_time) ;
			printf("Program Operation Successful.\r\n") ;
			HasSendNum+= PAGE_SIZE ;
		}
		else
		{
			for (i = 0 ; i < PAGE_SIZE ; i++)
			{
				WriteBuffer[DATA_OFFSET + i] = (u8)(FlashDataToSend[HasSendNum+i]);
			}
			FlashWrite(QspiInstancePtr, WriteAddr, PAGE_SIZE, WRITE_CMD);
			HasSendNum+= PAGE_SIZE ;
			WriteAddr+= PAGE_SIZE ;
		}
	}while(HasSendNum < TotoalLen) ;

	HasSendNum = 0 ;
	WriteAddr = 0 ;


	printf("Performing Verify Operation...\r\n") ;
	memset(ReadBuffer, 0x00, sizeof(ReadBuffer));
	XTime_SetTime(0) ;
	XTime_GetTime(&TimerStart) ;
	do{
		PercentCurr = (int)(((float)HasRecvNum/(float)TotoalLen)*10) ;

		if (PercentCurr != PercentLast)
			print_percent(PercentCurr) ;

		PercentLast = PercentCurr ;

		if ((HasRecvNum+PAGE_SIZE) > TotoalLen)
		{
			FlashRead(QspiInstancePtr, ReadAddr, PAGE_SIZE, FAST_READ_CMD);
			for (i = 0 ; i < TotoalLen-HasRecvNum; i++)
			{
				if (ReadBuffer[DATA_OFFSET + DUMMY_SIZE+i] != (u8)(FlashDataToSend[HasRecvNum+i]))
				{
					printf("Verify data error, address is 0x%x\tSend Data is 0x%x\tRead Data is 0x%x\r\n",
							ReadAddr+i+1,FlashDataToSend[HasRecvNum+i], ReadBuffer[DATA_OFFSET + DUMMY_SIZE+i]) ;
					break ;
				}
			}
			HasRecvNum+= PAGE_SIZE ;
			printf("100%%\r\n") ;
			XTime_GetTime(&TimerEnd) ;
			elapsed_time = (float)(TimerEnd-TimerStart)/(COUNTS_PER_SECOND) ;
			printf("INFO:Elapsed time = %.2f sec\r\n", elapsed_time) ;
			printf("Verify Operation Successful.\r\n") ;
		}
		else
		{
			FlashRead(QspiInstancePtr, ReadAddr, PAGE_SIZE, FAST_READ_CMD);
			for (i = 0 ; i < PAGE_SIZE ; i++)
			{
				if (ReadBuffer[DATA_OFFSET + DUMMY_SIZE+i] != (u8)(FlashDataToSend[HasRecvNum+i]))
				{
					printf("Verify data error, address is 0x%x\tSend Data is 0x%x\tRead Data is 0x%x\r\n",
							ReadAddr+i+1,FlashDataToSend[HasRecvNum+i], ReadBuffer[DATA_OFFSET + DUMMY_SIZE+i]) ;
					break ;
				}
			}
			HasRecvNum+= PAGE_SIZE ;
			ReadAddr+= PAGE_SIZE ;
		}
	}while(HasRecvNum < TotoalLen) ;

	HasRecvNum = 0 ;
	ReadAddr = 0 ;

	return XST_SUCCESS;
}


/*****************************************************************************/
/**
 *
 * This function writes to the  serial FLASH connected to the QSPI interface.
 * All the data put into the buffer must be in the same page of the device with
 * page boundaries being on 256 byte boundaries.
 *
 * @param	QspiPtr is a pointer to the QSPI driver component to use.
 * @param	Address contains the address to write data to in the FLASH.
 * @param	ByteCount contains the number of bytes to write.
 * @param	Command is the command used to write data to the flash. QSPI
 *		device supports only Page Program command to write data to the
 *		flash.
 *
 * @return	None.
 *
 * @note		None.
 *
 ******************************************************************************/
void FlashWrite(XQspiPs *QspiPtr, u32 Address, u32 ByteCount, u8 Command)
{
	u8 WriteEnableCmd = { WRITE_ENABLE_CMD };
	u8 ReadStatusCmd[] = { READ_STATUS_CMD, 0 };  /* must send 2 bytes */
	u8 FlashStatus[2];

	/*
	 * Send the write enable command to the FLASH so that it can be
	 * written to, this needs to be sent as a seperate transfer before
	 * the write
	 */
	XQspiPs_PolledTransfer(QspiPtr, &WriteEnableCmd, NULL,
			sizeof(WriteEnableCmd));
	/*
	 * Setup the write command with the specified address and data for the
	 * FLASH
	 */
	WriteBuffer[COMMAND_OFFSET]   = Command;
	WriteBuffer[ADDRESS_1_OFFSET] = (u8)((Address & 0xFF0000) >> 16);
	WriteBuffer[ADDRESS_2_OFFSET] = (u8)((Address & 0xFF00) >> 8);
	WriteBuffer[ADDRESS_3_OFFSET] = (u8)(Address & 0xFF);

	/*
	 * Send the write command, address, and data to the FLASH to be
	 * written, no receive buffer is specified since there is nothing to
	 * receive
	 */
	XQspiPs_PolledTransfer(QspiPtr, WriteBuffer, NULL,
			ByteCount + OVERHEAD_SIZE);

	/*
	 * Wait for the write command to the FLASH to be completed, it takes
	 * some time for the data to be written
	 */
	while (1) {
		/*
		 * Poll the status register of the FLASH to determine when it
		 * completes, by sending a read status command and receiving the
		 * status byte
		 */
		XQspiPs_PolledTransfer(QspiPtr, ReadStatusCmd, FlashStatus,
				sizeof(ReadStatusCmd));

		/*
		 * If the status indicates the write is done, then stop waiting,
		 * if a value of 0xFF in the status byte is read from the
		 * device and this loop never exits, the device slave select is
		 * possibly incorrect such that the device status is not being
		 * read
		 */
		if ((FlashStatus[1] & 0x01) == 0) {
			break;
		}
	}
}

/*****************************************************************************/
/**
 *
 * This function reads from the  serial FLASH connected to the
 * QSPI interface.
 *
 * @param	QspiPtr is a pointer to the QSPI driver component to use.
 * @param	Address contains the address to read data from in the FLASH.
 * @param	ByteCount contains the number of bytes to read.
 * @param	Command is the command used to read data from the flash. QSPI
 *		device supports one of the Read, Fast Read, Dual Read and Fast
 *		Read commands to read data from the flash.
 *
 * @return	None.
 *
 * @note		None.
 *
 ******************************************************************************/
void FlashRead(XQspiPs *QspiPtr, u32 Address, u32 ByteCount, u8 Command)
{
	/*
	 * Setup the write command with the specified address and data for the
	 * FLASH
	 */
	WriteBuffer[COMMAND_OFFSET]   = Command;
	WriteBuffer[ADDRESS_1_OFFSET] = (u8)((Address & 0xFF0000) >> 16);
	WriteBuffer[ADDRESS_2_OFFSET] = (u8)((Address & 0xFF00) >> 8);
	WriteBuffer[ADDRESS_3_OFFSET] = (u8)(Address & 0xFF);

	if ((Command == FAST_READ_CMD) || (Command == DUAL_READ_CMD) ||
			(Command == QUAD_READ_CMD)) {
		ByteCount += DUMMY_SIZE;
	}
	/*
	 * Send the read command to the FLASH to read the specified number
	 * of bytes from the FLASH, send the read command and address and
	 * receive the specified number of bytes of data in the data buffer
	 */
	XQspiPs_PolledTransfer(QspiPtr, WriteBuffer, ReadBuffer,
			ByteCount + OVERHEAD_SIZE);
}

/*****************************************************************************/
/**
 *
 * This function erases the sectors in the  serial FLASH connected to the
 * QSPI interface.
 *
 * @param	QspiPtr is a pointer to the QSPI driver component to use.
 * @param	Address contains the address of the first sector which needs to
 *		be erased.
 * @param	ByteCount contains the total size to be erased.
 *
 * @return	None.
 *
 * @note		None.
 *
 ******************************************************************************/
void FlashErase(XQspiPs *QspiPtr, u32 Address, u32 ByteCount)
{
	u8 WriteEnableCmd = { WRITE_ENABLE_CMD };
	u8 ReadStatusCmd[] = { READ_STATUS_CMD, 0 };  /* must send 2 bytes */
	u8 FlashStatus[2];
	int Sector;
	unsigned int EraseSecNum ;
	int PercentCurr = -1 ;
	int PercentLast = -1 ;

	/*
	 * If erase size is same as the total size of the flash, use bulk erase
	 * command
	 */
	if (ByteCount == (NUM_SECTORS * SECTOR_SIZE)) {
		/*
		 * Send the write enable command to the FLASH so that it can be
		 * written to, this needs to be sent as a seperate transfer
		 * before the erase
		 */
		XQspiPs_PolledTransfer(QspiPtr, &WriteEnableCmd, NULL,
				sizeof(WriteEnableCmd));

		/*
		 * Setup the bulk erase command
		 */
		WriteBuffer[COMMAND_OFFSET]   = BULK_ERASE_CMD;

		/*
		 * Send the bulk erase command; no receive buffer is specified
		 * since there is nothing to receive
		 */
		XQspiPs_PolledTransfer(QspiPtr, WriteBuffer, NULL,
				BULK_ERASE_SIZE);

		/*
		 * Wait for the erase command to the FLASH to be completed
		 */
		while (1) {
			/*
			 * Poll the status register of the device to determine
			 * when it completes, by sending a read status command
			 * and receiving the status byte
			 */
			XQspiPs_PolledTransfer(QspiPtr, ReadStatusCmd,
					FlashStatus,
					sizeof(ReadStatusCmd));

			/*
			 * If the status indicates the write is done, then stop
			 * waiting; if a value of 0xFF in the status byte is
			 * read from the device and this loop never exits, the
			 * device slave select is possibly incorrect such that
			 * the device status is not being read
			 */
			if ((FlashStatus[1] & 0x01) == 0) {
				xil_printf("Bulk Erase Done!\r\n") ;
				break;
			}
		}

		return;
	}

	/*
	 * If the erase size is less than the total size of the flash, use
	 * sector erase command
	 */

	EraseSecNum = ((ByteCount / SECTOR_SIZE) + 1) ;
	xil_printf("Erase Size is %u Bytes\r\n", EraseSecNum*SECTOR_SIZE) ;

	for (Sector = 0; Sector < EraseSecNum ; Sector++) {

		PercentCurr = (int)(((float)Sector/(float)EraseSecNum)*10) ;

		if (PercentCurr != PercentLast)
			print_percent(PercentCurr) ;

		PercentLast = PercentCurr ;



		/*
		 * Send the write enable command to the SEEPOM so that it can be
		 * written to, this needs to be sent as a seperate transfer
		 * before the write
		 */
		XQspiPs_PolledTransfer(QspiPtr, &WriteEnableCmd, NULL,
				sizeof(WriteEnableCmd));

		/*
		 * Setup the write command with the specified address and data
		 * for the FLASH
		 */
		WriteBuffer[COMMAND_OFFSET]   = SEC_ERASE_CMD;
		WriteBuffer[ADDRESS_1_OFFSET] = (u8)(Address >> 16);
		WriteBuffer[ADDRESS_2_OFFSET] = (u8)(Address >> 8);
		WriteBuffer[ADDRESS_3_OFFSET] = (u8)(Address & 0xFF);

		/*
		 * Send the sector erase command and address; no receive buffer
		 * is specified since there is nothing to receive
		 */
		XQspiPs_PolledTransfer(QspiPtr, WriteBuffer, NULL,
				SEC_ERASE_SIZE);



		/*
		 * Wait for the sector erse command to the FLASH to be completed
		 */
		while (1) {
			/*
			 * Poll the status register of the device to determine
			 * when it completes, by sending a read status command
			 * and receiving the status byte
			 */
			XQspiPs_PolledTransfer(QspiPtr, ReadStatusCmd,
					FlashStatus,
					sizeof(ReadStatusCmd));

			/*
			 * If the status indicates the write is done, then stop
			 * waiting, if a value of 0xFF in the status byte is
			 * read from the device and this loop never exits, the
			 * device slave select is possibly incorrect such that
			 * the device status is not being read
			 */
			if ((FlashStatus[1] & 0x01) == 0) {
				break;
			}
		}

		Address += SECTOR_SIZE;
	}
}

/*****************************************************************************/
/**
 *
 * This function reads serial FLASH ID connected to the SPI interface.
 *
 * @param	None.
 *
 * @return	XST_SUCCESS if read id, otherwise XST_FAILURE.
 *
 * @note		None.
 *
 ******************************************************************************/
int FlashReadID(void)
{
	int Status;

	/*
	 * Read ID in Auto mode.
	 */
	WriteBuffer[COMMAND_OFFSET]   = READ_ID;
	WriteBuffer[ADDRESS_1_OFFSET] = 0x23;		/* 3 dummy bytes */
	WriteBuffer[ADDRESS_2_OFFSET] = 0x08;
	WriteBuffer[ADDRESS_3_OFFSET] = 0x09;

	Status = XQspiPs_PolledTransfer(&QspiInstance, WriteBuffer, ReadBuffer,
			RD_ID_SIZE);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	xil_printf("FlashID=0x%x 0x%x 0x%x\n\r", ReadBuffer[1], ReadBuffer[2],
			ReadBuffer[3]);

	return XST_SUCCESS;
}


void print_percent(int percent)
{
	switch(percent)
	{
	case 0 : xil_printf("0%%..") ; break ;
	case 1 : xil_printf("10%%..") ; break ;
	case 2 : xil_printf("20%%..") ; break ;
	case 3 : xil_printf("30%%..") ; break ;
	case 4 : xil_printf("40%%..") ; break ;
	case 5 : xil_printf("50%%..") ; break ;
	case 6 : xil_printf("60%%..") ; break ;
	case 7 : xil_printf("70%%..") ; break ;
	case 8 : xil_printf("80%%..") ; break ;
	case 9 : xil_printf("90%%..") ; break ;
	case 10 : xil_printf("100%..") ; break ;
	default : break ;
	}
}

