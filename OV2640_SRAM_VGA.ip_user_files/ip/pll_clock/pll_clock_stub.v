// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sat Jun 10 10:53:17 2023
// Host        : DESKTOP-ATCH8V2 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/SJQ/Data/FPGA_Projects/OV2640_SRAM_VGA/OV2640_SRAM_VGA.srcs/sources_1/ip/pll_clock/pll_clock_stub.v
// Design      : pll_clock
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module pll_clock(clk_100M, resetn, locked, sys_clk_in)
/* synthesis syn_black_box black_box_pad_pin="clk_100M,resetn,locked,sys_clk_in" */;
  output clk_100M;
  input resetn;
  output locked;
  input sys_clk_in;
endmodule
