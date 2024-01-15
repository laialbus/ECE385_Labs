`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2023 09:47:18 PM
// Design Name: 
// Module Name: lookahead4
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


module lookahead4( input logic [3:0] A, B,
                   input logic cin,
                   output logic [3:0] S,
                   output logic cout, PG, GG);
    
    logic [3:0] p, g;   // UNSURE: how to connect multiple variables(multiple ports)
    logic c1, c2, c3;
    
    full_adder FA0(.x(A[0]), .y(B[0]), .z(cin), .s(S[0]), .c(), .p(p[0]), .g(g[0]));
    full_adder FA1(.x(A[1]), .y(B[1]), .z(c1), .s(S[1]), .c(), .p(p[1]), .g(g[1]));
    full_adder FA2(.x(A[2]), .y(B[2]), .z(c2), .s(S[2]), .c(), .p(p[2]), .g(g[2]));
    full_adder FA3(.x(A[3]), .y(B[3]), .z(c3), .s(S[3]), .c(), .p(p[3]), .g(g[3]));

    lookahead_unit LAU(.P(p), .G(g), .cin(cin), .c1, .c2, .c3, .cout, .PG, .GG);
endmodule
