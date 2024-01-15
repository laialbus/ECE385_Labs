`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2023 07:39:33 PM
// Design Name: 
// Module Name: full_adder
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


module full_adder  (input logic x, y, z,
                    output logic s, c, p, g);
     always_comb
     begin
         s = x^y^z;
      c = (x&y)|(x&z)|(y&z);
      p = x^y;
         g = x&y;
     end
endmodule
