`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/05 16:39:38
// Design Name: 
// Module Name: ov2640_ctrl
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


module ov2640_ctrl(
    input cam_pclk,
    input rst,
    output reg [1:0] led
    );

    always @(posedge cam_pclk or posedge rst) begin
        if(rst)begin
            led <= 2'b01;
        end
        else begin
            led <= ~ led;
        end
    end
endmodule



module SCCB_write_3P (
    input clk_100M,
    input rst,
    input send_sign,
    input [15:0] send_data,
    inout sio_d,
    output reg sio_c,
    output reg send_over,
    output reg led
);

    parameter WRITE_ID_ADDR = 8'h60;

    reg  [23:0] data;

    // assign {REG_ADDR,REG_VAULE} = send_data;

    parameter MAX_TIME_CNT = 8'd150;        //一个时钟周期10ns，150个周期1.5us，满足大于1.3us的要求
    reg [7:0] wait_time;
    reg [7:0] data_counter;
    reg read;
    reg write_data;

    assign sio_d = read ? 1'bz : write_data;

    parameter   WAIT_SEND_SIGN  = 8'd0,     //等待发送，准备状态
                START_STAT1     = 8'd1,     //启动通讯，sio_c高电平，sio_d低电平
                START_STAT2     = 8'd2,     //启动通讯，sio_c低电平，sio_d低电平
                PULL_CLK        = 8'd3,     //拉低时钟，sio_c低电平，sio_d保持
                CHAGE_DATA      = 8'd4,     //变更数据，sio_c低电平，sio_d切换下一位数据
                SEND_DATA       = 8'd5,     //发送数据，sio_c高电平，sio_d保持
                END_STAT1       = 8'd6,     //结束通讯，sio_c高电平，sio_d低电平
                END_STAT2       = 8'd7,     //结束通讯，sio_c高电平，sio_d高电平
                WAIT_STAT       = 8'd8;     //延时等待
    
    reg [7:0] present_status,next_status;

    always @(posedge clk_100M or posedge rst) begin
        if(rst)begin
            read  <= 0;
            sio_c <= 1;
            write_data <= 1;
            wait_time <= 0;
            data_counter <= 0;
            send_over <= 0;
            present_status <= WAIT_SEND_SIGN;
        end
        else begin
            case (present_status)
                WAIT_SEND_SIGN: begin
                    data <= {WRITE_ID_ADDR,send_data};
                    if(send_sign)begin
                        present_status <= START_STAT1;
                    end
                    else begin
                        present_status <= WAIT_SEND_SIGN;
                    end
                    data_counter <= 1;
                    write_data <= 1;
                    sio_c <= 1;
                    read  <= 0;
                end
                START_STAT1:begin
                    present_status <= WAIT_STAT;
                    next_status <= START_STAT2;
                    wait_time <= MAX_TIME_CNT;
                    write_data <= 0;
                    sio_c <= 1;
                    read  <= 0;
                end
                START_STAT2:begin
                    present_status <= WAIT_STAT;
                    next_status <= PULL_CLK;
                    wait_time <= MAX_TIME_CNT;
                    write_data <= 0;
                    sio_c <= 0;
                    read  <= 0;
                end
                PULL_CLK:begin
                    present_status <= WAIT_STAT;
                    next_status <= CHAGE_DATA;
                    wait_time <= MAX_TIME_CNT; //可以适当改短一些
                    write_data <= write_data;
                    sio_c <= 0;
                    read  <= 0;
                end
                CHAGE_DATA:begin
                    present_status <= WAIT_STAT;
                    // next_status <= SEND_DATA;
                    wait_time <= MAX_TIME_CNT;
                    data_counter <= data_counter + 1;
                    write_data <= data[23];
                    sio_c <= 0;
                    if (data_counter == 9 || data_counter == 18 || data_counter == 27) begin
                        read <= 1;
                    end
                    else begin
                        data <= {data[22:0],data[23]};
                        read <= 0;
                    end
                    if (data_counter == 28) begin
                        next_status <= END_STAT1;
                    end
                    else begin
                        next_status <= SEND_DATA;
                    end
                end
                SEND_DATA:begin
                    present_status <= wait_time;
                    next_status <= PULL_CLK;
                    wait_time <= MAX_TIME_CNT;
                    write_data <= write_data;
                    sio_c <= 1;
                end
                END_STAT1:begin
                    present_status <=  WAIT_STAT;
                    next_status <= END_STAT2;
                    
                end
                END_STAT2:begin
                    
                end


                WAIT_STAT:begin
                    if (wait_time == 0) begin
                        present_status <= next_status;
                    end
                    else begin
                        wait_time <= wait_time - 1;
                    end
                end
                default: begin
                    present_status <= next_status;
                end
            endcase
        end
    end



endmodule
