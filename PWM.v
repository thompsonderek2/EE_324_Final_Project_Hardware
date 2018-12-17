`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2018 10:37:26 AM
// Design Name: 
// Module Name: PWM
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


module PWM( input clk, rst, input [7:0] data, output pwm_out );

reg [7:0] count;
reg [7:0] total; // counts from 0 - T

// This block creates a variable width duty cycle PWM signal on an input data
// pwm_out will be a square wave of duty_cycle = (data / (2^8 - 1))
always @(posedge clk, posedge rst) begin
    if (rst) begin
        total <= 0;
        count <= 0;
    end
    else begin
        total <= total + 1;
        if (total == 0) begin
            count <= data;
        end
        else if (count != 0) begin
            count <= count - 1;
        end
    end 
end

assign pwm_out = count ? 1'b1 : 1'b0;

endmodule
