`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 01:38:04 AM
// Design Name: 
// Module Name: PC_block
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

/* Needs to add 
   PCMUX 
   input for select bits for PCMUX
   input from bus
   input from PC_Calc for week 2
*/

module PC_block(input logic             Clk, Reset, LD_PC,
                input logic     [1:0]   PCMUX,
                input logic     [15:0]  PC_calc_out, bus,
                output logic    [15:0]  PC_out);
                
    logic   [15:0]    Din, PC_inc;   // incremented PC
    
    assign PC_inc = PC_out + 16'h0001; 
    
    
    mux4_1_16 PC_MUX(.S(PCMUX), .IN0(PC_inc), .IN1(PC_calc_out), .IN2(bus), .IN3(), .Out(Din));
    reg_16 PC(.Clk, .Reset, .Load(LD_PC), .D(Din), .Q(PC_out));
                      
endmodule



