`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2018 09:01:48 AM
// Design Name: 
// Module Name: mux2x1
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


module mux2x1(
    input [2:0] displayIn,
    output reg [11:0] colorOut
    );
    
    always @ (displayIn) begin
        case (displayIn)
            3'b000:colorOut <= 12'b000000000000; // ground all colors
            3'b001:colorOut <= 12'b111111110111; //turn on all white color   
            3'b010:colorOut <= 12'b110101010000;    
            3'b011:colorOut <= 12'b111111111111;
            endcase
    end
endmodule
