`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2018 10:53:50 AM
// Design Name: 
// Module Name: vga_top
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

module vga_top( input clk, pix_clk, rst, output HS, VS, output [3:0] Red, Green, Blue );
    
    wire vid_on;
    wire [9:0] pix_x, pix_y;
    wire clk_60Hz;
    /*module vga_sync(input clk, rst, 
                output reg h_sync, v_sync, 
                output video_on, 
                output reg [9:0] pix_x, pix_y, 
                output ref_tick);*/
    vga_sync VSYNC(pix_clk, rst, HS, VS, vid_on, pix_x, pix_y, clk_60Hz);            
                
    /*module pix_gen(input clk, ref_tick, rst,
                     input video_on,
                     input [9:0] pix_x, pix_y,
                     output reg [11:0] RGB);*/
     pix_gen PGEN(clk, pix_clk, clk_60Hz, rst, vid_on, pix_x, pix_y, {Red, Green, Blue});
        
endmodule
