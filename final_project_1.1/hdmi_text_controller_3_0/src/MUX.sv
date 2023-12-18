`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2023 03:40:09 PM
// Design Name: 
// Module Name: MUX
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

/*
    This mux is dedicated to the choosing of which sprite to draw
    and which palette to use.
*/

module MUX
         #(
           parameter WIDTH = 4,                    // width of both input and output
           
           // sprite AND palette idx
           parameter [4:0] ship     = 5'b00000,    // ROM 0
           parameter [4:0] pac_1    = 5'b00001,    //     1
           parameter [4:0] pac_2    = 5'b00010,    //     2
           parameter [4:0] bullet   = 5'b00011,    //     3
           parameter [4:0] bllt_ivn = 5'b00100,    //     4
           parameter [4:0] explode1 = 5'b00101,    //     5
           parameter [4:0] explode2 = 5'b00110,    //     6
           parameter [4:0] enemy1_1 = 5'b00111,    //     7
           parameter [4:0] enemy1_2 = 5'b01000,    //     8
           parameter [4:0] enemy2_1 = 5'b01001,    //     9
           parameter [4:0] enemy2_2 = 5'b01010,     //     10
           
           // BKG idx
           parameter [4:0] BKG1     = 5'b11111,     // star background
           parameter [4:0] BKG2     = 5'b01111      // start background
          )
          (
           input logic  [WIDTH-1:0] IN [32],  // there are at most 32 to choose from
           input logic  [4:0]       S,        // mux select, 5 bits
           output logic [WIDTH-1:0] OUT
          );
    
    always_comb
    begin
        // default cases (to prevent inferred latches)
        OUT = '0;       // set all bits to one for testing
        
        case(S)
            ship :                              // 1
                begin
                    OUT = IN[ship];
                end
            bullet :                            // 2
                begin
                    OUT = IN[bullet];
                end
            bllt_ivn :                          // 3
                begin
                    OUT = IN[bllt_ivn];
                end
            explode1 :                          // 4
                begin
                    OUT = IN[explode1];
                end
            explode2 :                          // 5
                begin
                    OUT = IN[explode2];
                end
            enemy1_1 :                          // 6
                begin
                    OUT = IN[enemy1_1];
                end
            enemy1_2 :                          // 7
                begin
                    OUT = IN[enemy1_2]; 
                end
            enemy2_1 :                          // 8
                begin
                    OUT = IN[enemy2_1];
                end
            enemy2_2 :                          // 9
                begin
                    OUT = IN[enemy2_2];
                end
            BKG1 :                              // 10
                begin
                   OUT = IN[BKG1];
                end
            BKG2 :                              // 11
                begin
                   OUT = IN[BKG2];
                end
        endcase
    end
    
endmodule














