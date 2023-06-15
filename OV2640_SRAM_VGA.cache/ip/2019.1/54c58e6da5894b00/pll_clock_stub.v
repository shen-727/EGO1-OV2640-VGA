// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Thu Jun  8 19:39:20 2023
// Host        : DESKTOP-ATCH8V2 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ pll_clock_stub.v
// Design      : pll_clock
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk_100M, clk_25M, resetn, locked, sys_clk_in)
/* synthesis syn_black_box black_box_pad_pin="clk_100M,clk_25M,resetn,locked,sys_clk_in" */;
  output clk_100M;
  output clk_25M;
  input resetn;
  output locked;
  input sys_clk_in;
endmodule
