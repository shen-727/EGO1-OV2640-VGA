-makelib ies_lib/xil_defaultlib -sv \
  "C:/Users/SJQ/App/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "C:/Users/SJQ/App/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../OV2640_SRAM_VGA.srcs/sources_1/ip/pll_clock/pll_clock_clk_wiz.v" \
  "../../../../OV2640_SRAM_VGA.srcs/sources_1/ip/pll_clock/pll_clock.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

