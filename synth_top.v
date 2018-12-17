`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2018 11:33:45 AM
// Design Name: 
// Module Name: synth_top
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


module synth_top( input clk, input rst, input [9:0] note_value, output audio );

wire [7:0] pwm_in;
// module synth_controller(input clk, rst, input [9:0] value, output [7:0] pwm_value );
synth_controller M1(clk, rst, note_value, pwm_in);
// module PWM( input clk, rst, input [7:0] data, output pwm_out );
PWM M2(clk, rst, pwm_in, audio);

endmodule
