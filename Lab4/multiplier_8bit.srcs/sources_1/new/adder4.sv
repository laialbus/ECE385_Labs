`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2023 08:03:15 PM
// Design Name: 
// Module Name: adder4
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

// TAKEN FROM PREV LABS
module adder4( input logic [3:0] A, B,
               input logic c_in, 
               output logic [3:0] S,
               output logic c_out);
               
    // internal carry-signals
    // first adder uses c_in and last adder uses c_out
    logic c0, c1, c2;
    
    full_adder FA0(.x(A[0]), .y(B[0]), .z(c_in), .s(S[0]), .c(c0), .p(), .g());
    full_adder FA1(.x(A[1]), .y(B[1]), .z(c0), .s(S[1]), .c(c1), .p(), .g());
    full_adder FA2(.x(A[2]), .y(B[2]), .z(c1), .s(S[2]), .c(c2), .p(), .g());
    full_adder FA3(.x(A[3]), .y(B[3]), .z(c2), .s(S[3]), .c(c_out), .p(), .g());

endmodule
