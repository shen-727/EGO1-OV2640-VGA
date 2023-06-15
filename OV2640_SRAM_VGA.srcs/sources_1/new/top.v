`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/05 16:39:38
// Design Name: 
// Module Name: top
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


module top(
    input sys_clk_in,
    input sys_rst_n,
    input capture,
    // CAM====================
    input cam_pclk,
    input cam_vs,
    input cam_hs,
    input [7:0] cam_data,
    inout cam_SDA,
    output cam_SCL,
    output cam_rst_n,
    output cam_pwdn,
    // SRAM===================
    output sram_ce_n,
    output sram_lb_n,
    output sram_oe_n,
    output sram_ub_n,
    output sram_we_n,
    output [18:0] sram_addr,
    inout  [15:0] sram_data,
    // VAG====================
    output vga_hs_pin,
    output vga_vs_pin,
    output [11:0] vga_data_pin,
    // LED_test================
    output reg [2:0] led
    );

    wire clk_100M,clk_25M;
    wire locked,rst;
    wire write_over;
    wire sram_ce_n_write;
    wire sram_we_n_write;
    wire [11:0] data_out;
    wire [15:0] write_data;
    wire [18:0] read_addr;
    wire [18:0] write_addr;


    assign rst = ~ locked;

    // SRAM读写信号控制
    // assign sram_data = write_over ? 16'bz : write_data;
    // assign sram_addr = write_over ? read_addr : write_addr;
    // assign sram_oe_n = write_over ? 1'b0 : 1'b1;
    // // assign sram_oe_n = (~ write_over);
    // assign sram_ce_n = write_over ? 1'b0 : sram_ce_n_write;
    // // assign sram_ce_n = (~ write_over) & sram_ce_n_write;
    // assign sram_we_n = write_over ? 1'b1 : sram_we_n_write;
    // // assign sram_we_n = write_over | sram_we_n_write;

    // assign sram_lb_n = 1'b0;
    // assign sram_ub_n = 1'b0;

    // OV2640重置和掉电
    // assign cam_rst_n = sys_rst_n;
    // assign cam_pwdn  = 1'b0;


    always @(posedge clk_100M) begin
            led[1:0] = {cam_vs,cam_hs};
            led[2] = write_over;
    end


    pll_clock PLL
    (
        // Clock out ports
        .clk_100M(clk_100M),     // output clk_100M
        // Status and control signals
        .resetn(sys_rst_n), // input resetn
        .locked(locked),       // output locked
        // Clock in ports
        .sys_clk_in(sys_clk_in));      // input sys_clk_in

    vga_show VGA(
        .clk_100M(clk_100M),
        .rst(rst),
        .write_over(write_over),
        .sram_data(sram_data),
        .hsync_pin(vga_hs_pin),
        .vsync_pin(vga_vs_pin),
        .sram_addr(read_addr),
        .vga_bgr_data(vga_data_pin)
    );


    camera CAM_INIT(
        // .clk(clk_25M),
        .clk(clk_100M),
        .rst(rst),
        .sio_c(cam_SCL),
        .sio_d(cam_SDA),
        .reset(cam_rst_n),
        .pwdn(cam_pwdn)
    );


    assign write_data = {4'hf,data_out};

    getpic CAPTURE(
        .rst(rst),  //重置信号
        .pclk(cam_pclk), //摄像头内置时钟
        .href(cam_hs), //摄像头传输数据信号
        .vsync(cam_vs),      //摄像头开始/结束传输
        .data_camera(cam_data),     //摄像头传输数据
        // input [3:0]bluetooth_dealed,   //蓝牙数据
        .data_out(data_out),   //得到的RGB数据
        .write_ready(sram_we_n_write),     //写有效信号
        .write_ce(sram_ce_n_write),   //片选有效信号
        .now_addr(write_addr),  //数据传输地址
        .write_over(write_over), //写入完成信号
        .key(capture)
        );



    sram_ctrl SRAM_CTRL(
        .write_over(write_over),
        .sram_ce_n_write(sram_ce_n_write),
        .sram_we_n_write(sram_we_n_write),
        .read_addr(read_addr),
        .write_addr(write_addr),
        .write_data(write_data),
        .sram_data(sram_data),
        .sram_ub_n(sram_ub_n),
        .sram_lb_n(sram_lb_n),
        .sram_ce_n(sram_ce_n),
        .sram_we_n(sram_we_n),
        .sram_oe_n(sram_oe_n),
        .sram_addr(sram_addr)
        );


    // data_gen_test GEN(
    //     clk_100M,
    //     rst,
    //     write_over,
    //     sram_ce_n_write,
    //     sram_we_n_write,
    //     write_addr,
    //     write_data
    // );
    
endmodule
