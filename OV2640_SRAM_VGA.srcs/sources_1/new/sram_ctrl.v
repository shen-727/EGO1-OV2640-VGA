`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/09 17:01:20
// Design Name: 
// Module Name: sram_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sram_ctrl(
    input write_over,
    input sram_ce_n_write,
    input sram_we_n_write,
    input [18:0] read_addr,
    input [18:0] write_addr,
    input [15:0] write_data,
    inout [15:0] sram_data,
    output  sram_ub_n,
    output  sram_lb_n,
    output  sram_ce_n,
    output  sram_we_n,
    output  sram_oe_n,
    output  [18:0] sram_addr
    );

    assign sram_data = write_over ? 16'bz : write_data;
    assign sram_addr = write_over ? read_addr : write_addr;
    assign sram_oe_n = write_over ? 1'b0 : 1'b1;
    // assign sram_oe_n = (~ write_over);
    assign sram_ce_n = write_over ? 1'b0 : sram_ce_n_write;
    // assign sram_ce_n = (~ write_over) & sram_ce_n_write;
    assign sram_we_n = write_over ? 1'b1 : sram_we_n_write;
    // assign sram_we_n = write_over | sram_we_n_write;

    assign sram_lb_n = 1'b0;
    assign sram_ub_n = 1'b0;



endmodule
