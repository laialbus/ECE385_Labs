`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 04:24:26 PM
// Design Name: 
// Module Name: MDR_block
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


module MDR_block(input logic            Clk, Reset,
                 input logic            LD_MDR, MIO_EN,
                 input logic    [15:0]  Data_to_CPU, bus,
                 output logic   [15:0]  MDR_out);
                 
    logic [15:0] MDR_in;
    
    // MDR_Mux
    always_comb
    begin
        unique case(MIO_EN)
            1'b0    :   MDR_in = bus;
            1'b1    :   MDR_in = Data_to_CPU;
        endcase
    end
                 
    reg_16 MDR(.Clk, .Reset, .Load(LD_MDR), .D(MDR_in), .Q(MDR_out));
                
endmodule
