`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2023 01:59:08 PM
// Design Name: 
// Module Name: ctr_2D
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


module ctr_2D(
                input               clk, rst,
                //input  logic [4:0]  dimX, dimY,
                input               nxt_sprt,
                output logic        fb_en,
                output logic        nxt,              // indicate count down complete: input as nxt in ctr2
                output logic [4:0]  sprite_x, sprite_y
             );

    parameter [5:0] init = 6'b111111;       // indicates not counting
    parameter [5:0] dim  = 6'b011111;
    
    logic [5:0] spriteX, spriteY;
    
    assign sprite_x = spriteX[4:0];
    assign sprite_y = spriteY[4:0];

    always_ff @ (posedge clk)
    begin
        if(rst) begin
            spriteX <= init;
            spriteY <= init;
        end
        else if(nxt_sprt && spriteX == init) begin          // if dim_ctr is not in counting state
            spriteX <= 6'b000000;
            spriteY <= 6'b000000;
        end
        else if(spriteX != init)begin
            if(spriteX == dim) begin       // if spriteX has reached the end of x
                spriteX <= 6'b000000;
                if(spriteY == dim)         // if spriteY has reached the end of y
                begin
                    spriteX <= init;
                    spriteY <= init;
                end
                else
                    spriteY <= (spriteY + 1);
            end
            else
                spriteX <= (spriteX + 1);
        end
    end
    
    always_comb
    begin
        nxt = 1'b0;
        fb_en = 1'b0;
    
        if(spriteX == dim && spriteY == dim)
            nxt = 1'b1;
        if(spriteX != init)
            fb_en = 1'b1;
    end

endmodule















