// SPDX-License-Identifier: GPL-2.0
/*
 * Xilinx FPGA SDI Tx Subsystem driver.
 *
 * Copyright (c) 2017 Xilinx Pvt., Ltd
 *
 * Contacts: Saurabh Sengar <saurabhs@xilinx.com>
 */

#include <drm/drm_atomic_helper.h>
#include <drm/drm_crtc_helper.h>
#include <drm/drm_probe_helper.h>
#include <linux/clk.h>
#include <linux/component.h>
#include <linux/device.h>
#include <linux/of_device.h>
#include <linux/of_graph.h>
#include <linux/phy/phy.h>
#include <video/videomode.h>

/* SDI register offsets */
#define XSDI_TX_RST_CTRL		0x00
#define XSDI_TX_MDL_CTRL		0x04
#define XSDI_TX_GLBL_IER		0x0C
#define XSDI_TX_ISR_STAT		0x10
#define XSDI_TX_IER_STAT		0x14
#define XSDI_TX_ST352_LINE		0x18
#define XSDI_TX_ST352_DATA_CH0		0x1C
#define XSDI_TX_VER			0x3C
#define XSDI_TX_SYS_CFG			0x40
#define XSDI_TX_STS_SB_TDATA		0x60
#define XSDI_TX_AXI4S_STS1		0x68
#define XSDI_TX_AXI4S_STS2		0x6C
#define XSDI_TX_ST352_DATA_DS2		0x70

/* MODULE_CTRL register masks */
#define XSDI_TX_CTRL_M			BIT(7)
#define XSDI_TX_CTRL_INS_CRC		BIT(12)
#define XSDI_TX_CTRL_INS_ST352		BIT(13)
#define XSDI_TX_CTRL_OVR_ST352		BIT(14)
#define XSDI_TX_CTRL_INS_SYNC_BIT	BIT(16)
#define XSDI_TX_CTRL_USE_ANC_IN		BIT(18)
#define XSDI_TX_CTRL_INS_LN		BIT(19)
#define XSDI_TX_CTRL_INS_EDH		BIT(20)
#define XSDI_TX_CTRL_MODE		0x7
#define XSDI_TX_CTRL_MUX		0x7
#define XSDI_TX_CTRL_MODE_SHIFT		4
#define XSDI_TX_CTRL_M_SHIFT		7
#define XSDI_TX_CTRL_MUX_SHIFT		8
#define XSDI_TX_CTRL_ST352_F2_EN_SHIFT	15
#define XSDI_TX_CTRL_420_BIT		BIT(21)
#define XSDI_TX_CTRL_INS_ST352_CHROMA	BIT(23)
#define XSDI_TX_CTRL_USE_DS2_3GA	BIT(24)

/* TX_ST352_LINE register masks */
#define XSDI_TX_ST352_LINE_MASK		GENMASK(10, 0)
#define XSDI_TX_ST352_LINE_F2_SHIFT	16

/* ISR STAT register masks */
#define XSDI_GTTX_RSTDONE_INTR		BIT(0)
#define XSDI_TX_CE_ALIGN_ERR_INTR	BIT(1)
#define XSDI_AXI4S_VID_LOCK_INTR	BIT(8)
#define XSDI_OVERFLOW_INTR		BIT(9)
#define XSDI_UNDERFLOW_INTR		BIT(10)
#define XSDI_IER_EN_MASK		(XSDI_GTTX_RSTDONE_INTR | \
					XSDI_TX_CE_ALIGN_ERR_INTR | \
					XSDI_OVERFLOW_INTR | \
					XSDI_UNDERFLOW_INTR)

/* RST_CTRL_OFFSET masks */
#define XSDI_TX_CTRL_EN			BIT(0)
#define XSDI_TX_BRIDGE_CTRL_EN		BIT(8)
#define XSDI_TX_AXI4S_CTRL_EN		BIT(9)
/* STS_SB_TX_TDATA masks */
#define XSDI_TX_TDATA_GT_RESETDONE	BIT(2)

#define XSDI_TX_MUX_SD_HD_3GA		0
#define	XSDI_TX_MUX_3GB			1
#define	XSDI_TX_MUX_8STREAM_6G_12G	2
#define	XSDI_TX_MUX_4STREAM_6G		3
#define	XSDI_TX_MUX_16STREAM_12G	4

