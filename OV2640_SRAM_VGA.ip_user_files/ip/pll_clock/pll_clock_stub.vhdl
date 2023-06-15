-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Sat Jun 10 10:53:17 2023
-- Host        : DESKTOP-ATCH8V2 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/SJQ/Data/FPGA_Projects/OV2640_SRAM_VGA/OV2640_SRAM_VGA.srcs/sources_1/ip/pll_clock/pll_clock_stub.vhdl
-- Design      : pll_clock
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pll_clock is
  Port ( 
    clk_100M : out STD_LOGIC;
    resetn : in STD_LOGIC;
    locked : out STD_LOGIC;
    sys_clk_in : in STD_LOGIC
  );

end pll_clock;

architecture stub of pll_clock is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_100M,resetn,locked,sys_clk_in";
begin
end;
