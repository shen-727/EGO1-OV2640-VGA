`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/20 16:49:53
// Design Name: 
// Module Name: sccb_sim
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


module sccb_sim(

    );

    reg clk_100M;
    reg reset;
    reg reg_ready;

    reg [7:0] data_addr,data_in;

    wire sio_c;
    wire sio_d;
    wire sccb_ready;


    sccb_solve  SCCB(
    .clk(clk_100M),                 //时钟信号
    .rst(reset),                    //复位信号
    .sio_d(sio_d),                  //摄像头sio_d信号
    .sio_c(sio_c),                  //摄像头sio_c信号
    .reg_ready(reg_ready),          //寄存器配置是否完成
    .sccb_ready(sccb_ready),        //SCCB协议传输完成
    .data_addr(data_addr),          //寄存器地址
    .data_in(data_in)               //寄存器数据
    );

    initial begin
        clk_100M <= 0;
        reset <= 1;

        #100 
        reset <= 0;

    end

    always #5 clk_100M = ~clk_100M;

    always @(posedge clk_100M) begin
        if(reset)begin
            data_addr <= 8'h00;
            data_in <= 8'hF0;
        end
        else begin
            if(sccb_ready && reg_ready)begin
                data_addr <= data_addr + 1;
                data_in <= data_in + 1;
            end
            else begin
                data_addr <= data_addr;
                data_in <= data_in;
            end
        end
        reg_ready <= (data_addr < 10);
    end

endmodule
