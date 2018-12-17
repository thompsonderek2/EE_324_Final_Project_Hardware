`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2018 10:12:44 AM
// Design Name: 
// Module Name: vga_sync
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


module vga_sync(input clk, rst, 
                output reg h_sync, v_sync, 
                output video_on, 
                output reg [9:0] pix_x, pix_y, 
                output ref_tick);
                
// for VGA 640x480
// 640 + 48 + 16 + 96 = 800 - Horizontal timing
// 480 + 33 + 10 + 2 = 525 - Vertical timing

// HS counter
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            pix_x <= 0;
        end
        else begin
            pix_x <= pix_x + 1;
            if (pix_x >= 799) begin
                pix_x <= 0;
            end
        end
    end

// VS counter
    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            pix_y <= 0;
        end
        else begin
            if (pix_x >= 799) begin
                pix_y <= pix_y + 1;
                if (pix_y >= 524) begin
                    pix_y <= 0;
                end
            end
        end
    end
    
    // HS Pulse Generator
    always @ (*) begin
        if (pix_x >= 0 && pix_x <= 95) begin
            h_sync <= 1;
        end
        else begin
            h_sync <= 0;
        end
    end
    
    // VS Pulse Generator
    always @ (*) begin
        if (pix_y >= 0 && pix_y <= 1) begin
            v_sync <= 1;
        end
        else begin
            v_sync <= 0;
        end
    end

    // Video display region
    assign video_on = (pix_x >= 144 && pix_x < 784) && (pix_y >= 35 && pix_y < 515);
    
    // 60Hz Clock
    assign ref_tick = (pix_x == 799 && pix_y == 524);
                
endmodule
