#ifndef __CONTRASTADJ_H__
#define __CONTRASTADJ_H__

#include "ap_int.h"
#include "hls_stream.h"
#include "common/xf_utility.hpp"
#include "common/xf_infra.hpp"
#include "common/xf_common.hpp"
#include "imgproc/xf_cvt_color.hpp"

#define IMG_MAX_HEIGHT	1080
#define IMG_MAX_WIDTH	1920

void contrastadj(hls::stream<ap_axiu<24,1,1,1>> &src_axi, hls::stream<ap_axiu<24,1,1,1>> &dst_axi, int adj);

#endif