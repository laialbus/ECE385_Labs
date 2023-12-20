`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2023 04:38:28 PM
// Design Name: 
// Module Name: mux2_1
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


module mux2_1
       #(parameter width = 16)
        (input  logic [width-1:0] IN0, IN1,
         input  logic S,
         output logic [width-1:0] Out);
         
    always_comb
    begin 
        case(S)
            1'b1 : Out = IN1;
            1'b0 : Out = IN0;
        endcase
    end      
         
endmodule
