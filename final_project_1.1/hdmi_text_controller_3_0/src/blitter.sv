`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2023 05:55:39 PM
// Design Name: 
// Module Name: blitter
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


module blitter(
                input         [31:0]  loco_data,
                input                 rst,
                input                 vblank,
                // background
                input                 fb_bkg,           // enable for background drawing
                input         [9:0]   DrawY,            // y-position on display
                input         [2:0]   BKG_data,
                input         [8:0]   BKG_X,            // count from counter 1
                output logic          BKG_s,
                output logic  [15:0]  BKG_addr,         // read BKG_rom data
                // sprite
                input         [2:0]   rom_data,         // sprite pixel-wise palette index
                input         [4:0]   spriteX, spriteY, // indicate which sprite bit is being drawn
                input                 fb_en,            // enable for sprite drawing
                output logic  [9:0]   sprt_addr,        
                output logic  [4:0]   sprt_s,           // sprite select: used to select which sprite to draw
                // frame buffer
                output logic  [17:0]  fb_addr,          // addr for FRAME BUFFER: NEEDS 153,600 (320*480) addr -> 18 bits
                output logic          fb_wea,           // use for both ena and wea
                output logic  [7:0]   pixel             // data for each pixel
              );
    
    //logic        draw;              // 1 if background hould be overwritten
    logic  [15:0]  reg_mv;             // helps bkg seem as if moving
    logic  [15:0]  y_mod;              // result after subtraction
    logic  [15:0]  bkgY;               // vertical value used to calc BKG_addr
    logic  [8:0]   fb_addr_y;          // force the sum of loco_data.y + spriteY to 9 bits only
    logic  [15:0]  test;               // FOR TESTBENCH
    
    // sprite_rom inputs
    assign sprt_addr = {spriteY, 5'b0} + {5'b0, spriteX};   // spriteY * 32 + spriteX (row*32 + col)
    assign sprt_s = loco_data[22:18];                       // sprite number is encoded from bit 24:20
    
    // BKG_rom inputs
    assign test = DrawY%120;                                // FOR TESTBENCH
    assign y_mod = {9'b0, {(DrawY % 120)}} + reg_mv;
    assign BKG_s = loco_data[0];                            // loco_data obtained from addr 0x0
    //assign BKG_addr = (DrawY % 120) * 320 + BKG_X;
    
    // frame buffer sprite inputs
    assign fb_addr_y = (loco_data[8:0] + {4'b0, spriteY});  // force the sum of loco_data.y + spriteY to 9 bits only
    
    always_ff @ (posedge vblank or posedge rst)
    begin
        if(rst)
            reg_mv <= 16'h0000;
        else if((reg_mv + 16'hFFFF) == 16'hFF88)    // if reg_mv will become -120, set it back to 0
            reg_mv <= 16'h0000;
        else
            reg_mv <= reg_mv + 16'hFFFF;            // for each new frame, subtract one
//            reg_mv <= reg_mv;            // for each new frame, subtract one
    end
    
    always_comb
    begin      
        //draw = 1'b0;
        fb_wea = 1'b0;
        fb_addr = 18'b0;
        pixel = 8'b00000000;
        
        if(y_mod < 16'h0078)                        // if the difference does not exceed 120, there is no need to add 120
            bkgY = y_mod;
        else
            bkgY = y_mod + 16'h0078;                // else add 120 to circle it back to a value within 0~119
        
        BKG_addr = bkgY[6:0] * 320 + BKG_X;
        
        if(fb_en)
        begin
            if(loco_data[23] && (rom_data != 3'b000))            // live: 1; dead: 0
            begin
                //draw = 1'b1;
                fb_wea = 1'b1;
                fb_addr = fb_addr_y * 320 + (loco_data[17:9] + {4'b0, spriteX});            // y*320 + x
                pixel = {sprt_s, rom_data};
            end
        end
        else if(fb_bkg)
        begin
            if(BKG_data != 3'b000 || loco_data[1] != 1)         // loco_data obtained from addr 0x0
            begin
                fb_wea = 1'b1;
                fb_addr = (DrawY * 320) + BKG_X;
                pixel = {BKG_s, 4'b1111, BKG_data};             // use 01111 -> bkg1; 11111 -> bkg2
            end
        end
    end
    
    // frame buffer inputs
    //assign fb_wea = draw & fb_en;
    //assign fb_addr = (loco_data[8:0] + {4'b0, spriteY}) * 320 + (loco_data[17:9] + {4'b0, spriteX});            // y*320 + x
                                                                                                                // !!!!!! NOT SURE IF THIS ARITHMETIC WILL WORK !!!!!! 
endmodule

// for neg values
// ((DrawY % 120) + reg_mv + 120) * 320 

/*
    //parameter [10:0] addr_off = 11'b00000110010;    // for determining which sprite to draw
    
    MAY NOT NEED THIS ANYMORE: IF SPRITE IS NOW ENCODED WITH SOFTWARE TOO
    // memory map
    parameter [10:0] ship_loco   = 11'b00000000000;   // end position of ship :  0
    parameter [10:0] enemy_loco  = 11'b00000001111;   // end position of enemy:  1 ~ 15  
    parameter [10:0] bullet_loco = 11'b00000101101;   // end position of bullet: 16 ~ 45

*/