#define SDI_MAX_DATASTREAM		8
#define PIXELS_PER_CLK			2
#define XSDI_CH_SHIFT			29
#define XST352_PROG_PIC			BIT(6)
#define XST352_PROG_TRANS		BIT(7)
#define XST352_2048_SHIFT		BIT(6)
#define XST352_YUV420_MASK		0x03
#define ST352_BYTE3			0x00
#define ST352_BYTE4			0x01
#define GT_TIMEOUT			50
/* SDI modes */
#define XSDI_MODE_HD			0
#define	XSDI_MODE_SD			1
#define	XSDI_MODE_3GA			2
#define	XSDI_MODE_3GB			3
#define	XSDI_MODE_6G			4
#define	XSDI_MODE_12G			5

#define SDI_TIMING_PARAMS_SIZE		48

/**
 * enum payload_line_1 - Payload Ids Line 1 number
 * @PAYLD_LN1_HD_3_6_12G:	line 1 HD,3G,6G or 12G mode value
 * @PAYLD_LN1_SDPAL:		line 1 SD PAL mode value
 * @PAYLD_LN1_SDNTSC:		line 1 SD NTSC mode value
 */
enum payload_line_1 {
	PAYLD_LN1_HD_3_6_12G = 10,
	PAYLD_LN1_SDPAL = 9,
	PAYLD_LN1_SDNTSC = 13
};

/**
 * enum payload_line_2 - Payload Ids Line 2 number
 * @PAYLD_LN2_HD_3_6_12G:	line 2 HD,3G,6G or 12G mode value
 * @PAYLD_LN2_SDPAL:		line 2 SD PAL mode value
 * @PAYLD_LN2_SDNTSC:		line 2 SD NTSC mode value
 */
enum payload_line_2 {
	PAYLD_LN2_HD_3_6_12G = 572,
	PAYLD_LN2_SDPAL = 322,
	PAYLD_LN2_SDNTSC = 276
};

/**
 * struct xlnx_sdi - Core configuration SDI Tx subsystem device structure
 * @encoder: DRM encoder structure
 * @connector: DRM connector structure
 * @dev: device structure
 * @base: Base address of SDI subsystem
 * @mode_flags: SDI operation mode related flags
 * @wait_event: wait event
 * @event_received: wait event status
 * @enable_st352_chroma: Able to send ST352 packets in Chroma stream.
 * @enable_anc_data: Enable/Disable Ancillary Data insertion for Audio
 * @sdi_mode: configurable SDI mode parameter, supported values are:
 *		0 - HD
 *		1 - SD
 *		2 - 3GA
 *		3 - 3GB
 *		4 - 6G
 *		5 - 12G
 * @sdi_mod_prop_val: configurable SDI mode parameter value
 * @sdi_data_strm: configurable SDI data stream parameter
 * @sdi_data_strm_prop_val: configurable number of SDI data streams
 *			    value currently supported are 2, 4 and 8
 * @sdi_420_in: Specifying input bus color format parameter to SDI
 * @sdi_420_in_val: 1 for yuv420 and 0 for yuv422
 * @sdi_420_out: configurable SDI out color format parameter
 * @sdi_420_out_val: 1 for yuv420 and 0 for yuv422
 * @is_frac_prop: configurable SDI fractional fps parameter
 * @is_frac_prop_val: configurable SDI fractional fps parameter value
 * @bridge: bridge structure
 * @height_out: configurable bridge output height parameter
 * @height_out_prop_val: configurable bridge output height parameter value
 * @width_out: configurable bridge output width parameter
 * @width_out_prop_val: configurable bridge output width parameter value
 * @in_fmt: configurable bridge input media format
 * @in_fmt_prop_val: configurable media bus format value
 * @out_fmt: configurable bridge output media format
 * @out_fmt_prop_val: configurable media bus format value
 * @en_st352_c_prop: configurable ST352 payload on Chroma stream parameter
 * @en_st352_c_val: configurable ST352 payload on Chroma parameter value
 * @use_ds2_3ga_prop: Use DS2 instead of DS3 in 3GA mode parameter
 * @use_ds2_3ga_val: Use DS2 instead of DS3 in 3GA mode parameter value
 * @video_mode: current display mode
 * @axi_clk: AXI Lite interface clock
 * @sditx_clk: SDI Tx Clock
 * @vidin_clk: Video Clock
 */
