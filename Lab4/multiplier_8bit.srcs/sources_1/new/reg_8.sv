`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 09:44:03 PM
// Design Name: 
// Module Name: reg_8
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


module reg_8(input logic        Clk, Reset, Shift_In,
                                Load, Shift_En,
             input logic [7:0]  D,
             output logic       Shift_Out,
             output logic [7:0] Data_Out);
             
    always_ff @ (posedge Clk)
    begin
        if(Reset)
            Data_Out <= 8'h0;
        else if(Shift_En)
            Data_Out <= {Shift_In, Data_Out[7:1]};
        else if(Load)
            Data_Out <= D;
    end
    
    always_comb
    begin
        Shift_Out = Data_Out[0];    // Shift_Out would be the M for register B
    end
    
endmodule



