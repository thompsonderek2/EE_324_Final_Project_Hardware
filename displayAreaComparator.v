`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////

// Company: WSU

// Engineer: Daniel Aucoin, Jessica Woods, Derek Thompson

//

// Create Date: 10/25/2018 03:39:09 PM

// Design Name: displayAreaComparator

// Module Name: displayAreaComparator

// Project Name: Simon Says

// Target Devices: ZYNQ XC7007S

// Tool Versions: Vivado 2018.2

// Description: handles what and how objects will be displayed to the screen

// Modules it contains: charROM: blk_mem_gen_0

//

// Dependencies: all inputs

//

// Revision:

// Revision 0.01 - File Created

// Additional Comments:

//

//////////////////////////////////////////////////////////////////////////////////

 

 

module displayAreaComparator(

        input clk,

        input [11:0] vertCount,

        input [11:0] horzCount,

        //##murrays inputs

        input [11:0] pix_x,

        input [11:0] pix_y,

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

        input wire [31:0] pic_x_loc,

        input wire [31:0] pic_y_loc,

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

        input wire [31:0] char_sel,

        input wire [3:0] output_sel,

        output wire [7:0] red,

        output wire [7:0] green,

        output wire [7:0] blue,

        output wire [31:0] ball_truncated_y,

        output wire [31:0] ball_truncated_x,

        output reg video_on

       

        //output reg [11:0] color_out // goes to mux to choose rgb ground or a color value

        //input tic /*********************************************/

    );

   

    reg [23:0] color_out = 0;
    reg [4:0] object_output;
   
    // 1. define the edges of my object
   
    //############################# ROM_SQUID ############################################
    // Similar to a rectangular object, as the stored image info will be rectangular
    localparam BALL_ROM_WIDTH = 32; // width of the rectangle (number of pixels in x-direction)
    localparam BALL_X_STRETCH = 2;
    localparam BALL_X_SIZE = 16*(2**BALL_X_STRETCH);
   
    // BALL_Y_STRETCH = 3, stretched by a factor of 8, BALL_Y_STRETCH = 2, stretched by a factor of 4
    localparam BALL_Y_STRETCH = 2;
    localparam BALL_Y_SIZE = 16*(2**BALL_Y_STRETCH);
   
    reg [31:0] BALL_ROM_LE = 0; // left edge of the object
   reg [31:0] BALL_ROM_RE = 0;
 
    localparam BALL_ROM_HEIGHT = 16; // height of the rectangle (number of pixels in y-direction)
    reg [31:0] BALL_ROM_TE = 0; // left edge of the object
    reg [31:0] BALL_ROM_BE = 0;
  
    // 2. Calculate the region when pix_x and pix_y are inside of the object
    wire ball_3_rom_on;                  
    // check to see if we are coloring the pixel inside of the ROM       
    // we are inside of the 16x16 ROM object AND are inside of our circle object               
    wire ball_3_on;
    // BIT == the specific data bit value of the ROM pixel
    wire [1:0] ball_3_bit;
    // ROM_ADDR == the calculated address to get the correct row data from ROM
    wire [3:0] ball_3_rom_addr;
    // COL == the calculated address to get the correct column of object from the ROM
    wire [3:0] ball_3_rom_col;
    // ROW_DATA == the 16-bit row data from ROM object
    wire [31:0] ball_3_row_data;
    // instantiate my 16x16 ball ROM
    // clk should be at least 2x faster than pixel clock
    blk_mem_gen_2 ballROM(clk, ball_3_rom_on, ball_3_rom_addr, ball_3_row_data);
    // if ball_3_rom_on == 1, we are inside the 16x16 ball rom location
    assign ball_3_rom_on = ((pix_x >= BALL_ROM_LE && pix_x <= BALL_ROM_RE) &&
                            (pix_y >= BALL_ROM_TE && pix_y <= BALL_ROM_BE));
    // ROMADDR is a 4-bit address that should be a number representing the row 0-15
    // NOTE: WE DONT CARE IF WE ARE OUTSIDE OF THE IMAGE
    assign ball_truncated_y = pix_y - BALL_ROM_TE;
    assign ball_3_rom_addr = ball_truncated_y[5:2]; // if BALL_Y_STRETCH = 3, [6:3]; if BALL_Y_STRETCH = 2, [5:2];
 
   
    // BALL_COL is a 4-bit address that should be a number representing the col 0-15
    // NOTE: WE DONT CARE IF WE ARE OUTSIDE OF THE IMAGE
    assign ball_truncated_x = pix_x - BALL_ROM_LE;
    assign ball_3_rom_col = ball_truncated_x[5:2]; // if BALL_X_STRETCH = 3, [6:3]; if BALL_X_STRETCH = 2, [5:2];
 
    // BIT is the specific {ROW, COLUMN} data bit from the ROM
    // NOTE: WE NEED TO INVERT THE COL VALUE AS PIX_X COUNTS FROM LEFT TO RIGHT
    // HOWEVER THE DATA IS STORED RIGHT TO LEFT
    assign ball_3_bit = ball_3_row_data[(~ball_3_rom_col)*2+1 -: 2];
    assign ball_3_on = (ball_3_bit[0] | ball_3_bit[1]) & ball_3_rom_on;
    always @ (*) begin
     BALL_ROM_LE <= pic_x_loc; // left edge of the object
     BALL_ROM_RE <= BALL_ROM_LE + BALL_X_SIZE - 1;
     BALL_ROM_TE <= pic_y_loc; // left edge of the object
     BALL_ROM_BE <= BALL_ROM_TE + BALL_Y_SIZE - 1;
    end
   
    
    
    
     //############################# Single char ############################################
    localparam CHAR_WIDTH = 16; // width of the rectangle (number of pixels in x-direction
    localparam CHAR_LE = 464 - CHAR_WIDTH/2; // left edge of the object
    localparam CHAR_RE = CHAR_LE + CHAR_WIDTH - 1;
 
    localparam CHAR_HEIGHT = 16; // height of the rectangle (number of pixels in y-direction)
    localparam CHAR_TE = 100; // left edge of the object
    localparam CHAR_BE = CHAR_TE + CHAR_HEIGHT - 1;
    // 2. Calculate the region when pix_x and pix_y are inside of the object
    wire char_rom_on;                 
    // check to see if we are coloring the pixel inside of the ROM        
    // we are inside of the 16x16 ROM object AND are inside of our char object              
    wire char_on;
    // BIT == the specific data bit value of the ROM pixel
    wire char_bit;
    // ROM_ADDR == the calculated address to get the correct row data from ROM
    wire [10:0] char_rom_addr;
    // COL == the calculated address to get the correct column of object from the ROM
    wire [3:0] char_rom_col;
    // ROW_DATA == the 16-bit row data from ROM object
    wire [15:0] char_row_data;
    // if char_rom_on == 1, we are inside the 16x16 ball rom location
    assign char_rom_on = ((pix_x >= CHAR_LE && pix_x <= CHAR_RE) &&
                            (pix_y >= CHAR_TE && pix_y <= CHAR_BE));
    // choosing the character to display from the Character ROM
    // ROM_ADDR is a 11-bit address that should be a number representing the ascii character
    // AND the row of that ascii character 0-15
    // NOTE: WE DONT CARE IF WE ARE OUTSIDE OF THE IMAGE
    localparam CHAR_ASCII = 7'h5B;
    assign char_rom_addr = {CHAR_ASCII, (pix_y[3:0] - CHAR_TE[3:0])};
    // CHAR_COL is a 4-bit address that should be a number representing the col 0-15
    // NOTE: WE DONT CARE IF WE ARE OUTSIDE OF THE IMAGE
    assign char_rom_col = pix_x[3:0] - CHAR_LE[3:0];
    // BIT is the specific {ROW, COLUMN} data bit from the ROM
    // NOTE: WE NEED TO INVERT THE COL VALUE AS PIX_X COUNTS FROM LEFT TO RIGHT
    // HOWEVER THE DATA IS STORED RIGHT TO LEFT
    assign char_bit = char_row_data[~char_rom_col];
    assign char_on = char_bit & char_rom_on;
   
    
    
    
    
    //############################# String Char ############################################
    localparam WORD_LENGTH = 9;
    localparam WORD_WIDTH = 16*WORD_LENGTH; // width of the string
    reg [31:0] WORD_LE = 0; 
    reg [31:0] WORD_RE = 0; 
    
    localparam WORD_HEIGHT = 16; // height of the rectangle (number of pixels in y-direction)
    reg [31:0] WORD_TE = 0;  // top edge of the object
    reg [31:0] WORD_BE = 0;
    
    // 2. Calculate the region when pix_x and pix_y are inside of the object
    wire word_rom_on;                 
    // check to see if we are coloring the pixel inside of the ROM       
    // we are inside of the 16x16 ROM object AND are inside of our char object              
    wire word_on;
    // BIT == the specific data bit value of the ROM pixel
    wire word_bit;
    // ROM_ADDR == the calculated address to get the correct row data from ROM
    reg [10:0] word_rom_addr;
    // COL == the calculated address to get the correct column of object from the ROM
    wire [3:0] word_rom_col;
   // ROW_DATA == the 16-bit row data from ROM object

    wire [16:0] word_row_data;
    // if word_rom_on == 1, we are inside the word rom location
    assign word_rom_on = ((pix_x >= WORD_LE && pix_x <= WORD_RE) &&
                          (pix_y >= WORD_TE && pix_y <= WORD_BE));
   
    // choosing the character to display from the Character ROM
    // ROM_ADDR is a 11-bit address that should be a number representing the ascii character
    // AND the row of that ascii character 0-15
    // NOTE: WE DONT CARE IF WE ARE OUTSIDE OF THE IMAGE
    // "GO COUGS!"
   
    wire [9:0] word_x_l_adj;
    assign word_x_l_adj = pix_x - WORD_LE;
    
    always @ (*) begin
        word_rom_addr[3:0] <= pix_y[3:0] - WORD_TE[3:0];
        case(word_x_l_adj[9:4])
        4'b0000: word_rom_addr[10:4] <= 7'h4C;  //L
        4'b0001: word_rom_addr[10:4] <= 7'h45;  //E
        4'b0010: word_rom_addr[10:4] <= 7'h56;  //V
        4'b0011: word_rom_addr[10:4] <= 7'h45;  //E
        4'b0100: word_rom_addr[10:4] <= 7'h4C;  //L
        4'b0101: word_rom_addr[10:4] <= char_sel; //#
        default: word_rom_addr[10:4] <= 0;
        endcase
        WORD_LE <= sprite11_xy[15:0] - WORD_WIDTH/2; // left edge of the object
        WORD_RE <= WORD_LE + WORD_WIDTH - 1;
        WORD_TE <= sprite11_xy[31:16]; // top edge of the object
        WORD_BE <= WORD_TE + WORD_HEIGHT - 1;
    end
   
    // WORD_COL is a 4-bit address that should be a number representing the col 0-15
    // NOTE: WE DONT CARE IF WE ARE OUTSIDE OF THE IMAGE
    assign word_rom_col = pix_x[3:0] - WORD_LE[3:0];
    // BIT is the specific {ROW, COLUMN} data bit from the ROM
    // NOTE: WE NEED TO INVERT THE COL VALUE AS PIX_X COUNTS FROM LEFT TO RIGHT
    // HOWEVER THE DATA IS STORED RIGHT TO LEFT
    assign word_bit = word_row_data[~word_rom_col];
    assign word_on = word_bit & word_rom_on;
    // with multiple text objects instead of instantiating multiple character ROMS
    // need to mux the inputs into the character ROM
    wire text_rom_on;
    wire [10:0] text_rom_addr;
    wire [15:0] text_row_data;
    // instantiate my 16x2032 character ROM
    // clk should be at least 2x faster than pixel clock
    blk_mem_gen_0 charROM(clk, text_rom_on, text_rom_addr, text_row_data);
                    
    assign text_rom_on = char_rom_on | word_rom_on;
    assign text_rom_addr = word_rom_on ? word_rom_addr : char_rom_addr;
   
    assign char_row_data = text_row_data;
    assign word_row_data = text_row_data;
 
 
//############################# PLATFORMS ############################################
    // Similar to a rectangular object, as the stored image info will be rectangular
    localparam PLATFORM_ROM_WIDTH = 32; // width of the rectangle (number of pixels in x-direction)
    localparam PLATFORM_X_STRETCH = 3;
    localparam PLATFORM_X_SIZE = 16*(2**PLATFORM_X_STRETCH);
   
    localparam PLATFORM_Y_STRETCH = 3;
    localparam PLATFORM_Y_SIZE = 16*(2**PLATFORM_Y_STRETCH);
   
    localparam PLATFORM_ROM_HEIGHT = 16; // height of the rectangle (number of pixels in y-direction)
 
  
    reg [31:0] PLATFORM1_ROM_LE = 0; // left edge of the object
    reg [31:0] PLATFORM1_ROM_RE = 0;
    reg [31:0] PLATFORM1_ROM_TE = 0; // left edge of the object
    reg [31:0] PLATFORM1_ROM_BE = 0;
   
    reg [31:0] PLATFORM2_ROM_LE = 0; // left edge of the object
    reg [31:0] PLATFORM2_ROM_RE = 0;
    reg [31:0] PLATFORM2_ROM_TE = 0; // left edge of the object
    reg [31:0] PLATFORM2_ROM_BE = 0;
    
    reg [31:0] PLATFORM3_ROM_LE = 0; // left edge of the object
    reg [31:0] PLATFORM3_ROM_RE = 0;
    reg [31:0] PLATFORM3_ROM_TE = 0; // left edge of the object
    reg [31:0] PLATFORM3_ROM_BE = 0;
      
    reg [31:0] PLATFORM4_ROM_LE = 0; // left edge of the object
    reg [31:0] PLATFORM4_ROM_RE = 0;
    reg [31:0] PLATFORM4_ROM_TE = 0; // left edge of the object
    reg [31:0] PLATFORM4_ROM_BE = 0;
    
    reg [31:0] PLATFORM5_ROM_LE = 0; // left edge of the object
    reg [31:0] PLATFORM5_ROM_RE = 0;
    reg [31:0] PLATFORM5_ROM_TE = 0; // left edge of the object
    reg [31:0] PLATFORM5_ROM_BE = 0;
    
    reg [31:0] PLATFORM6_ROM_LE = 0; // left edge of the object
    reg [31:0] PLATFORM6_ROM_RE = 0;
    reg [31:0] PLATFORM6_ROM_TE = 0; // left edge of the object
    reg [31:0] PLATFORM6_ROM_BE = 0;
      // 2. Calculate the region when pix_x and pix_y are inside of the object
    wire platform1_rom_on;     
    wire platform2_rom_on;  
    wire platform3_rom_on;             
    wire platform4_rom_on;             
    wire platform5_rom_on;             
    wire platform6_rom_on;             
             
    // check to see if we are coloring the pixel inside of the ROM       
    // we are inside of the 16x16 ROM object AND are inside of our circle object              
    wire platform1_on;
    wire platform2_on;
    wire platform3_on;
    wire platform4_on;
    wire platform5_on;
    wire platform6_on;

    // BIT == the specific data bit value of the ROM pixel
    wire [1:0] platform1_bit;
    wire [1:0] platform2_bit;
    wire [1:0] platform3_bit;
    wire [1:0] platform4_bit;
    wire [1:0] platform5_bit;
    wire [1:0] platform6_bit;

    // ROM_ADDR == the calculated address to get the correct row data from ROM
    wire [3:0] platform1_rom_addr;
    wire [3:0] platform2_rom_addr;
    wire [3:0] platform3_rom_addr;
    wire [3:0] platform4_rom_addr;
    wire [3:0] platform5_rom_addr;
    wire [3:0] platform6_rom_addr;

    // COL == the calculated address to get the correct column of object from the ROM
    wire [3:0] platform1_rom_col;
    wire [3:0] platform2_rom_col;
    wire [3:0] platform3_rom_col;
    wire [3:0] platform4_rom_col;
    wire [3:0] platform5_rom_col;
    wire [3:0] platform6_rom_col;

    
    // ROW_DATA == the 16-bit row data from ROM object
    wire [31:0] platform1_row_data;
    wire [31:0] platform2_row_data;
    wire [31:0] platform3_row_data;
    wire [31:0] platform4_row_data;
    wire [31:0] platform5_row_data;
    wire [31:0] platform6_row_data;

 
    wire platform_rom_on;
    wire [3:0] platform_addr;
    wire [31:0] platform_data;
    
        wire platform2_rom_on_blk;
    wire [3:0] platform2_addr_blk;
    wire [31:0] platform2_data_blk;
    
    wire platform3_rom_on_blk;
    wire [3:0] platform3_addr_blk;
    wire [31:0] platform3_data_blk;

    wire platform4_rom_on_blk;
    wire [3:0] platform4_addr_blk;
    wire [31:0] platform4_data_blk;
    
        wire platform5_rom_on_blk;
    wire [3:0] platform5_addr_blk;
    wire [31:0] platform5_data_blk;
    
    
        wire platform6_rom_on_blk;
    wire [3:0] platform6_addr_blk;
    wire [31:0] platform6_data_blk;   
    
    blk_mem_gen_3 platformROM(clk, platform_rom_on, platform_addr, platform_data);
    plat_2 platform2ROM(clk,platform2_rom_on_blk, platform2_addr_blk, platform2_data_blk);
    plat_3 platform3ROM(clk,platform3_rom_on_blk, platform3_addr_blk, platform3_data_blk);
    plat_4 platform4ROM(clk,platform4_rom_on_blk, platform4_addr_blk, platform4_data_blk);
    plat_5 platform5ROM(clk,platform5_rom_on_blk, platform5_addr_blk, platform5_data_blk);
    plat_6 platform6ROM(clk,platform6_rom_on_blk, platform6_addr_blk, platform6_data_blk);
    
    assign platform_rom_on = ((pix_x >= PLATFORM1_ROM_LE && pix_x <= PLATFORM1_ROM_RE) &&
                (pix_y >= PLATFORM1_ROM_TE && pix_y <= PLATFORM1_ROM_BE));
                            
    assign platform2_rom_on_blk = ((pix_x >= PLATFORM2_ROM_LE && pix_x <= PLATFORM2_ROM_RE) &&
                (pix_y >= PLATFORM2_ROM_TE && pix_y <= PLATFORM2_ROM_BE));
          
    assign platform3_rom_on_blk = ((pix_x >= PLATFORM3_ROM_LE && pix_x <= PLATFORM3_ROM_RE) &&
             (pix_y >= PLATFORM3_ROM_TE && pix_y <= PLATFORM3_ROM_BE));
                               
    assign platform4_rom_on_blk = ((pix_x >= PLATFORM4_ROM_LE && pix_x <= PLATFORM4_ROM_RE) &&
                  (pix_y >= PLATFORM4_ROM_TE && pix_y <= PLATFORM4_ROM_BE));

   assign platform5_rom_on_blk = ((pix_x >= PLATFORM5_ROM_LE && pix_x <= PLATFORM5_ROM_RE) &&
                    (pix_y >= PLATFORM5_ROM_TE && pix_y <= PLATFORM5_ROM_BE));
  
     assign platform6_rom_on_blk = ((pix_x >= PLATFORM6_ROM_LE && pix_x <= PLATFORM6_ROM_RE) &&
                     (pix_y >= PLATFORM6_ROM_TE && pix_y <= PLATFORM6_ROM_BE));
                               
                                  
    assign platform_addr = platform1_rom_addr;
    assign platform2_addr_blk = platform2_rom_addr;
    assign platform3_addr_blk = platform3_rom_addr;
    assign platform4_addr_blk = platform4_rom_addr;
    assign platform5_addr_blk = platform5_rom_addr;
    assign platform6_addr_blk = platform6_rom_addr;


      
       
//       let message = (age < 3) ? 'Hi, baby!' :
//       (age < 18) ? 'Hello!' :
//       (age < 100) ? 'Greetings!' :
//       'What an unusual age!';
   assign platform1_row_data = platform_data;
   assign platform2_row_data = platform2_data_blk;
  assign platform3_row_data = platform3_data_blk;
   assign platform4_row_data = platform4_data_blk;
   assign platform5_row_data = platform5_data_blk;
   assign platform6_row_data = platform6_data_blk;


  
    wire [31:0] platform1_truncated_y;
    wire [31:0] platform1_truncated_x;
    
    wire [31:0] platform2_truncated_y;
    wire [31:0] platform2_truncated_x;
    
    wire [31:0] platform3_truncated_y;
    wire [31:0] platform3_truncated_x;
    
    wire [31:0] platform4_truncated_y;
    wire [31:0] platform4_truncated_x;
    
    wire [31:0] platform5_truncated_y;
    wire [31:0] platform5_truncated_x;
    
    wire [31:0] platform6_truncated_y;
    wire [31:0] platform6_truncated_x;
 
    // ROMADDR is a 4-bit address that should be a number representing the row 0-15
    // NOTE: WE DONT CARE IF WE ARE OUTSIDE OF THE IMAGE
    assign platform1_truncated_y = pix_y - PLATFORM1_ROM_TE;
    assign platform1_rom_addr = platform1_truncated_y[6:3];
   
    assign platform2_truncated_y = pix_y - PLATFORM2_ROM_TE;
    assign platform2_rom_addr = platform2_truncated_y[6:3];
    
    assign platform3_truncated_y = pix_y - PLATFORM3_ROM_TE;
    assign platform3_rom_addr = platform3_truncated_y[6:3];
    
    assign platform4_truncated_y = pix_y - PLATFORM4_ROM_TE;
    assign platform4_rom_addr = platform4_truncated_y[6:3];
    
    assign platform5_truncated_y = pix_y - PLATFORM5_ROM_TE;
    assign platform5_rom_addr = platform5_truncated_y[6:3];
    
    assign platform6_truncated_y = pix_y - PLATFORM6_ROM_TE;
    assign platform6_rom_addr = platform6_truncated_y[6:3];
    // BALL_COL is a 4-bit address that should be a number representing the col 0-15
    // NOTE: WE DONT CARE IF WE ARE OUTSIDE OF THE IMAGE
    assign platform1_truncated_x = pix_x - PLATFORM1_ROM_LE;
    assign platform1_rom_col = platform1_truncated_x[6:3];
    
    assign platform2_truncated_x = pix_x - PLATFORM2_ROM_LE;
    assign platform2_rom_col = platform2_truncated_x[6:3];
    
    assign platform3_truncated_x = pix_x - PLATFORM3_ROM_LE;
    assign platform3_rom_col = platform3_truncated_x[6:3];
     
     assign platform4_truncated_x = pix_x - PLATFORM4_ROM_LE;
    assign platform4_rom_col = platform4_truncated_x[6:3];
         
     assign platform5_truncated_x = pix_x - PLATFORM5_ROM_LE;
    assign platform5_rom_col = platform5_truncated_x[6:3];
             
     assign platform6_truncated_x = pix_x - PLATFORM6_ROM_LE;
        assign platform6_rom_col = platform6_truncated_x[6:3];
                 
    // BIT is the specific {ROW, COLUMN} data bit from the ROM
    // NOTE: WE NEED TO INVERT THE COL VALUE AS PIX_X COUNTS FROM LEFT TO RIGHT
    // HOWEVER THE DATA IS STORED RIGHT TO LEFT
    assign platform1_bit = platform1_row_data[(~platform1_rom_col)*2+1 -: 2];
    assign platform2_bit = platform2_row_data[(~platform2_rom_col)*2+1 -: 2];
    assign platform3_bit = platform3_row_data[(~platform3_rom_col)*2+1 -: 2];
    assign platform4_bit = platform4_row_data[(~platform4_rom_col)*2+1 -: 2];
    assign platform5_bit = platform5_row_data[(~platform5_rom_col)*2+1 -: 2];
    assign platform6_bit = platform6_row_data[(~platform6_rom_col)*2+1 -: 2];


    always @ (*) begin
    PLATFORM1_ROM_LE <= sprite1_xy[15:0]; // left edge of the object
    PLATFORM1_ROM_RE <= PLATFORM1_ROM_LE + PLATFORM_X_SIZE - 1;
    PLATFORM1_ROM_TE <= sprite1_xy[31:16]; // left edge of the object
    PLATFORM1_ROM_BE <= PLATFORM1_ROM_TE + PLATFORM_Y_SIZE - 1;
    end
    
    always @ (*) begin
    PLATFORM2_ROM_LE <= sprite2_xy[15:0]; // left edge of the object
    PLATFORM2_ROM_RE <= PLATFORM2_ROM_LE + PLATFORM_X_SIZE - 1;
    PLATFORM2_ROM_TE <= sprite2_xy[31:16]; // left edge of the object
    PLATFORM2_ROM_BE <= PLATFORM2_ROM_TE + PLATFORM_Y_SIZE - 1;
    end
       always @ (*) begin
    PLATFORM3_ROM_LE <= sprite3_xy[15:0]; // left edge of the object
    PLATFORM3_ROM_RE <= PLATFORM3_ROM_LE + PLATFORM_X_SIZE - 1;
    PLATFORM3_ROM_TE <= sprite3_xy[31:16]; // left edge of the object
    PLATFORM3_ROM_BE <= PLATFORM3_ROM_TE + PLATFORM_Y_SIZE - 1;
    end
        always @ (*) begin
    PLATFORM4_ROM_LE <= sprite4_xy[15:0]; // left edge of the object
    PLATFORM4_ROM_RE <= PLATFORM4_ROM_LE + PLATFORM_X_SIZE - 1;
    PLATFORM4_ROM_TE <= sprite4_xy[31:16]; // left edge of the object
    PLATFORM4_ROM_BE <= PLATFORM4_ROM_TE + PLATFORM_Y_SIZE - 1;
    end
        always @ (*) begin
    PLATFORM5_ROM_LE <= sprite5_xy[15:0]; // left edge of the object
    PLATFORM5_ROM_RE <= PLATFORM5_ROM_LE + PLATFORM_X_SIZE - 1;
    PLATFORM5_ROM_TE <= sprite5_xy[31:16]; // left edge of the object
    PLATFORM5_ROM_BE <= PLATFORM5_ROM_TE + PLATFORM_Y_SIZE - 1;
    end
        always @ (*) begin
    PLATFORM6_ROM_LE <= sprite6_xy[15:0]; // left edge of the object
    PLATFORM6_ROM_RE <= PLATFORM6_ROM_LE + PLATFORM_X_SIZE - 1;
    PLATFORM6_ROM_TE <= sprite6_xy[31:16]; // left edge of the object
    PLATFORM6_ROM_BE <= PLATFORM6_ROM_TE + PLATFORM_Y_SIZE - 1;
    end
    assign platform1_on =  (platform1_bit[0] | platform1_bit[1]) & platform_rom_on;
    assign platform2_on =  (platform2_bit[0] | platform2_bit[1]) & platform2_rom_on_blk;

   assign platform3_on =  (platform3_bit[0] | platform3_bit[1]) & platform3_rom_on_blk;
    assign platform4_on =  (platform4_bit[0] | platform4_bit[1]) & platform4_rom_on_blk;
    assign platform5_on =  (platform5_bit[0] | platform5_bit[1]) & platform5_rom_on_blk;
    assign platform6_on =  (platform6_bit[0] | platform6_bit[1]) & platform6_rom_on_blk;

    /*######################################################OUTPUT#################################################*/
    reg [23:0] SQUID_RGB; // = colorSquid;
    reg [23:0] PLAT_1_RGB; // = colorPlatform1;
    reg [23:0] PLAT_2_RGB;
    reg [23:0] PLAT_3_RGB;
    reg [23:0] PLAT_4_RGB;
    reg [23:0] PLAT_5_RGB;
    reg [23:0] PLAT_6_RGB;

    reg [23:0] LEVEL_RGB; // = colorPlatform11;
   
    always @(*) begin
        SQUID_RGB <= colorSquid;
        PLAT_1_RGB <= colorPlatform1;
        PLAT_2_RGB <= colorPlatform2;
        PLAT_3_RGB <= colorPlatform3;
        PLAT_4_RGB <= colorPlatform4;
        PLAT_5_RGB <= colorPlatform5;
        PLAT_6_RGB <= colorPlatform6;

        LEVEL_RGB <= colorPlatform11;
       
        //display area                                              
        if(horzCount >= 260 && horzCount <= 1539 && vertCount >= 25 && vertCount <= 744) begin
            // turn on video
            video_on <= 1;
            //background color
            color_out <= 24'hFFFFFF; // white background
            // location of 16x16 bit picture
            if (ball_3_on) begin
                color_out <= 24'h000000;
                case (ball_3_bit)
                    2'b00: color_out <= 24'h000000;
                    2'b01: color_out <= SQUID_RGB;
                    2'b10: color_out <= 24'hffffFF;
                    2'b11: color_out <= 24'h000000;
                    default: color_out <=  24'h000;
                endcase
            end
            else if (platform1_on) begin
                color_out <= 24'h000000;
                case (platform1_bit)
                    2'b00: color_out <= 24'h000000;
                    2'b01: color_out <= PLAT_1_RGB;
                    2'b10: color_out <= PLAT_1_RGB;
                    2'b11: color_out <= 24'h000000;
                    default: color_out <=  24'h000;
                endcase
            end
            else if (platform2_on) begin
                color_out <= 24'h000000;
                case (platform2_bit)
                    2'b00: color_out <= 24'h000000;
                    2'b01: color_out <= PLAT_2_RGB;
                    2'b10: color_out <= PLAT_2_RGB;
                    2'b11: color_out <= 24'h000000;
                    default: color_out <=  24'h000;
                endcase
            end
            else if (platform3_on) begin
                color_out <= 24'h000000;
                case (platform3_bit)
                    2'b00: color_out <= 24'h000000;
                    2'b01: color_out <= PLAT_3_RGB;
                    2'b10: color_out <= PLAT_3_RGB;
                    2'b11: color_out <= 24'h000000;
                    default: color_out <=  24'h000;
                endcase
            end
            else if (platform4_on) begin
                color_out <= 24'h000000;
                case (platform4_bit)
                    2'b00: color_out <= 24'h000000;
                    2'b01: color_out <= PLAT_4_RGB;
                    2'b10: color_out <= PLAT_4_RGB;
                    2'b11: color_out <= 24'h000000;
                    default: color_out <=  24'h000;
                endcase
            end
            else if (platform5_on) begin
                color_out <= 24'h000000;
                case (platform5_bit)
                    2'b00: color_out <= 24'h000000;
                    2'b01: color_out <= PLAT_5_RGB;
                    2'b10: color_out <= PLAT_5_RGB;
                    2'b11: color_out <= 24'h000000;
                    default: color_out <=  24'h000;
                endcase
            end
            else if (platform6_on) begin
                color_out <= 24'h000000;
                case (platform6_bit)
                    2'b00: color_out <= 24'h000000;
                    2'b01: color_out <= PLAT_6_RGB;
                    2'b10: color_out <= PLAT_6_RGB;
                    2'b11: color_out <= 24'h000000;
                    default: color_out <=  24'h000;
                endcase
            end
            else if (word_on) begin
                color_out <= 24'h000000;
                if (word_bit) begin
                    color_out <= LEVEL_RGB;
                end
            end
        end else begin
            video_on<= 0; // turn off video
        end
    end
   
    assign red = color_out [7:0];
    assign green = color_out [15:8];
    assign blue = color_out [23:15];
    //assign video_on = video_toggle;
   
      
endmodule