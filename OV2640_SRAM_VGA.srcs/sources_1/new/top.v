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
    input change_resolution,
    // LED_test================
    output reg [3:0] led
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

    always @(posedge clk_100M) begin
            led[1:0] <= {cam_vs,cam_hs}; //行同步信号和场同步信号指示灯
            led[2] <= write_over;        //写入完成知识灯
            led[3] <= change_resolution;
    end


    pll_clock PLL
    (
        // Clock out ports
        .clk_100M(clk_100M),        // output clk_100M
        // Status and control signals
        .resetn(sys_rst_n),         // input resetn
        .locked(locked),            // output locked
        // Clock in ports
        .sys_clk_in(sys_clk_in));   // input sys_clk_in

    vga_show VGA(
        .clk_100M(clk_100M),            //时钟
        .rst(rst),                      //复位
        .write_over(write_over),        //写入完成信号
        .sram_data(sram_data),          //SRAM的16位数字信号
        .hsync_pin(vga_hs_pin),         //行同步信号
        .vsync_pin(vga_vs_pin),         //场同步信号
        .sram_addr(read_addr),          //SRAM的19位地址信号
        .vga_bgr_data(vga_data_pin),    //VGA的12位RGB信号
        .resolution(change_resolution)  //改变显示图片分辨率
    );


    camera CAM_INIT(
        .clk(clk_100M),     //时钟
        .rst(rst),          //复位信号
        .sio_c(cam_SCL),    //SCCB时钟信号
        .sio_d(cam_SDA),    //SCCB数据信号
        .reset(cam_rst_n),  //摄像头复位信号
        .pwdn(cam_pwdn)     //摄像头掉电信号
    );


    assign write_data = {4'hf,data_out};

    getpic CAPTURE(
        .rst(rst),                      //重置信号
        .pclk(cam_pclk),                //摄像头内置时钟
        .href(cam_hs),                  //摄像头传输数据信号
        .vsync(cam_vs),                 //摄像头开始/结束传输
        .data_camera(cam_data),         //摄像头传输数据
        .data_out(data_out),            //得到的RGB数据
        .write_ready(sram_we_n_write),  //写有效信号
        .write_ce(sram_ce_n_write),     //片选有效信号
        .now_addr(write_addr),          //数据传输地址
        .write_over(write_over),        //写入完成信号
        .key(capture)                   //画面捕捉触发信号
        );



    sram_ctrl SRAM_CTRL(
        .write_over(write_over),            //写入完成信号
        .sram_ce_n_write(sram_ce_n_write),  //片选使能(写入控制)
        .sram_we_n_write(sram_we_n_write),  //写入使能(写入控制)
        .read_addr(read_addr),              //读出地址
        .write_addr(write_addr),            //写入地址
        .write_data(write_data),            //写入数据
        .sram_data(sram_data),              //SRAM数据接口
        .sram_ub_n(sram_ub_n),              //SRAM数据高八位使能接口
        .sram_lb_n(sram_lb_n),              //SRAM数据低八位使能接口
        .sram_ce_n(sram_ce_n),              //SRAM片选使能接口
        .sram_we_n(sram_we_n),              //SRAM写入使能接口
        .sram_oe_n(sram_oe_n),              //SRAM输出使能接口
        .sram_addr(sram_addr)               //SRAM数据地址接口
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
