`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2023 09:48:38 PM
// Design Name: 
// Module Name: X_bit9
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


module X_bit9(input logic Clk, Reset, Ld, bit9,
              output logic Xval);
              
    always_ff @ (posedge Clk)
    begin
        if(Reset)
            Xval <= 1'b0;
        else if(Ld)
            Xval <= bit9; // store the sign bit of the sum into X 
    end

endmodule
