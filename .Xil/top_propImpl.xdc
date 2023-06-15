set_property SRC_FILE_INFO {cfile:c:/Users/SJQ/Data/FPGA_Projects/OV2640_SRAM_VGA/OV2640_SRAM_VGA.srcs/sources_1/ip/pll_clock/pll_clock.xdc rfile:../OV2640_SRAM_VGA.srcs/sources_1/ip/pll_clock/pll_clock.xdc id:1 order:EARLY scoped_inst:PLL/inst} [current_design]
set_property SRC_FILE_INFO {cfile:C:/Users/SJQ/Data/FPGA_Projects/OV2640_SRAM_VGA/OV2640_SRAM_VGA.srcs/EGo1.xdc rfile:../OV2640_SRAM_VGA.srcs/EGo1.xdc id:2} [current_design]
current_instance PLL/inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports sys_clk_in]] 0.1
current_instance
set_property src_info {type:XDC file:2 line:229 export:INPUT save:INPUT read:READ} [current_design]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets cam_pclk_IBUF]