struct xlnx_sdi {
	struct drm_encoder encoder;
	struct drm_connector connector;
	struct device *dev;
	void __iomem *base;
	u32 mode_flags;
	wait_queue_head_t wait_event;
	bool event_received;
	bool enable_st352_chroma;
	bool enable_anc_data;
	struct drm_property *sdi_mode;
	u32 sdi_mod_prop_val;
	struct drm_property *sdi_data_strm;
	u32 sdi_data_strm_prop_val;
	struct drm_property *sdi_420_in;
	bool sdi_420_in_val;
	struct drm_property *sdi_420_out;
	bool sdi_420_out_val;
	struct drm_property *is_frac_prop;
	bool is_frac_prop_val;
	struct xlnx_bridge *bridge;
	struct drm_property *height_out;
	u32 height_out_prop_val;
	struct drm_property *width_out;
	u32 width_out_prop_val;
	struct drm_property *in_fmt;
	u32 in_fmt_prop_val;
	struct drm_property *out_fmt;
	u32 out_fmt_prop_val;
	struct drm_property *en_st352_c_prop;
	bool en_st352_c_val;
	struct drm_property *use_ds2_3ga_prop;
	bool use_ds2_3ga_val;
	struct drm_display_mode video_mode;
	struct clk *axi_clk;
	struct clk *sditx_clk;
	struct clk *vidin_clk;
};

#define connector_to_sdi(c) container_of(c, struct xlnx_sdi, connector)
#define encoder_to_sdi(e) container_of(e, struct xlnx_sdi, encoder)

static const struct drm_display_mode alinx_lcd_001_mode = {
    .clock = 33260,
    .hdisplay = 800,
    .hsync_start = 800 + 40,
    .hsync_end = 800 + 40 + 128,
    .htotal = 800 + 40 + 128 + 88,
    .vdisplay = 480,
    .vsync_start = 480 + 10,
    .vsync_end = 480 + 10 + 2,
    .vtotal = 480 + 10 + 2 + 33,
    .flags = DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC,
    .type = 0,
    .name = "800x480",
};

static int xlnx_sdi_atomic_set_property(struct drm_connector *connector,
			     struct drm_connector_state *state,
			     struct drm_property *property, uint64_t val)
{
	struct xlnx_sdi *sdi = connector_to_sdi(connector);

	if (property == sdi->sdi_mode)
		sdi->sdi_mod_prop_val = (unsigned int)val;
	else if (property == sdi->sdi_data_strm)
		sdi->sdi_data_strm_prop_val = (unsigned int)val;
	else if (property == sdi->sdi_420_in)
		sdi->sdi_420_in_val = val;
	else if (property == sdi->sdi_420_out)
		sdi->sdi_420_out_val = val;
	else if (property == sdi->is_frac_prop)
		sdi->is_frac_prop_val = !!val;
	else if (property == sdi->height_out)
		sdi->height_out_prop_val = (unsigned int)val;
	else if (property == sdi->width_out)
		sdi->width_out_prop_val = (unsigned int)val;
	else if (property == sdi->in_fmt)
		sdi->in_fmt_prop_val = (unsigned int)val;
	else if (property == sdi->out_fmt)
		sdi->out_fmt_prop_val = (unsigned int)val;
	else if (property == sdi->en_st352_c_prop)
		sdi->en_st352_c_val = !!val;
	else if (property == sdi->use_ds2_3ga_prop)
		sdi->use_ds2_3ga_val = !!val;
	else
		return -EINVAL;
	return 0;
}

static int xlnx_sdi_atomic_get_property(struct drm_connector *connector,
			     const struct drm_connector_state *state,
			     struct drm_property *property, uint64_t *val)
{
	struct xlnx_sdi *sdi = connector_to_sdi(connector);

