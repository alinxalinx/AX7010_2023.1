#ifndef __stream2mem_h__
#define __stream2mem_h__

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

void stream2mem(vstream_t &vstream, unsigned int *pMemPort, int rows, int cols, int addr0,int addr1,int addr2,int &indexw, int indexr);
#endif
