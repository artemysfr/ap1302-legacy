#!/bin/sh

function ap1302_check_driver()
{
	if [ ! -d /sys/kernel/debug/ap1302.0-003c/ ]; then
		echo "Driver not loaded, exiting"
		return 1
	fi
}

#
# $1: read size: 8, 16 or 32 (32bits)
# $2: adress of register (4 digits if 8 or 16 bits, 6 digits if 32 bits)
# $3: optionnal, human readable register name
#
function ap1302_read_reg()
{
	echo -n "Value of register '${3}' at address 0x$2 = "
	if [ "$1" == "16" ]; then	# 16bits
		echo 0x0200$2 > /sys/kernel/debug/ap1302.0-003c/basic_addr
	elif [ "$1" == "32" ]; then	# 32bits
		echo 0x04$2 > /sys/kernel/debug/ap1302.0-003c/basic_addr
	else	# 8bits
		echo 0x0100$2 > /sys/kernel/debug/ap1302.0-003c/basic_addr
	fi
	cat /sys/kernel/debug/ap1302.0-003c/basic_data
}

#
# $1: register size: 8, 16 or 32 (bits)
# $2: adress of register (4 digits if 8 or 16 bits, 6 digits if 32 bits)
# $3: value to write (6 digits)
# $4: optionnal, human readable register name
#
function ap1302_read_and_set_reg()
{
	if [ "$1" == "32" ]; then
	        echo "0x04${2}" > /sys/kernel/debug/ap1302.0-003c/basic_addr
	elif [ "$1" == "16" ]; then
	        echo "0x02${2}" > /sys/kernel/debug/ap1302.0-003c/basic_addr
	else
		echo 0x0100$2 > /sys/kernel/debug/ap1302.0-003c/basic_addr
	fi
	echo "Register '${4}' at 0x${2}: replacing (`cat /sys/kernel/debug/ap1302.0-003c/basic_data`) with 0x${3}"
	echo "0x${3}" > /sys/kernel/debug/ap1302.0-003c/basic_data
}

