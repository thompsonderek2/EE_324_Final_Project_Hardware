`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WSU 
// Engineer: Daniel Aucoin
// 
// Create Date: 10/25/2018 03:39:09 PM
// Design Name: horizontalCounter
// Module Name: horizontalCounter
// Project Name: Simon Says
// Target Devices: ZYNQ XC7007S
// Tool Versions: Vivado 2018.2
// Description: Counts to certian amount to displa a given VGA resolution it is currently set
// to count to 1650 which for a 720 x 1280p once the counter reaches the value then it will
// send a signal to the vertical counter. This will allow the vertical counter to start counting.
// Modules it contains: charROM: none
// 
// Dependencies: all inputs
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module horizontalCounter(
    output [11:0] out, // to comparator and display comparator
    output reg tc,
     input clk,
     input rst
    );
    
     reg [11:0] count1 = 0;
     
    always @(posedge clk, posedge rst)begin 
    if(rst == 1) begin
          count1 <= 0;
          tc <= 0;
    end else begin
    
        if (count1 == 1649) begin
            tc <= 1;
        end else begin 
            tc <= 0;
        end
        
        if (count1 == 1650) begin
          count1 <= 0; // rollover counter 
        end else begin
          count1 <= count1 + 1;
        end
        
    end
    end
       assign out = count1;  
endmodule
