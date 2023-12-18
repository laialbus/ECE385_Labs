`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2023 01:51:14 AM
// Design Name: 
// Module Name: palette_collection
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


module palette_collection(
                            input         [7:0]  pixel,                  // data from frame buffer
                            input         [9:0]  DrawX, DrawY,           // for determining whether game display should be on
                            input         [7:0]  data,                   // char data from font_rom
                            output logic  [3:0]  Red, Green, Blue
                         );
    
    parameter [4:0] ship     = 5'b00000;    // ROM 0
    parameter [4:0] pac_1    = 5'b00001;    //     1
    parameter [4:0] pac_2    = 5'b00010;    //     2
    parameter [4:0] bullet   = 5'b00011;    //     3
    parameter [4:0] bllt_inv = 5'b00100;    //     4
    parameter [4:0] explode1 = 5'b00101;    //     5
    parameter [4:0] explode2 = 5'b00110;    //     6
    parameter [4:0] enemy1_1 = 5'b00111;    //     7
    parameter [4:0] enemy1_2 = 5'b01000;    //     8
    parameter [4:0] enemy2_1 = 5'b01001;    //     9
    parameter [4:0] enemy2_2 = 5'b01010;    //     10
    
    parameter [4:0] BKG1     = 5'b11111;    // star background
    parameter [4:0] BKG2     = 5'b01111;    // start background
    
    parameter [9:0] h_start     = 10'b0010100000;    // 160: the starting pixel in the horizontal direction
    parameter [9:0] h_end       = 10'b0111011111;    // 479: the ending pixel in the horizontal direction
    parameter [9:0] txt_end_x   = 10'd159;           // 159: left one-fourth of screen allocated for text
    parameter [9:0] txt_start_y = 10'd288;           // 288: vertical starting position for text
    parameter [9:0] txt_end_y   = 10'd479;           // 479: the vertical end of the screen -> 192 pixels vertically for txt

    
    // internal connection
    logic  [4:0]  pltt_s;
    logic  [2:0]  pltt_addr;
    logic  [3:0]  IN_R[32], IN_G[32], IN_B[32];         // unpacked array of all Red outputs from each palette
    logic  [3:0]  red_gd, green_gd, blue_gd;               // RGB for when game display should be on
    
    // decode data from each pixel(8 bits) stored in FB
    assign  pltt_s    = pixel[7:3];         // palette select: upper 5 bits are sprite type
    assign  pltt_addr = pixel[2:0];         // palette addr: input to all sprite at once; a mux will be used to choose one
    
    // Instantiation of all PALETTES
    ship_palette        ship_pltt    (.index(pltt_addr), .red(IN_R[ship]),       .green(IN_G[ship]),       .blue(IN_B[ship]));
    bullet_palette      bllt_pltt    (.index(pltt_addr), .red(IN_R[bullet]),     .green(IN_G[bullet]),     .blue(IN_B[bullet]));
    bullet_inv_palette  bllt_inv_pltt(.index(pltt_addr), .red(IN_R[bllt_inv]),   .green(IN_G[bllt_inv]),   .blue(IN_B[bllt_inv]));
    explode1_palette    exp1_pltt    (.index(pltt_addr), .red(IN_R[explode1]),   .green(IN_G[explode1]),   .blue(IN_B[explode1]));
    explode2_palette    exp2_pltt    (.index(pltt_addr), .red(IN_R[explode2]),   .green(IN_G[explode2]),   .blue(IN_B[explode2]));
    enemy1_1_palette    e1_1_pltt    (.index(pltt_addr), .red(IN_R[enemy1_1]), .green(IN_G[enemy1_1]), .blue(IN_B[enemy1_1]));
    enemy1_2_palette    e1_2_pltt    (.index(pltt_addr), .red(IN_R[enemy1_2]), .green(IN_G[enemy1_2]), .blue(IN_B[enemy1_2]));
    enemy2_1_palette    e2_1_pltt    (.index(pltt_addr), .red(IN_R[enemy2_1]),   .green(IN_G[enemy2_1]),   .blue(IN_B[enemy2_1]));
    enemy2_2_palette    e2_2_pltt    (.index(pltt_addr), .red(IN_R[enemy2_2]),   .green(IN_G[enemy2_2]),   .blue(IN_B[enemy2_2]));
    
    background_palette  bkg1_pltt(.index(pltt_addr), .red(IN_R[BKG1]),     .green(IN_G[BKG1]),     .blue(IN_B[BKG1]));
    background2_palette bkg2_pltt(.index(pltt_addr), .red(IN_R[BKG2]),     .green(IN_G[BKG2]),     .blue(IN_B[BKG2]));

    // choose the output
    MUX                 mux_r(.IN(IN_R), .S(pltt_s), .OUT(red_gd));
    MUX                 mux_g(.IN(IN_G), .S(pltt_s), .OUT(green_gd));
    MUX                 mux_b(.IN(IN_B), .S(pltt_s), .OUT(blue_gd));
    
    always_comb
    begin
        // when display shouldn't be on, set the screen to black
        Red = 4'b0;
        Green = 4'b0;
        Blue = 4'b0;
    
        if(h_start <= DrawX && DrawX <= h_end)
        begin
            Red = red_gd;
            Green = green_gd;
            Blue = blue_gd;
        end
        else if(DrawX <= txt_end_x && txt_start_y <= DrawY && DrawY <= txt_end_y)
        begin
            if(data[7 - DrawX[3:1]]) begin      // data[7 - DrawX[3:1]]
                Red = 4'h7;                     // use white for all texts
                Green = 4'h7;
                Blue = 4'hA;
            end
        end
    end

endmodule



/*
// default case (to prevent inferred latches)
        Red   = 4'b0000;
        Green = 4'b0000;
        Blue  = 4'b1111;    // Blue Screen
    
        case(pltt_s)
            ship : 
                begin
                    Red   = Red_s;
                    Green = Green_s;
                    Blue  = Blue_s;
                end
            bullet : 
                begin
                    Red   = Red_b;
                    Green = Green_b;
                    Blue  = Blue_b;
                end
            enemy1_1 : 
                begin
                    Red   = Red_e1_1;
                    Green = Green_e1_1;
                    Blue  = Blue_e1_1;
                end
            enemy1_2 : 
                begin
                    Red   = Red_e1_2;
                    Green = Green_e1_2;
                    Blue  = Blue_e1_2;
                end
        endcase
*/










