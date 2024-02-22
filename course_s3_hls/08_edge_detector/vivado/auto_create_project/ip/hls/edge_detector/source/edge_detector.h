#ifndef __edge_detector_h__
#define __edge_detector_h__

#include "ap_axi_sdata.h"
#include "hls_stream.h"
#include "ap_int.h"

#include "common/xf_common.hpp"
#include "common/xf_utility.hpp"
#include "common/xf_infra.hpp"

#include "imgproc/xf_cvt_color.hpp"
#include "imgproc/xf_sobel.hpp"

typedef ap_axiu<24, 1, 1, 1> us_pixel_t;
typedef hls::stream<us_pixel_t> ustream_t;

#define IMG_MAX_ROWS 1080
#define IMG_MAX_COLS 1920

void edge_detector(ustream_t &src, ustream_t &dst, unsigned char threshold);

#endif
