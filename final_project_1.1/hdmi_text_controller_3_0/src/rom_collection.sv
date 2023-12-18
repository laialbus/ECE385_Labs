`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2023 03:50:41 AM
// Design Name: 
// Module Name: rom_collection
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


module rom_collection(
                        input        [9:0]  sprt_addr,
                        input        [4:0]  sprt_s,
                        output logic [2:0]  rom_data
                     );
    
    // rom code
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
    
    // ROM outputs: palette addresses/codes for individual sprites' palletes
    logic  [2:0] q[32];
    
    // Instantiation of all SPRITES
    ship_rom        ship_rom(    .a(sprt_addr), .spo(q[ship]));
    bullet_rom      bllt_rom(    .a(sprt_addr), .spo(q[bullet]));
    bullet_inv_rom  bllt_inv_rom(.a(sprt_addr), .spo(q[bllt_inv]));
    explode1_rom    exp1_rom(    .a(sprt_addr), .spo(q[explode1]));
    explode2_rom    exp2_rom(    .a(sprt_addr), .spo(q[explode2]));
    dist_mem_gen_0  e1_1_rom(    .a(sprt_addr), .spo(q[enemy1_1]));
    enemy1_2_rom    e1_2_rom(    .a(sprt_addr), .spo(q[enemy1_2]));
    enemy2_1_rom    e2_1_rom(    .a(sprt_addr), .spo(q[enemy2_1]));
    enemy2_2_rom    e2_2_rom(    .a(sprt_addr), .spo(q[enemy2_2]));
    
    // choose output
    MUX   #(3)   mux_sprite(.IN(q), .S(sprt_s), .OUT(rom_data));
    
endmodule













