#ifndef USTREAM_H
#define USTREAM_H

#include <hls_stream.h>
#include <hls_video.h>
#include <ap_axi_sdata.h>

typedef ap_axiu<24, 1, 1, 1> us_pixel_t;
typedef hls::stream<us_pixel_t> ustream_t;

#endif
