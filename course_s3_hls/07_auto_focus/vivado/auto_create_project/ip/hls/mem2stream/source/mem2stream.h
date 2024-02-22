#ifndef __mem2stream_h__
#define __mem2stream_h__

#include "ap_int.h"
#include "hls_stream.h"
#include "ap_axi_sdata.h"

#include "common/xf_common.hpp"
#include "common/xf_utility.hpp"
#include "common/xf_infra.hpp"

#define IMG_MAX_ROWS 1080
#define IMG_MAX_COLS 1920

typedef ap_axiu<24,1,1,1> pixel_data;
typedef hls::stream<pixel_data> vstream_t;

void mem2stream(vstream_t &vstream, unsigned int *pMemPort, int rows, int cols,unsigned int baseAddr[3],int indexw, int &indexr);

#endif
