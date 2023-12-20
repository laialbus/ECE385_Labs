`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 01:30:47 PM
// Design Name: 
// Module Name: MAR
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


module MAR(input logic          Clk, Reset, LD_MAR, 
           input logic [15:0]   bus,
           output logic [15:0]  MAR_out,
           output logic [9:0]   addra);
    
    // MAR is a 16bit address. However, our SRAM only takes 10bit address
    // Thus, use addra for SRAM and MAR for MEM2IO
    reg_16 MAR_reg(.Clk, .Reset, .Load(LD_MAR), .D(bus), .Q(MAR_out));
    
    assign addra = MAR_out[9:0];
           
endmodule
