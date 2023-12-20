`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2023 04:28:33 PM
// Design Name: 
// Module Name: mux4_1_16
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


module mux4_1_16(input logic    [1:0]   S,
                 input logic    [15:0]  IN0, IN1, IN2, IN3,
                 output logic   [15:0]  Out);

    always_comb
    begin
        Out = 16'hXXXX;
        
        case(S)
            2'b00 : Out = IN0;
            2'b01 : Out = IN1;
            2'b10 : Out = IN2;
            2'b11 : Out = IN3;
        endcase
    end

endmodule
