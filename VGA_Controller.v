`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////

// Company: WSU

// Engineer: Daniel Aucoin

//

// Create Date: 10/25/2018 03:39:09 PM

// Design Name: VGA_Controller

// Module Name: VGA_Controller

// Project Name: Simon Says

// Target Devices: ZYNQ XC7007S

// Tool Versions: Vivado 2018.2

// Description: Top level of VGA Controller

// Modules it contains: displayAreaComparator, horizontalCounter, horzComparator,

// vertComparator, and verticalCounter

//

// Dependencies: all inputs

//

// Revision:

// Revision 0.01 - File Created

// Additional Comments:

//

//////////////////////////////////////////////////////////////////////////////////

 

 

module VGA_Controller(

    input clk,

    input rom_clk,

    input btn,

    input [23:0] color_in,

    input [31:0] pic_x_loc,

    input [31:0] pic_y_loc,

    input [23:0] colorSquid,

    input [23:0] colorPlatform1,

    input [23:0] colorPlatform2,

    input [23:0] colorPlatform3,

    input [23:0] colorPlatform4,

    input [23:0] colorPlatform5,

    input [23:0] colorPlatform6,

    input [23:0] colorPlatform7,

    input [23:0] colorPlatform8,

    input [23:0] colorPlatform9,

    input [23:0] colorPlatform10,

    input [23:0] colorPlatform11,

    input [31:0] char_sel,

    input [3:0] output_sel,

    input wire [31:0] sprite1_xy,

    input wire [31:0] sprite2_xy,

    input wire [31:0] sprite3_xy,

    input wire [31:0] sprite4_xy,

    input wire [31:0] sprite5_xy,

    input wire [31:0] sprite6_xy,

    input wire [31:0] sprite7_xy,

    input wire [31:0] sprite8_xy,

    input wire [31:0] sprite9_xy,

    input wire [31:0] sprite10_xy,

    input wire [31:0] sprite11_xy,

    //input btn1,

    //output [11:0] color, // vga color

    output [7:0] red,

    output [7:0] green,

    output [7:0] blue,

    output HS, // horzontal sync

    output VS, // vertical sync

    output video_on

    );

       wire video_toggle;

       wire horzSync;

       wire vertSync;

       wire clk_out;

       wire  [2:0] mux_sel;

       wire [31:0] hCount;

       wire [31:0] vCount;

       wire tc;

       wire [7:0] color_red;

       wire [7:0] color_green;

       wire [7:0] color_blue;

       //wire [11:0] colorMux;

       //assign color = colorMux;

       assign HS = ~horzSync;

       assign VS = ~vertSync;

       assign red = color_red;

       assign blue = color_blue;

       assign green = color_green;

       assign video_on = video_toggle;

       /* input rst, // connect to reset btn

       input clk_in, // connect to system 100 MHZ clock

       output reg clk_out1 // 25Mhz clk

       ); */

        //clkDivider m1(.rst(btn), .clk_in(clk), .clk_out1(clk_out));

       

       /* module displayAreaComparator(

       input [11:0] vertCount,

       input [11:0] horzCount,

       output reg [1:0] out // goes to mux to choose rgb ground or a color value

       ); */                                                                           /**8888888888*/                                                                                                                                                                                      

  

        displayAreaComparator t(.clk(rom_clk),

        .horzCount(hCount),

        .vertCount(vCount),

        .pix_x(hCount),

        .pix_y(vCount), 

        .pic_x_loc(pic_x_loc),

        .pic_y_loc(pic_y_loc),

        .colorSquid(colorSquid),

        .colorPlatform1(colorPlatform1),

        .colorPlatform2(colorPlatform2),

        .colorPlatform3(colorPlatform3),

         .colorPlatform4(colorPlatform4),

         .colorPlatform5(colorPlatform5),

         .colorPlatform6(colorPlatform6),

         .colorPlatform7(colorPlatform7),

         .colorPlatform8(colorPlatform8),

         .colorPlatform9(colorPlatform9),

         .colorPlatform10(colorPlatform10),

         .colorPlatform11(colorPlatform11),

        .char_sel(char_sel),

        .red(color_red),

        .green(color_green),

         .blue(color_blue),

         .video_on(video_toggle),

         .output_sel(output_sel),

         .sprite1_xy(sprite1_xy),

         .sprite2_xy(sprite2_xy),

         .sprite3_xy(sprite3_xy),

         .sprite4_xy(sprite4_xy),

         .sprite5_xy(sprite5_xy),

         .sprite6_xy(sprite6_xy),

         .sprite7_xy(sprite7_xy),

         .sprite8_xy(sprite8_xy),

         .sprite9_xy(sprite9_xy),

         .sprite10_xy(sprite10_xy),

         .sprite11_xy(sprite11_xy));    

          

          

     

                 

       /* module horizontalCounter(

      output reg [11:0] out, // attached to display comparator

       output reg [1:0] tc,

        //input enable,

        input clk,

        input rst */

        horizontalCounter  ffg(.out(hCount), .tc(tc), .clk(clk), .rst(btn));

       

       /* module horzComparator(

       input [11:0] countIn,

       output reg [1:0] horzSync

       ); */

       horzComparator n(.countIn(hCount), .horzSync(horzSync));

      

       /*module mux2x1(

       input [1:0] displayIn,

       output reg [12:0] colorOut

       );  */    

       //mux2x1 b(.displayIn(mux_sel), .colorOut(colorMux));           

          /*

       module vertComparator(

       input [11:0] vertCount,

       output reg [1:0] vertSync

       );*/

       vertComparator d(.vertCount(vCount), .vertSync(vertSync));

       /*

       module verticalCounter(

        output reg [11:0] out, // attached to mux and anodes of each sev_seg

       //input enable, // attached to enable of controller

       input clk,

       input rst,

       input en

       ); */

       verticalCounter c(.out(vCount), .en(tc), .clk(clk), .rst(btn));

endmodule