`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/05 19:22:42
// Design Name: 
// Module Name: data_gen_test
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


module data_gen_test(
    input clk_100M,         //时钟信号
    input rst,              //复位信号
    output write_over,      //写入完成信号
    output reg sram_ce_n,   //SRAM片选使能信号
    output reg sram_we_n,   //SRAM写入使能信号
    output reg [18:0] write_addr,   //SRAM写入地址
    output reg [15:0] write_data    //SRAM写入数据
    );

    assign write_over = (write_addr == 19'd12_00_11);   //当写入12_00_00个像素点数据后，代表写入完成

    parameter   WAIT_SIGN           = 3'd0, //等待写入信号
                ADDR_DATA_CHANGE    = 3'd1, //改变写入地址
                WRITE_ENABLE        = 3'd2; //写入使能

    reg [2:0] present_status,next_status;

    reg [9:0] h_cnt,v_cnt;

    always @(posedge clk_100M or posedge rst) begin
        if(rst)begin
            present_status <= WAIT_SIGN;
        end
        else begin
            present_status <= next_status;
        end
    end

    always @(*) begin
        case (present_status)
            WAIT_SIGN:begin
                if (write_over) begin
                    next_status <= WAIT_SIGN;
                end 
                else begin
                    next_status <= ADDR_DATA_CHANGE;
                end
            end
            ADDR_DATA_CHANGE:begin
                next_status <= WRITE_ENABLE;
            end
            WRITE_ENABLE:begin
                next_status <= WAIT_SIGN;
            end
            default: begin
                next_status <= WAIT_SIGN;
            end
        endcase
    end

    always @(posedge clk_100M or posedge rst) begin
        if(rst)begin
            sram_ce_n <= 1;
            sram_we_n <= 1;
            write_data <= 16'h0;
            write_addr <= 19'd10;
            h_cnt <= 1;
            v_cnt <= 1;
        end
        else begin
            case (present_status)
                WAIT_SIGN:begin
                    sram_ce_n <= 1;
                    sram_we_n <= 1;
                    write_data <= 0;
                end
                ADDR_DATA_CHANGE:begin
                    sram_ce_n <= 1;
                    sram_we_n <= 1;
                    write_addr <= write_addr + 1;
                    if (h_cnt<400) begin
                        h_cnt <= h_cnt + 1;
                    end
                    else begin
                        h_cnt <= 1;
                        v_cnt <= v_cnt + 1;
                    end
                    if(h_cnt<=200&&v_cnt<=150)begin
                        write_data <= 16'h00ff;
                    end
                    else begin
                        write_data <= 16'h00f0;
                    end
                end
                WRITE_ENABLE:begin
                    sram_ce_n <= 0;
                    sram_we_n <= 0;
                end
                default:begin
                    sram_ce_n <= 1;
                    sram_we_n <= 1;
                end
            endcase
        end
    end





endmodule
