

/***************************** Include Files *******************************/
#include "ax_pwm.h"

void set_pwm_frequency(unsigned int BaseAddress,int refclk_freq,float freq)
{
	AX_PWM_mWriteReg(BaseAddress,0,(unsigned int)((4294967296.0/refclk_freq) * freq));
}
void set_pwm_duty(unsigned int BaseAddress,float duty)
{
	AX_PWM_mWriteReg(BaseAddress , 4,(unsigned int)(4294967296 * duty));
}

/************************** Function Definitions ***************************/
