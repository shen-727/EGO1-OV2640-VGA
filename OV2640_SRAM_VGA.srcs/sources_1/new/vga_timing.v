`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/05 16:47:18
// Design Name: 
// Module Name: vga_timing
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


module vga_timing(
    input vga_clk,      //25MHz时钟信号
    input rst,          //复位信号
    output hsync,       //行同步信号
    output vsync,       //场同步信号
    output valid,       //像素有效信号
    output [9:0] h_cnt, //当前像素列位置
    output [9:0] v_cnt  //当前像素行位置
    );
    parameter    h_frontporch = 96;
    parameter    h_active = 144;
    parameter    h_backporch = 784;
    parameter    h_total = 800;
    
    parameter    v_frontporch = 2;
    parameter    v_active = 35;
    parameter    v_backporch = 515;
    parameter    v_total = 525;

    reg [9:0]    x_cnt;
    reg [9:0]    y_cnt;
    
    wire         h_valid;
    wire         v_valid;

    always @(posedge rst or posedge vga_clk)
        if (rst)
            x_cnt <= 1;
        else 
        begin
            if (x_cnt == h_total)
                x_cnt <= 1;
            else
                x_cnt <= x_cnt + 1;
        end
    
    
    always @(posedge vga_clk or posedge rst)
        if (rst)
            y_cnt <= 1;
        else 
        begin
            if (y_cnt == v_total & x_cnt == h_total)
                y_cnt <= 1;
            else if (x_cnt == h_total)
                y_cnt <= y_cnt + 1;
        end
    
    assign hsync = ((x_cnt > h_frontporch)) ? 1'b1 : 1'b0;
    assign vsync = ((y_cnt > v_frontporch)) ? 1'b1 : 1'b0;
    
    assign h_valid = ((x_cnt > h_active) & (x_cnt <= h_backporch)) ? 1'b1 : 1'b0;
    assign v_valid = ((y_cnt > v_active) & (y_cnt <= v_backporch)) ? 1'b1 : 1'b0;
    
    assign valid = ((h_valid == 1'b1) & (v_valid == 1'b1)) ? 1'b1 : 1'b0;
    
    assign h_cnt = ((h_valid == 1'b1)) ? x_cnt - 144 : {10{1'b0}};
    assign v_cnt = ((v_valid == 1'b1)) ? y_cnt - 35  : {10{1'b0}};
endmodule
