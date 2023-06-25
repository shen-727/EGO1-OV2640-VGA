`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/05 17:13:03
// Design Name: 
// Module Name: show_area
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


module show_area(
    input vga_clk,
    input write_over,
    input valid,
    input [9:0]h_cnt,
    input [9:0]v_cnt,
    input [15:0] sram_data,
    output reg [19:0] sram_addr,
    output [11:0] vga_bgr_data,
    input resolution
    );

    wire is_area,area1,area2;
    reg [11:0] vgr_data;
    reg [11:0] counter = 0;

    assign area1 = (h_cnt>120)&&(h_cnt<=520)&&(v_cnt>90)&&(v_cnt<=390);
    assign area2 = (h_cnt>220)&&(h_cnt<=420)&&(v_cnt>165)&&(v_cnt<=315);

    assign is_area = resolution ? area2 : area1;

    assign vga_bgr_data = write_over ? vgr_data : 12'b0;

    always @(posedge vga_clk) begin
        if (valid) begin
            if (is_area) begin
                // sram_addr <= sram_addr + 1;
                // sram_addr <= sram_addr - 1;
                if(resolution && counter == 12'd200 - 1)begin
                    sram_addr <= sram_addr - 402;
                    counter <= 0;
                end
                else begin
                    counter <= counter + 1;
                    sram_addr <= sram_addr - 1 - resolution;
                end
                // vgr_data <= {sram_data[4:1],sram_data[10:7],sram_data[15:12]};
                vgr_data <= sram_data[11:0];
            end
            else begin
                sram_addr <= sram_addr ;
                vgr_data <= 12'h000;
            end
        end
        else begin
            vgr_data <= 12'h000;
            if(v_cnt == 0)begin
                // sram_addr <= 11;
                sram_addr <= 120010;
            end
        end
    end


endmodule
