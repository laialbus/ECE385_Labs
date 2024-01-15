`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2023 09:11:59 PM
// Design Name: 
// Module Name: lookahead_unit
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


module lookahead_unit(  input logic [3:0] P, G,
                        input logic cin,
                        output logic c1, c2, c3, cout, PG, GG);
    
    assign c1 = cin&P[0]|G[0];
    assign c2 = cin&P[0]&P[1]|G[0]&P[1]|G[1];
    assign c3 = cin&P[0]&P[1]&P[2]|G[0]&P[1]&P[2]|G[1]&P[2]|G[2];
    assign cout = (cin&P[0]&P[1]&P[2]|G[0]&P[1]&P[2]|G[1]&P[2]|G[2])&P[3]|G[3];
    
    assign PG = P[0]&P[1]&P[2]&P[3];
    assign GG = G[3]|G[2]&P[3]|G[1]&P[3]&P[2]|G[0]&P[3]&P[2]&P[1];
    
endmodule
