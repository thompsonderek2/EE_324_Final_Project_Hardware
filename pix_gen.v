`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2018 10:32:00 AM
// Design Name: 
// Module Name: pix_gen
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

module pix_gen(input clk, pix_clk, ref_tick, rst,
               input video_on,
               input [9:0] pix_x, pix_y,
               output reg [11:0] RGB);
 /*              
// Plain fixed object (rectangle)
// 1. define the edges of my object
localparam RECT_WIDTH = 5; // width of the rectangle (number of pixels in x-direction)
localparam RECT_LE = 600; // left edge of the object
localparam RECT_RE = RECT_LE + RECT_WIDTH - 1;

localparam RECT_HEIGHT = 72; // height of the rectangle (number of pixels in y-direction)
localparam RECT_TE = 525/2 - RECT_HEIGHT/2; // left edge of the object
localparam RECT_BE = RECT_TE + RECT_HEIGHT - 1;


// 2. Calculate the region when pix_x and pix_y are inside of the object
wire rect_on;
// if rect_on == 1, we want to draw the rectangle
assign rect_on = ((pix_x >= RECT_LE && pix_x <= RECT_RE) && 
                  (pix_y >= RECT_TE && pix_y <= RECT_BE));
                  
// 1. define the edges of my object
// "square" ball
localparam BALL_WIDTH = 16; // width of the rectangle (number of pixels in x-direction)
localparam BALL_LE = 480; // left edge of the object
localparam BALL_RE = BALL_LE + BALL_WIDTH - 1;

localparam BALL_HEIGHT = 16; // height of the rectangle (number of pixels in y-direction)
localparam BALL_TE = 525/2 - BALL_HEIGHT/2; // left edge of the object
localparam BALL_BE = BALL_TE + BALL_HEIGHT - 1;

// 2. Calculate the region when pix_x and pix_y are inside of the object
wire ball_1_on;
// if ball_1_on == 1, we want to draw the first ball
assign ball_1_on = ((pix_x >= BALL_LE && pix_x <= BALL_RE) && 
                (pix_y >= BALL_TE && pix_y <= BALL_BE));
                
// 1. define the edges of my object
// round ball
localparam BALL_R = 8; // radius of the ball
localparam BALL_XC = 380; // x-coordinate center of ball
localparam BALL_YC = 525/2; // y-coordinate center of ball

// 2. Calculate the region when pix_x and pix_y are inside of the object
wire ball_2_on;
// if ball_2_on == 1, we want to draw the second ball
assign ball_2_on = ((pix_x - BALL_XC)**2 + (pix_y - BALL_YC)**2 <= BALL_R**2);
*/
// 1. define the edges of my object
// ROM ball - Round ball image
// Similar to a rectangular object, as the stored image info will be rectangular
localparam BALL_ROM_WIDTH = 16; // width of the rectangle (number of pixels in x-direction)
localparam BALL_ROM_LE = 580; // left edge of the object
localparam BALL_ROM_RE = BALL_ROM_LE + BALL_ROM_WIDTH - 1;

localparam BALL_ROM_HEIGHT = 16; // height of the rectangle (number of pixels in y-direction)
localparam BALL_ROM_TE = 525/2 - BALL_ROM_HEIGHT/2; // left edge of the object
localparam BALL_ROM_BE = BALL_ROM_TE + BALL_ROM_HEIGHT - 1;

// 2. Calculate the region when pix_x and pix_y are inside of the object
wire ball_3_rom_on;
                        
// check to see if we are coloring the pixel inside of the ROM        
// we are inside of the 16x16 ROM object AND are inside of our circle object               
wire ball_3_on; 

// BIT == the specific data bit value of the ROM pixel
wire ball_3_bit;

// ROM_ADDR == the calculated address to get the correct row data from ROM
wire [3:0] ball_3_rom_addr;

// COL == the calculated address to get the correct column of object from the ROM
wire [3:0] ball_3_rom_col;

// ROW_DATA == the 16-bit row data from ROM object
wire [15:0] ball_3_row_data;

// instantiate my 16x16 ball ROM
// clk should be at least 2x faster than pixel clock
blk_mem_gen_0 ballROM(clk, ball_3_rom_on, ball_3_rom_addr, ball_3_row_data);

// if ball_3_rom_on == 1, we are inside the 16x16 ball rom location
assign ball_3_rom_on = ((pix_x >= BALL_ROM_LE && pix_x <= BALL_ROM_RE) && 
                        (pix_y >= BALL_ROM_TE && pix_y <= BALL_ROM_BE));

// ROM_ADDR is a 4-bit address that should be a number representing the row 0-15
// NOTE: WE DONT CARE IF WE ARE OUTSIDE OF THE IMAGE
assign ball_3_rom_addr = pix_y[3:0] - BALL_ROM_TE[3:0];

// BALL_COL is a 4-bit address that should be a number representing the col 0-15
// NOTE: WE DONT CARE IF WE ARE OUTSIDE OF THE IMAGE
assign ball_3_rom_col = pix_x[3:0] - BALL_ROM_LE[3:0];

// BIT is the specific {ROW, COLUMN} data bit from the ROM
// NOTE: WE NEED TO INVERT THE COL VALUE AS PIX_X COUNTS FROM LEFT TO RIGHT 
// HOWEVER THE DATA IS STORED RIGHT TO LEFT
assign ball_3_bit = ball_3_row_data[~ball_3_rom_col];

assign ball_3_on = ball_3_bit & ball_3_rom_on;
                 
// 3. Display the objects when in correct boundaries
localparam RECT_RGB = 12'hAAA;
localparam BALL_1_RGB = 12'hF00;
localparam BALL_2_RGB = 12'h0F0;
localparam BALL_3_RGB = 12'h00F;

always @ (*) begin
    if (~video_on) begin
        RGB <= 12'h000;
    end
    else begin
/*            RGB <= RECT_RGB;
        end*/
        if (ball_3_on) begin
            RGB <= BALL_3_RGB;
        end
      /*  else if (ball_2_on) begin
            RGB <= BALL_2_RGB;
        end
        else if (ball_1_on) begin
            RGB <= BALL_1_RGB;
        end*/
        else begin // Background
            RGB <= 12'hFFF;
        end
    end

end                               
               
endmodule