	if (property == sdi->sdi_mode)
		*val = sdi->sdi_mod_prop_val;
	else if (property == sdi->sdi_data_strm)
		*val =  sdi->sdi_data_strm_prop_val;
	else if (property == sdi->sdi_420_in)
		*val = sdi->sdi_420_in_val;
	else if (property == sdi->sdi_420_out)
		*val = sdi->sdi_420_out_val;
	else if (property == sdi->is_frac_prop)
		*val =  sdi->is_frac_prop_val;
	else if (property == sdi->height_out)
		*val = sdi->height_out_prop_val;
	else if (property == sdi->width_out)
		*val = sdi->width_out_prop_val;
	else if (property == sdi->in_fmt)
		*val = sdi->in_fmt_prop_val;
	else if (property == sdi->out_fmt)
		*val = sdi->out_fmt_prop_val;
	else if (property == sdi->en_st352_c_prop)
		*val =  sdi->en_st352_c_val;
	else if (property == sdi->use_ds2_3ga_prop)
		*val =  sdi->use_ds2_3ga_val;
	else
		return -EINVAL;

	return 0;
}

static int xlnx_sdi_drm_add_modes(struct drm_connector *connector)
{
    int num_modes = 0;
    struct drm_display_mode *mode;
    struct drm_device *dev = connector->dev;

    mode = drm_mode_duplicate(dev, &alinx_lcd_001_mode);
    drm_mode_probed_add(connector, mode);
    num_modes++;

    return num_modes;
}

static enum drm_connector_status xlnx_sdi_detect(struct drm_connector *connector, bool force)
{
	return connector_status_connected;
}

static void xlnx_sdi_connector_destroy(struct drm_connector *connector)
{
	drm_connector_unregister(connector);
	drm_connector_cleanup(connector);
	connector->dev = NULL;
}

static const struct drm_connector_funcs xlnx_sdi_connector_funcs = {
	.detect = xlnx_sdi_detect,
	.fill_modes = drm_helper_probe_single_connector_modes,
	.destroy = xlnx_sdi_connector_destroy,
	.atomic_duplicate_state	= drm_atomic_helper_connector_duplicate_state,
	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
	.reset = drm_atomic_helper_connector_reset,
	.atomic_set_property = xlnx_sdi_atomic_set_property,
	.atomic_get_property = xlnx_sdi_atomic_get_property,
};

static struct drm_encoder *
xlnx_sdi_best_encoder(struct drm_connector *connector)
{
	return &(connector_to_sdi(connector)->encoder);
}

static int xlnx_sdi_get_modes(struct drm_connector *connector)
{
	return xlnx_sdi_drm_add_modes(connector);
}

static struct drm_connector_helper_funcs xlnx_sdi_connector_helper_funcs = {
	.get_modes = xlnx_sdi_get_modes,
	.best_encoder = xlnx_sdi_best_encoder,
};

static void xlnx_sdi_drm_connector_create_property(struct drm_connector *base_connector)
{
	struct drm_device *dev = base_connector->dev;
	struct xlnx_sdi *sdi  = connector_to_sdi(base_connector);

	sdi->is_frac_prop = drm_property_create_bool(dev, 0, "is_frac");
	sdi->sdi_mode = drm_property_create_range(dev, 0,
						  "sdi_mode", 0, 5);
	sdi->sdi_data_strm = drm_property_create_range(dev, 0,
						       "sdi_data_stream", 2, 8);
	sdi->sdi_420_in = drm_property_create_bool(dev, 0, "sdi_420_in");
	sdi->sdi_420_out = drm_property_create_bool(dev, 0, "sdi_420_out");
	sdi->height_out = drm_property_create_range(dev, 0,
						    "height_out", 2, 4096);
	sdi->width_out = drm_property_create_range(dev, 0,
						   "width_out", 2, 4096);
	sdi->in_fmt = drm_property_create_range(dev, 0,
						"in_fmt", 0, 16384);
	sdi->out_fmt = drm_property_create_range(dev, 0,
						 "out_fmt", 0, 16384);
	if (sdi->enable_st352_chroma) {
		sdi->en_st352_c_prop = drm_property_create_bool(dev, 0,
								"en_st352_c");
		sdi->use_ds2_3ga_prop = drm_property_create_bool(dev, 0,
								 "use_ds2_3ga");
	}
}

