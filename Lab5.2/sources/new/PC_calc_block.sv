`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2023 06:01:32 PM
// Design Name: 
// Module Name: PC_calc_block
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


module PC_calc_block(input  logic        ADDR1MUX,
                     input  logic [1:0]  ADDR2MUX,
                     input  logic [10:0] off11,
                     input  logic [15:0] SR1OUT, PC_out,
                     output logic [15:0] PC_calc_out);
                     
    logic [15:0] A, B;      // inputs for addition
    logic [15:0] SEXToff11, SEXToff9, SEXToff6, zero;
    
    always_comb
    begin
        SEXToff11 = {{5{off11[10]}}, off11};
        SEXToff9 = {{7{off11[8]}},off11[8:0]};
        SEXToff6 = {{10{off11[5]}},off11[5:0]};
        zero = 16'h0000;
        
        PC_calc_out = A + B;
    end

    mux2_1      ADDR1_MUX(.S(ADDR1MUX), .IN0(SR1OUT), .IN1(PC_out), .Out(B));
    mux4_1_16   ADDR2_MUX(.S(ADDR2MUX), .IN0(SEXToff11), .IN1(SEXToff9), .IN2(SEXToff6), .IN3(zero), .Out(A));

endmodule












