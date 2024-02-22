/*
 * wave.h
 *
 *  Created on: 2018Äê7ÔÂ19ÈÕ
 *      Author: Administrator
 */

#ifndef WAVE_H_
#define WAVE_H_

#include <math.h>
#include "xil_types.h"

void GetSinWave(int point, int max_amp, int amp_val, u8 *sin_tab) ;
void GetSquareWave(int point, int max_amp, int amp_val, u8 *Square_tab) ;
void GetTriangleWave(int point, int max_amp, int amp_val, u8 *Triangle_tab) ;
void GetSawtoothWave(int point, int max_amp, int amp_val, u8 *Sawtooth_tab) ;
void GetSubSawtoothWave(int point, int max_amp, int amp_val, u8 *SubSawtooth_tab) ;

#endif /* WAVE_H_ */