static void xlnx_sdi_drm_connector_attach_property(struct drm_connector *base_connector)
{
	struct xlnx_sdi *sdi = connector_to_sdi(base_connector);
	struct drm_mode_object *obj = &base_connector->base;

	if (sdi->sdi_mode)
		drm_object_attach_property(obj, sdi->sdi_mode, 0);

	if (sdi->sdi_data_strm)
		drm_object_attach_property(obj, sdi->sdi_data_strm, 0);

	if (sdi->sdi_420_in)
		drm_object_attach_property(obj, sdi->sdi_420_in, 0);

	if (sdi->sdi_420_out)
		drm_object_attach_property(obj, sdi->sdi_420_out, 0);

	if (sdi->is_frac_prop)
		drm_object_attach_property(obj, sdi->is_frac_prop, 0);

	if (sdi->height_out)
		drm_object_attach_property(obj, sdi->height_out, 0);

	if (sdi->width_out)
		drm_object_attach_property(obj, sdi->width_out, 0);

	if (sdi->in_fmt)
		drm_object_attach_property(obj, sdi->in_fmt, 0);

	if (sdi->out_fmt)
		drm_object_attach_property(obj, sdi->out_fmt, 0);

	if (sdi->en_st352_c_prop)
		drm_object_attach_property(obj, sdi->en_st352_c_prop, 0);

	if (sdi->use_ds2_3ga_prop)
		drm_object_attach_property(obj, sdi->use_ds2_3ga_prop, 0);
}

static int xlnx_sdi_create_connector(struct drm_encoder *encoder)
{
	struct xlnx_sdi *sdi = encoder_to_sdi(encoder);
	struct drm_connector *connector = &sdi->connector;
	int ret;

	connector->interlace_allowed = true;
	connector->doublescan_allowed = true;

	ret = drm_connector_init(encoder->dev, connector,
				 &xlnx_sdi_connector_funcs,
				 DRM_MODE_CONNECTOR_Unknown);
	if (ret) {
		dev_err(sdi->dev, "Failed to initialize connector with drm\n");
		return ret;
	}

	drm_connector_helper_add(connector, &xlnx_sdi_connector_helper_funcs);
	drm_connector_register(connector);
	drm_connector_attach_encoder(connector, encoder);
	xlnx_sdi_drm_connector_create_property(connector);
	xlnx_sdi_drm_connector_attach_property(connector);

	return 0;
}

static void xlnx_sdi_set_display_enable(struct xlnx_sdi *sdi)
{

}

static void xlnx_sdi_encoder_atomic_mode_set(struct drm_encoder *encoder,
					     struct drm_crtc_state *crtc_state,
				  struct drm_connector_state *connector_state)
{
	struct xlnx_sdi *sdi = encoder_to_sdi(encoder);

	sdi->video_mode = alinx_lcd_001_mode;
}

static void xlnx_sdi_commit(struct drm_encoder *encoder)
{
	struct xlnx_sdi *sdi = encoder_to_sdi(encoder);
	long ret;

	dev_dbg(sdi->dev, "%s\n", __func__);
	sdi->event_received = false;
}

static void xlnx_sdi_disable(struct drm_encoder *encoder)
{
	
}

static const struct drm_encoder_helper_funcs xlnx_sdi_encoder_helper_funcs = {
	.atomic_mode_set	= xlnx_sdi_encoder_atomic_mode_set,
	.enable			= xlnx_sdi_commit,
	.disable		= xlnx_sdi_disable,
};

static const struct drm_encoder_funcs xlnx_sdi_encoder_funcs = {
	.destroy = drm_encoder_cleanup,
};

static int xlnx_sdi_bind(struct device *dev, struct device *master,
			 void *data)
{
	struct xlnx_sdi *sdi = dev_get_drvdata(dev);
	struct drm_encoder *encoder = &sdi->encoder;
	struct drm_device *drm_dev = data;
	int ret;

	encoder->possible_crtcs = 1;

	drm_encoder_init(drm_dev, encoder, &xlnx_sdi_encoder_funcs,
			 DRM_MODE_ENCODER_TMDS, NULL);

	drm_encoder_helper_add(encoder, &xlnx_sdi_encoder_helper_funcs);

	ret = xlnx_sdi_create_connector(encoder);
	if (ret) {
		dev_err(sdi->dev, "fail creating connector, ret = %d\n", ret);
		drm_encoder_cleanup(encoder);
	}
	return ret;
}

