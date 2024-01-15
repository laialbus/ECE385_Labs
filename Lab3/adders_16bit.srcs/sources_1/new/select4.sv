`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2023 08:55:58 PM
// Design Name: 
// Module Name: select4
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


module select4 (input logic [3:0] A, B,
                input logic cin,
                output logic [3:0] S,
                output logic cout0, cout1);
    
    logic [3:0] S0, S1;
    
    // instantiate two carry-ripple adders
    adder4 AR0(.A, .B, .c_in(0), .S(S0), .c_out(cout0));
    adder4 AR1(.A, .B, .c_in(1), .S(S1), .c_out(cout1));
    
    mux_2to1 mux(.in0(S0), .in1(S1), .select(cin), .s(S));
    
endmodule
