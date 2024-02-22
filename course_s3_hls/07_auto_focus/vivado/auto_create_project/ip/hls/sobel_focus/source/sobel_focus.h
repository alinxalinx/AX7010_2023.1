#ifndef __sobel_focus_h__
#define __sobel_focus_h__

#include "ap_int.h"
#include "hls_stream.h"
#include "ap_axi_sdata.h"

#include "common/xf_common.hpp"
#include "common/xf_utility.hpp"
#include "common/xf_infra.hpp"

#include "imgproc/xf_cvt_color.hpp"
#include "imgproc/xf_sobel.hpp"

#define IMG_MAX_ROWS 1080
#define IMG_MAX_COLS 1920

typedef ap_axiu<24,1,1,1> pixel_data;
typedef hls::stream<pixel_data> ustream_t;

void sobel_focus(ustream_t &src, ustream_t &dst, unsigned int &average);

#endif