static void xlnx_sdi_unbind(struct device *dev, struct device *master,
			    void *data)
{
	struct xlnx_sdi *sdi = dev_get_drvdata(dev);

	drm_encoder_cleanup(&sdi->encoder);
	drm_connector_cleanup(&sdi->connector);
}

static const struct component_ops xlnx_sdi_component_ops = {
	.bind	= xlnx_sdi_bind,
	.unbind	= xlnx_sdi_unbind,
};

static int xlnx_sdi_probe(struct platform_device *pdev)
{
	struct device *dev = &pdev->dev;
	struct resource *res;
	struct xlnx_sdi *sdi;
	struct device_node *vpss_node;
	int ret, irq;
	struct device_node *ports, *port;
	u32 nports = 0, portmask = 0;

	sdi = devm_kzalloc(dev, sizeof(*sdi), GFP_KERNEL);
	if (!sdi)
		return -ENOMEM;

	sdi->dev = dev;

	platform_set_drvdata(pdev, sdi);


	/* in case all "port" nodes are grouped under a "ports" node */
	ports = of_get_child_by_name(sdi->dev->of_node, "ports");
	if (!ports) {
		dev_dbg(dev, "Searching for port nodes in device node.\n");
		ports = sdi->dev->of_node;
	}

	for_each_child_of_node(ports, port) {
		struct device_node *endpoint;
		u32 index;

		if (!port->name || of_node_cmp(port->name, "port")) {
			dev_dbg(dev, "port name is null or node name is not port!\n");
			continue;
		}

		endpoint = of_get_next_child(port, NULL);
		if (!endpoint) {
			dev_err(dev, "No remote port at %s\n", port->name);
			of_node_put(endpoint);
			ret = -EINVAL;
			goto err_disable_vidin_clk;
		}

		of_node_put(endpoint);

		ret = of_property_read_u32(port, "reg", &index);
		if (ret) {
			dev_err(dev, "reg property not present - %d\n", ret);
			goto err_disable_vidin_clk;
		}

		portmask |= (1 << index);

		nports++;
	}


	/* initialize the wait queue for GT reset event */
	init_waitqueue_head(&sdi->wait_event);

	/* video mode properties needed by audio driver are shared to audio
	 * driver through a pointer in platform data. This will be used in
	 * audio driver. The solution may be needed to modify/extend to avoid
	 * probable error scenarios
	 */

	sdi->video_mode = alinx_lcd_001_mode;

	
	pdev->dev.platform_data = &sdi->video_mode;

	ret = component_add(dev, &xlnx_sdi_component_ops);
	if (ret < 0)
		goto err_disable_vidin_clk;

	dev_info(sdi->dev, "alinx lcd probed\n");

	return ret;

err_disable_vidin_clk:
	
err_disable_sditx_clk:
	
err_disable_axi_clk:
	

	return ret;
}

static int xlnx_sdi_remove(struct platform_device *pdev)
{
	struct xlnx_sdi *sdi = platform_get_drvdata(pdev);

	component_del(&pdev->dev, &xlnx_sdi_component_ops);
	clk_disable_unprepare(sdi->vidin_clk);
	clk_disable_unprepare(sdi->sditx_clk);
	clk_disable_unprepare(sdi->axi_clk);

	return 0;
}

static const struct of_device_id xlnx_sdi_of_match[] = {
	{ .compatible = "ax-drm-encoder"},
	{ }
};
MODULE_DEVICE_TABLE(of, xlnx_sdi_of_match);

static struct platform_driver sdi_tx_driver = {
	.probe = xlnx_sdi_probe,
	.remove = xlnx_sdi_remove,
	.driver = {
		.name = "alinx_lcd",
		.of_match_table = xlnx_sdi_of_match,
	},
};

module_platform_driver(sdi_tx_driver);

MODULE_AUTHOR("alinx");
MODULE_DESCRIPTION("alinx lcd");
MODULE_LICENSE("GPL v2");



