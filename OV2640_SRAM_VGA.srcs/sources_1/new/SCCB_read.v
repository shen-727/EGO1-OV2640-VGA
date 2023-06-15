`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/06 09:29:27
// Design Name: 
// Module Name: SCCB_read
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


module SCCB_read(
    input clk_100M,
    input rst,
    inout sio_d,
    output reg sio_c,
    output reg [7:0] data,
    output pwdn,
    output reset
    );

    assign pwdn = 0;
    assign reset = 1;


    parameter ID_ADDR   = 8'h61 ;
    parameter SUB_ADDR  = 8'hFF ;
    parameter MAX_CNT   = 8'd150 ;

    parameter WRITE_MODE    = 8'd0,
              READ_MODE     = 8'd1,
              START_1       = 8'd2,
              START_2       = 8'd3,
              CHANGE_READY  = 8'd4,
              DATA_CHANGE   = 8'd5,
              DATA_OUTPUT   = 8'd6,
              END_1         = 8'd7,
              END_2         = 8'd8,
              WAIt_STAT     = 8'd9;

    reg [7:0] counter;
    reg [7:0] present_status,next_status;
    reg [7:0] change_time=0;


    reg [42:0] data_temp;
    reg [7:0] data_read;

    reg read;

    always @(posedge clk_100M or posedge rst) begin
        if (rst) begin
            read <= 0;
            counter <= 0;
            sio_c <= 1;
            change_time <= 0;
            data_temp <= 43'h7ffffffffff;
            present_status <= WRITE_MODE;
        end
        else begin
            case (present_status)
                WRITE_MODE: begin
                    data_temp <= {2'b10,ID_ADDR,1'bx,SUB_ADDR,1'bx,3'b010,ID_ADDR,1'bx,8'hff,3'b001};
                    if(read) begin
                        present_status <= WRITE_MODE;
                    end
                    else begin
                        present_status <= START_1;
                    end
                end

                START_1: begin
                    present_status <= WAIt_STAT;
                    next_status <= START_2;
                    counter <= MAX_CNT;
                    if(change_time == 0)
                        change_time <=2;
                    else
                        change_time <= change_time + 2;
                    sio_c <= 1;
                end
                START_2: begin
                    data_temp <= {data_temp[41:0],1'b1};
                    present_status <= WAIt_STAT;
                    next_status <= CHANGE_READY;
                    counter <= MAX_CNT;
                    sio_c <= 1;
                end
                CHANGE_READY: begin
                    present_status <= WAIt_STAT;
                    next_status <= DATA_CHANGE;
                    counter <= MAX_CNT;
                    sio_c <= 0;
                end
                DATA_CHANGE: begin
                    data_temp <= {data_temp[41:0],1'b1};
                    present_status <= WAIt_STAT;
                    next_status <= DATA_OUTPUT;
                    counter <= MAX_CNT;
                    change_time <= change_time + 1;
                    sio_c <= 0;
                end
                DATA_OUTPUT: begin
                    present_status <= WAIt_STAT;
                    if (change_time==12) begin
                        next_status <= CHANGE_READY;
                    end
                    else begin
                        next_status <= END_1;
                    end
                    counter <= MAX_CNT;
                    sio_c <= 1;
                end


                WAIt_STAT: begin
                    if(counter == 0) begin
                        present_status <= next_status;
                    end
                    else begin
                        counter <= counter - 1;
                    end
                end
                default: begin 
                end
            endcase
        end
    end


    assign sio_d = read ? 1'bz : data_temp[42];

endmodule