function ap1302_dump_all_regs()
{
	ap1302_check_driver

	echo "Basic Preview Registers"
	ap1302_read_reg 16 1186 "TRIGGER_CTRL"

        ap1302_read_reg 16 2000 "PREVIEW_WIDTH"
        ap1302_read_reg 16 2002 "PREVIEW_HEIGHT"
        ap1302_read_reg 16 2004 "PREVIEW_ROI_X0"
        ap1302_read_reg 16 2006 "PREVIEW_ROI_Y0"
        ap1302_read_reg 16 2008 "PREVIEW_ROI_X1"
        ap1302_read_reg 16 200a "PREVIEW_ROI_Y1"
        ap1302_read_reg 16 200c "PREVIEW_ASPECT_FACTOR"
        ap1302_read_reg 16 200e "PREVIEW_LOCK"
        ap1302_read_reg 16 2010 "PREVIEW_ENABLE"
        ap1302_read_reg 16 2012 "PREVIEW_OUT_FORMAT"
        ap1302_read_reg 16 2014 "PREVIEW_SENSOR_MODE"
        ap1302_read_reg 16 2016 "PREVIEW_MIPI_CTRL"
        ap1302_read_reg 16 2018 "PREVIEW_MIPI_II_CTRL"
        ap1302_read_reg 16 201a "PREVIEW_MIPI_T_HS_EXIT"
        ap1302_read_reg 32 00201c "PREVIEW_LINE_TIME"
        ap1302_read_reg 16 2020 "PREVIEW_MAX_FPS"
        ap1302_read_reg 16 2022 "PREVIEW_MAX_AE_USG"
        ap1302_read_reg 32 002024 "PREVIEW_AE_UPPER_ET"
        ap1302_read_reg 32 002028 "PREVIEW_AE_MAX_ET"
        ap1302_read_reg 16 202c "PREVIEW_SS"
        ap1302_read_reg 16 2030 "PREVIEW_HINF_CTRL"
        ap1302_read_reg 16 2032 "PREVIEW_HINF_SPOOF_W"
        ap1302_read_reg 16 2034 "PREVIEW_HINF_SPOOF_H"
        ap1302_read_reg 16 2036 "PREVIEW_HINF_CUT"
        ap1302_read_reg 16 2050 "PREVIEW_DIV_CPU"
        ap1302_read_reg 32 002054 "PREVIEW_DIV_IPIPE"
        ap1302_read_reg 32 002058 "PREVIEW_DIV_SINF"
        ap1302_read_reg 32 00205c "PREVIEW_DIV_HINF"
        ap1302_read_reg 32 002064 "PREVIEW_DIV_HINF_MIPI"
        ap1302_read_reg 32 002068 "PREVIEW_DIV_IP"
        ap1302_read_reg 32 00206c "PREVIEW_DIV_SPI"
        ap1302_read_reg 32 002070 "PREVIEW_DIV_PRI_SENSOR"
        ap1302_read_reg 32 002074 "PREVIEW_DIV_SEC_SENSOR"
        ap1302_read_reg 32 002078 "PREVIEW_AE_MIN_ET"

        ap1302_read_reg 16 3000 "SNAPSHOT_WIDTH"
        ap1302_read_reg 16 3002 "SNAPSHOT_HEIGHT"
        ap1302_read_reg 16 3012 "SNAPSHOT_OUT_FORMAT"

	echo
        ap1302_read_reg 16 4000 "VIDEO_WIDTH"
        ap1302_read_reg 16 4002 "VIDEO_HEIGHT"
        ap1302_read_reg 16 4012 "VIDEO_OUT_FORMAT"

	echo
        ap1302_read_reg 16 5002 "AE_CTRL"
        ap1302_read_reg 16 5058 "AF_CTRL"
        ap1302_read_reg 16 5454 "SCENE_MODE"

	echo "Basic Control Registers"
        ap1302_read_reg 16 1000 "CTRL"
        ap1302_read_reg 32 001008 "ENABLE"
        ap1302_read_reg 16 100c "ORIENTATION"
        ap1302_read_reg 16 1016 "SFX_MODE"
	ap1302_read_reg 16 1186 "TRIGGER_CTRL"

	echo "Basic Info Registers"
        ap1302_read_reg 16 0000 "CHIP_VERSION_REG"
        ap1302_read_reg 16 0002 "FRAME_CNT"
        ap1302_read_reg 16 0004 "MANUFACTURER_ID"
        ap1302_read_reg 16 0006 "ERROR"
        ap1302_read_reg 16 0042 "FW_ID"
        ap1302_read_reg 16 0044 "HINF_STATUS"
        ap1302_read_reg 16 004e "FW_REVISION_NUMBER"
        ap1302_read_reg 16 0050 "REVISION_NUMBER"
        ap1302_read_reg 32 000054 "CPU_FREQ"
        ap1302_read_reg 32 000058 "IPIPE_FREQ"
        ap1302_read_reg 32 00005C "SINF_FREQ"
        ap1302_read_reg 32 000060 "HINF_FREQ"
        ap1302_read_reg 32 000068 "HINF_MIPI_FREQ"
        ap1302_read_reg 32 00006c "IP_FREQ"
        ap1302_read_reg 32 000074 "SENSOR_INPUT_FREQ"
        ap1302_read_reg 32 000078 "SENSOR_PIXEL_FREQ"
        ap1302_read_reg 32 00007C "SENSOR_OUTPUT_FREQ"

        ap1302_read_reg 16 00C0 "SENSOR_WIDTH_PHY"
        ap1302_read_reg 16 00C2 "SENSOR_HEIGHT_PHY"
        ap1302_read_reg 16 00C4 "SENSOR_WIDTH"
        ap1302_read_reg 16 00C6 "SENSOR_HEIGHT"
        ap1302_read_reg 16 00C8 "SENSOR_X0"
        ap1302_read_reg 16 00CA "SENSOR_Y0"
        ap1302_read_reg 16 00CC "SENSOR_X1"
        ap1302_read_reg 16 00CE "SENSOR_Y1"

        ap1302_read_reg 16 00D0 "SENSOR_SELECT_CUR"
        ap1302_read_reg 16 00D2 "SENSOR_ADR"
        ap1302_read_reg 32 0000D4 "SENSOR_LINE_TIME_CLK"
        ap1302_read_reg 32 0000D8 "SENSOR_LINE_TIME"
        ap1302_read_reg 32 0000DC "SENSOR_FRAME_TIME_CLK"
        ap1302_read_reg 32 0000E0 "SENSOR_FRAME_TIME"
        ap1302_read_reg 32 000074 "SENSOR_INPUT_FREQ"
        ap1302_read_reg 32 000078 "SENSOR_PIXEL_FREQ"
        ap1302_read_reg 16 007c "SENSOR_OUTPUT_FREQ"

        ap1302_read_reg 16 0080 "CURRENT_CTRL"
        ap1302_read_reg 16 0084 "OUT0_WIDTH"
        ap1302_read_reg 16 0086 "OUT0_HEIGHT"

	echo
        ap1302_read_reg 16 01B2 "AF_STATUS"
	echo
        ap1302_read_reg 16 0186 "AE_BV"
        ap1302_read_reg 16 0198 "AE_ISO"

        ap1302_read_reg 16 03D8 "FRAME_RATE_SCENE_MODE"

        ap1302_read_reg 32 000e34 "UPTIME_SEC"

	echo
        ap1302_read_reg 16 6004 "WARNING_0"
        ap1302_read_reg 16 6006 "WARNING_1"
        ap1302_read_reg 16 6008 "WARNING_2"
        ap1302_read_reg 16 600a "WARNING_3"
        ap1302_read_reg 16 600c "SENSOR_SELECT"
        ap1302_read_reg 32 006024 "SYSTEM_FREQ_IN"
        ap1302_read_reg 32 006034 "HINF_MIPI_FREQ_TGT"

	echo
        ap1302_read_reg 16 601a "SYS_START"
        ap1302_read_reg 16 6124 "MIN_FW_BLANK_TIME"
        ap1302_read_reg 32 00602c "PLL_0_DIV"
        ap1302_read_reg 32 006038 "PLL_1_DIV"

	echo
        ap1302_read_reg 32 200008 "ADV_SYS_DIV_EN"
        ap1302_read_reg 32 20000C "ADV_SYS_CLK_EN_0"
        ap1302_read_reg 32 200010 "ADV_SYS_CLK_EN_1"
        ap1302_read_reg 32 200018 "ADV_SYS_RST_EN_1"
        ap1302_read_reg 32 200024 "ADV_SYS_CPU"
        ap1302_read_reg 32 210000 "ADV_CLGEN_DIV_SYS"
        ap1302_read_reg 32 210004 "ADV_CLGEN_DIV_SINF"
        ap1302_read_reg 32 210008 "ADV_CLGEN_DIV_HINF"
        ap1302_read_reg 32 21000c "ADV_CLGEN_DIV_HINF_MIPI"
        ap1302_read_reg 32 210010 "ADV_CLGEN_DIV_IP"
        ap1302_read_reg 32 210014 "ADV_CLGEN_PLL_0_DIV"
        ap1302_read_reg 32 210018 "ADV_CLGEN_PLL_0_SS"
        ap1302_read_reg 32 210028 "ADV_CLGEN_PLL_1_DIV"
        ap1302_read_reg 32 21002c "ADV_CLGEN_PLL_1_SS"
        ap1302_read_reg 32 210040 "ADV_CLGEN_PLL_SELECT"
        ap1302_read_reg 32 210044 "ADV_CLGEN_PLL_SELECT_2"
        ap1302_read_reg 32 210048 "ADV_CLGEN_PLL_SELECT_3"
        ap1302_read_reg 32 21004C "ADV_CLGEN_DIV_HINF_REG"
        ap1302_read_reg 32 210050 "ADV_CLGEN_DIV_SENS_REF_1"
        ap1302_read_reg 32 490040 "ADV_CAPTURE_A_FV_CNT"

        ap1302_read_reg 32 800000 "ADV_PATH_HINF_DEMUX"
        ap1302_read_reg 32 810000 "ADV_INTERLEAVE_CTRL"
        ap1302_read_reg 32 810004 "ADV_INTERLEAVE_SIZE_0"
        ap1302_read_reg 32 810008 "ADV_INTERLEAVE_SIZE_1"
        ap1302_read_reg 32 830000 "ADV_HINF_BT656_CTL"
        ap1302_read_reg 32 830004 "ADV_HINF_BT656_CLK"
        ap1302_read_reg 32 840000 "ADV_HINF_MIPI_CTL"
        ap1302_read_reg 32 840004 "ADV_HINF_MIPI_LP"
        ap1302_read_reg 32 840008 "ADV_HINF_MIPI_T0"
        ap1302_read_reg 32 84000c "ADV_HINF_MIPI_T1"
        ap1302_read_reg 32 840010 "ADV_HINF_MIPI_T2"
        ap1302_read_reg 32 840014 "ADV_HINF_MIPI_T3"
        ap1302_read_reg 32 840018 "ADV_HINF_MIPI_T4"
        ap1302_read_reg 32 840084 "ADV_HINF_MIPI_PAD_DLY"
        ap1302_read_reg 32 8400F0 "ADV_HINF_MIPI_SG_CONFIGURATION"
        ap1302_read_reg 32 85008C "ADV_HINF_MIPI_INTERNAL_LANE_CLK_CTL"

	return 0 
}
