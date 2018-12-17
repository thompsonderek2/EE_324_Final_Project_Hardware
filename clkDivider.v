`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2018 09:01:31 AM
// Design Name: 
// Module Name: clkDivider
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


module clkDivider(
    input rst, // connect to reset btn
    input clk_in, // connect to system 100 MHZ clock
    output clk_out1 // 25Mhz clk
    );

    
    // 74.25MHz
       always @ (posedge rst) begin
        
        
       end 
       assign clk_out1 = clk_in;
endmodule
