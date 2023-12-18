`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2023 10:20:00 PM
// Design Name: 
// Module Name: addr_calc
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


module addr_calc(input          [9:0]   DrawX, DrawY,
                 output logic   [17:0]  Addrb,          // for frame buffer
                 output logic           FB_OEB,
                 output logic   [5:0]   reg_addr,       // for slv_reg
                 output logic   [9:0]   DrawY_off       // extend DrawY to ensure correct value calculations
                 );

    parameter [9:0] game_width  = 10'b0101000000;    // 320: width of game shown on screen
    parameter [9:0] h_start     = 10'b0010100000;    // 160: the starting pixel in the horizontal direction
    parameter [9:0] h_end       = 10'b0111011111;    // 479: the ending pixel in the horizontal direction
    parameter [9:0] txt_end_x   = 10'd159;           // 159: left one-fourth of screen allocated for text
    parameter [9:0] txt_start_y = 10'd288;           // 288: vertical starting position for text
    parameter [9:0] txt_end_y   = 10'd479;           // 479: the vertical end of the screen -> 192 pixels vertically for txt
    
    logic [9:0] txt_y;                               // vertical starting point of text (offset taken into consideration)
    assign txt_y = DrawY - txt_start_y;              // should only access slv_reg[0] when DrawY = 288
    assign DrawY_off = txt_y;                        // pass on the offsetted DrawY to AXI interface's register to help with font_rom addr computation
                                                     
    always_comb
    begin
        Addrb = 17'b0;                     // output 0 as default value
        FB_OEB = 1'b0;                     // don't read the frame buffer unless pixel is within range
        
        reg_addr = 6'b0;                   // output 0 as default value
        
        // frame buffer
        if(h_start <= DrawX && DrawX <= h_end)
        begin
            FB_OEB = 1'b1;
            Addrb = DrawY * game_width + (DrawX - h_start);     // row*320 + col (all with respect to the displayed frame)
        end
        
        // text
        if(DrawX <= txt_end_x && txt_start_y <= DrawY && DrawY <= txt_end_y)    // no need to check 0 <= DrawX ?
        begin
            reg_addr = (txt_y[9:5] * 10) + DrawX[9:4];          // arithmetic logic: (DrawY/32)*10 + (DrawX/16) [note: *10 because 10 chars per line]
        end
    end

endmodule

/*                 
    if ( 160 <= drawX && drawX <= 479)
        DRAW:
        OEB = 1'b1;
        ADDR = drawY*320 + (drawX - 160)  
*/








