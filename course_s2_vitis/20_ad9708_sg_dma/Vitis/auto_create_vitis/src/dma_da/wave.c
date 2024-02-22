/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */
#include "wave.h"

/*
 * Get Sin Wave value
 *
 *@param point is points in one wave period
 *@param max_amp is maximum amplitude value
 *@param amp_val is current amplitude value
 *@param sin_tab is sin wave buffer pointer
 */
void GetSinWave(int point, int max_amp, int amp_val, u8 *sin_tab)
{
	int i ;
	double radian ;
	double x ;
	double PI = 3.1416 ;
	/* radian value */
	radian = 2*PI/point ;

	for(i = 0; i < point; i++)
	{
		x = radian*i ;
		sin_tab[i] = (u8)((amp_val/2)*sin(x) + max_amp/2) ;
	}
}


/*
 * Get Square Wave value
 *
 *@param point is points in one wave period
 *@param max_amp is maximum amplitude value
 *@param amp_val is current amplitude value
 *@param Square_tab is Square wave buffer pointer
 */
void GetSquareWave(int point, int max_amp, int amp_val, u8 *Square_tab)
{
	int i ;

	for(i = 0; i < point; i++)
	{
		if (i < point/2)
			Square_tab[i] = (u8)((max_amp-amp_val)/2 + amp_val - 1) ;
		else
			Square_tab[i] = (u8)((max_amp-amp_val)/2 ) ;
	}
}


/*
 * Get Triangle Wave value
 *
 *@param point is points in one wave period
 *@param max_amp is maximum amplitude value
 *@param amp_val is current amplitude value
 *@param Triangle_tab is Triangle wave buffer pointer
 */
void GetTriangleWave(int point, int max_amp, int amp_val, u8 *Triangle_tab)
{
	int i ;
	double tap_val ;
	tap_val = 2*(double)amp_val/(double)point;

	for(i = 0; i < point; i++)
	{
		if (i < point/2)
			Triangle_tab[i] = (u8)(i*tap_val + (max_amp-amp_val)/2) ;
		else
			Triangle_tab[i] = (u8)(amp_val - 1 - (i-point/2)*tap_val + (max_amp-amp_val)/2 ) ;
	}
}

/*
 * Get Sawtooth Wave value
 *
 *@param point is points in one wave period
 *@param max_amp is maximum amplitude value
 *@param amp_val is current amplitude value
 *@param Sawtooth_tab is Sawtooth wave buffer pointer
 */
void GetSawtoothWave(int point, int max_amp, int amp_val, u8 *Sawtooth_tab)
{
	int i ;
	double tap_val ;
	tap_val = (double)amp_val/(double)point;

	for(i = 0; i < point; i++)
		Sawtooth_tab[i] = (u8)(i*tap_val + (max_amp-amp_val)/2) ;
}


/*
 * Get SubSawtooth Wave value
 *
 *@param point is points in one wave period
 *@param max_amp is maximum amplitude value
 *@param amp_val is current amplitude value
 *@param SubSawtooth_tab is SubSawtooth wave buffer pointer
 */
void GetSubSawtoothWave(int point, int max_amp, int amp_val, u8 *SubSawtooth_tab)
{
	int i ;
	double tap_val ;
	tap_val = (double)amp_val/(double)point;

	for(i = 0; i < point; i++)
		SubSawtooth_tab[i] = (u8)(amp_val - 1 - i*tap_val + (max_amp-amp_val)/2) ;
}

