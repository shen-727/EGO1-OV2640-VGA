// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sat Jun 24 20:49:06 2023
// Host        : DESKTOP-ATCH8V2 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/SJQ/Data/FPGA_Projects/OV2640_SRAM_VGA/OV2640_SRAM_VGA.srcs/sources_1/ip/blk_ram/blk_ram_stub.v
// Design      : blk_ram
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_3,Vivado 2019.1" *)
module blk_ram(clka, wea, addra, dina, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[16:0],dina[3:0],clkb,addrb[16:0],doutb[3:0]" */;
  input clka;
  input [0:0]wea;
  input [16:0]addra;
  input [3:0]dina;
  input clkb;
  input [16:0]addrb;
  output [3:0]doutb;
endmodule
