`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2023 08:27:00 PM
// Design Name: 
// Module Name: mux_2to1
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

// 4bit 2-to-1 mux
module mux_2to1(input logic [3:0] in0, in1, 
                input logic select,
                output logic [3:0] s);

    always_comb
    begin
        if(select == 0)
            s = in0;
        else
            s = in1;
    end

endmodule
