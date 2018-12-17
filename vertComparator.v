`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WSU 
// Engineer: Daniel Aucoin
// 
// Create Date: 10/25/2018 03:39:09 PM
// Design Name: verticalComparator
// Module Name: verticalComparator
// Project Name: Simon Says
// Target Devices: ZYNQ XC7007S
// Tool Versions: Vivado 2018.2
// Description: This module determines when to turn on the vertical Sync which is 
// 5 pixal counts  
// Modules it contains:  none
// 
// Dependencies: all inputs
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vertComparator(
    input [11:0] vertCount,
    output reg vertSync
    );
    
    // vertical sync on for 5 pixal counts 
    always @ (vertCount) begin
        
        if(vertCount >= 0 && vertCount <=5) begin
            vertSync <= 1;
        end 
        else begin 
            vertSync <= 0; 
        end 
    end
endmodule
