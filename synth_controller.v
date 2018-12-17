`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2018 10:56:57 AM
// Design Name: 
// Module Name: synth_controller
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


module synth_controller(input clk, rst, input [9:0] value, output [7:0] pwm_value );

// note frequency = fsysclk / (value * number of sine wave points)
// f = 100MHz / (value * 1024)
// value = 100MHz / (f * 1024)

reg [9:0] addr; // Address in our sine wave table
reg [9:0] count; // Read rate

// Instantiate my SIN ROM
// Want to access the addresses in this block at a certain rate to recreate 
// our sine wave on our speaker
blk_mem_gen_1 SINROM (clk, addr, pwm_value);

// address incrementer
always @ (posedge clk, posedge rst) begin
    if (rst) begin
        addr <= 0;
        count <= 0;
    end
    else begin
        count <= count + 1;
        // This increments our counter, when we get to the value
        // (value defined by frequency for the key_code)
        // move to the next sine wave point
        if (count == value) begin
            addr <= addr + 1;
            count <= 0;
        end
    end
end

endmodule
