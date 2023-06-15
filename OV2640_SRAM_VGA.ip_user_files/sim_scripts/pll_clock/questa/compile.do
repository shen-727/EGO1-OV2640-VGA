vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv "+incdir+../../../ipstatic" \
"C:/Users/SJQ/App/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93 \
"C:/Users/SJQ/App/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 "+incdir+../../../ipstatic" \
"../../../../OV2640_SRAM_VGA.srcs/sources_1/ip/pll_clock/pll_clock_clk_wiz.v" \
"../../../../OV2640_SRAM_VGA.srcs/sources_1/ip/pll_clock/pll_clock.v" \

vlog -work xil_defaultlib \
"glbl.v"

