#ifndef DETECTCORNER_H
#define DETECTCORNER_H

#include "hls_stream.h"
#include "ap_int.h"
#include "string.h"

#include "common/xf_common.hpp"
#include "common/xf_utility.hpp"
#include "common/xf_infra.hpp"

#include "imgproc/xf_cvt_color.hpp"
#include "xf_fast.hpp"
#include "imgproc/xf_dilation.hpp"

typedef ap_axiu<24,1,1,1> pixel_t;
typedef hls::stream<pixel_t> stream_t;

#define IMG_MAX_ROWS	1080
#define IMG_MAX_COLS	1920
#define NEW_K_ROWS 16
#define NEW_K_COLS 16

void detectCorner(unsigned int *pImgRGB888, unsigned int *pCorner, int rows, int cols, int threhold);

#endif
