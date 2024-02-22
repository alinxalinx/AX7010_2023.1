#ifndef __colorbar_h__
#define __colorbar_h__

#include "ap_int.h"
#include "hls_stream.h"
#include "ap_axi_sdata.h"

#include "common/xf_common.hpp"
#include "common/xf_utility.hpp"
#include "common/xf_infra.hpp"

#define IMG_MAX_ROWS 1080
#define IMG_MAX_COLS 1920

typedef ap_axiu<24,1,1,1> pixel_data;
typedef hls::stream<pixel_data> pixel_stream;

void colorbar(pixel_stream &dst, int rows, int cols);

#endif