`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WSU 
// Engineer: Daniel Aucoin
// 
// Create Date: 10/25/2018 03:39:09 PM
// Design Name: horizontalComparator
// Module Name: horizontalComparator
// Project Name: Simon Says
// Target Devices: ZYNQ XC7007S
// Tool Versions: Vivado 2018.2
// Description: This module controls when to turn on the Horizontal Sync which is 96 pixals 
// Modules it contains:  none
// 
// Dependencies: all inputs
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module horzComparator(
    input [11:0] countIn,
    output reg horzSync
    );
    
    
     
    always @ (countIn) begin 

        if(countIn >= 0 && countIn <= 40) begin 
            horzSync <= 1;         
         end else begin
            horzSync <= 0; // horzSync on for 96 pixal counts
         end
        
        
    end 
    
    
endmodule
