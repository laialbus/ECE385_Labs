`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 10:04:05 PM
// Design Name: 
// Module Name: adder9
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


module adder9(input logic [7:0] A, B,
              input logic Ad_Sb, C,
              output logic [8:0] S);
    
    // internal logic used for function selection          
    logic [8:0] BB, AA;
    logic no_carry, c0, c1;   // carry for adders
    
    always_comb
    begin
        BB[7:0] = B[7:0] ^ {8{Ad_Sb}};
        BB[8] = BB[7];  // extend by one bit
        AA = {A[7], A};
    end
    
    adder4 A0(.A(AA[3:0]), .B(BB[3:0]), .c_in(C), .S(S[3:0]), .c_out(c0));
    adder4 A1(.A(AA[7:4]), .B(BB[7:4]), .c_in(c0), .S(S[7:4]), .c_out(c1));
    full_adder FA0(.x(AA[8]), .y(BB[8]), .z(c1), .s(S[8]), .c(), .p(), .g()); 
   
endmodule
