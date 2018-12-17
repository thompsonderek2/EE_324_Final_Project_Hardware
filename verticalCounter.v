`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: WSU 
// Engineer: Daniel Aucoin
// 
// Create Date: 10/25/2018 03:39:09 PM
// Design Name: verticalCounter
// Module Name: verticalCounter
// Project Name: Simon Says
// Target Devices: ZYNQ XC7007S
// Tool Versions: Vivado 2018.2
// Description: This module counts up to
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


module verticalCounter(
    output [11:0]  out, // attached to mux and anodes of each sev_seg
    //input enable, // attached to enable of controller
    input clk,
    input rst,
    input en
    );
    
    reg [11:0] count = 0;
    always @(posedge clk, posedge rst)begin 
       // resets counter once switch 1 is on
       if(rst) begin
                count <= 0;
       end else begin
       // count begins when an enable signal is provided from the horizontal count then is 
       // counts up to 749
            if (en) begin
                if (count == 749) begin
                    count <= 0;
                end else begin
                    count <= count + 1;
                end
            end
        end 
        
    end
    assign out = count;

endmodule
