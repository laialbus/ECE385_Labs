`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 01:20:15 AM
// Design Name: 
// Module Name: reg_16
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


module reg_16(input logic   Clk, Reset, Load,
              input logic   [15:0] D,
              output logic  [15:0] Q);
    
    always_ff @ (posedge Clk)
        begin
            if(Reset)
                Q <= 16'b0000000000000000;
            else if(Load)
                Q <= D;
        end
    
    
endmodule
