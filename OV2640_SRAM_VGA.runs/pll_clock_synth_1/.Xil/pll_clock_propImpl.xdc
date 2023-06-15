set_property SRC_FILE_INFO {cfile:c:/Users/SJQ/Data/FPGA_Projects/OV2640_SRAM_VGA/OV2640_SRAM_VGA.srcs/sources_1/ip/pll_clock/pll_clock.xdc rfile:../../../OV2640_SRAM_VGA.srcs/sources_1/ip/pll_clock/pll_clock.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports sys_clk_in]] 0.1
