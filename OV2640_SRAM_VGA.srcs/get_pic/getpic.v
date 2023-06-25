`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/28 22:12:33
// Design Name: 
// Module Name: getpic
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


module getpic (
    input rst,  //重置信号
    input pclk, //摄像头内置时钟
    input href, //摄像头传输数据信号
    input vsync,      //摄像头开始/结束传输
    input [7:0]data_camera,     //摄像头传输数据
    input key,  //按键输入，按键按下并释放后开始捕获图像
    output reg[11:0]data_out,   //得到的RGB数据
    output reg write_ready,     //写有效信号
    output reg write_ce,        //sram片选使能信号
    output reg[18:0]now_addr,    //数据传输地址
    output reg write_over  //写入完成信号
    );

    reg [15:0] rgb565 = 0;
    reg [18:0] next_addr = 0;
    reg [1:0] stat=0;     //状态机表示当前状态
    parameter stat0=2'd0;      //初始状态
    parameter stat1=2'd1;      //8位有效
    parameter stat2=2'd2;      //16位有效
    
    reg get_ready;          //开始帧开始信号

    reg [11:0] h_cnt,v_cnt;

    wire is_area = (h_cnt>120)&&(h_cnt<=520)&&(v_cnt>90)&&(v_cnt<=390);
    // wire is_area = (h_cnt<400)&&(v_cnt<=300);

    reg [1:0] key_ctrl;
    
    always@ (posedge pclk)
        begin
        if(rst==1 || vsync==0)//高电平有效
        begin
            now_addr <=11;
            next_addr <= 11;
            stat <= stat0;
            h_cnt<= 0;
            v_cnt<= 0;
            write_ce <= 1;
            write_ready <= 1;
            if (rst) begin
                write_over <= 0;
                key_ctrl <= 0;
            end
            if(vsync==0)begin
                case (key_ctrl)
                    0:begin
                        if(key)begin
                            key_ctrl <= 1;
                        end
                        else begin
                            key_ctrl <= 0;
                        end
                    end
                    1:begin
                        if(~key)begin
                            key_ctrl <= 0;
                            write_over <= 0;
                        end
                        else begin
                            key_ctrl <= 1;
                        end
                    end
                    default:begin
                        key_ctrl <= 0;
                    end
                endcase
                
                // if(key)begin
                //     write_over <= 0;
                // end
            end
        end
        else
        begin
            if(write_over == 0)
            begin
                now_addr <= next_addr;
                rgb565 <= {rgb565[7:0], data_camera};
                // data_out <= {rgb565[15:12],rgb565[10:7],rgb565[4:1]};
                data_out <= {rgb565[4:1],rgb565[10:7],rgb565[15:12]};
                case(stat)
                    stat0:
                    begin
                        if(href)
                            stat<=stat1;
                        else
                            stat<=stat0;
                        write_ready<=1;
                        write_ce<=1;
                    end
                    stat1:
                    begin
                        stat<=stat2;
                        write_ready<=1;
                        write_ce<=1;
                    end
                    stat2:
                    begin
                        if(href)
                            stat=stat1;
                        else
                            stat=stat0;
                        write_ready<=0;
                        write_ce<=0;
                        if(is_area)begin
                            next_addr <= next_addr+1;
                        end

                        if(h_cnt<639)begin
                            h_cnt <= h_cnt + 1;
                        end
                        else begin
                            h_cnt <= 0;
                            v_cnt <= v_cnt + 1;
                        end
                    end
                endcase
            end

            if (now_addr == 12_00_11) begin
                write_over <= 1;
            end
        end
    end

endmodule
