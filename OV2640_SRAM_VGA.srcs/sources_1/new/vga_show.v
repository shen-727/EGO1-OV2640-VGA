`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/05 16:39:38
// Design Name: 
// Module Name: vga_show
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


module vga_show(
    input clk_100M,
    input rst,
    input write_over,
    input [15:0] sram_data,
    output hsync_pin,
    output vsync_pin,
    output [18:0] sram_addr,
    output [11:0] vga_bgr_data
    );

    wire vga_clk;
    wire valid;
    wire [9:0]h_cnt;
    wire [9:0]v_cnt;

    // reg [1:0] counter ;
    // // 生成25MHz时钟，用于VGA显示
    // always @(posedge clk_100M or posedge rst) begin
    //     if (rst) begin
    //         counter <= 0;
    //     end
    //     else begin
    //         counter <= counter + 1;
    //     end
    // end

    // assign vga_clk = (counter==3);

    // 时钟产生模块
    vga_clk_gen VGA_CLK_GEN(
    .clk_100M(clk_100M),
    .rst(rst),
    .vga_clk(vga_clk)
    );

    // VGA时序标记
    vga_timing TIME_MARK(
        .vga_clk(vga_clk),
        .rst(rst),
        .hsync(hsync_pin),
        .vsync(vsync_pin),
        .valid(valid),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt)
    );

    // 显示区域控制模块
    show_area SHOW(
        .vga_clk(vga_clk),
        .write_over(write_over),
        .valid(valid),
        .h_cnt(h_cnt),
        .v_cnt(v_cnt),
        .sram_data(sram_data),
        .sram_addr(sram_addr),
        .vga_bgr_data(vga_bgr_data)
    );

endmodule


module vga_clk_gen (
    input clk_100M,
    input rst,
    output vga_clk
);
    reg [1:0] counter ;
    // 生成25MHz时钟，用于VGA显示
    always @(posedge clk_100M or posedge rst) begin
        if (rst) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end
    assign vga_clk = (counter==3);

endmodule