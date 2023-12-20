`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2023 04:49:04 PM
// Design Name: 
// Module Name: ALU_block
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


module ALU_block(input  logic [15:0] SR2OUT, SR1OUT,
                 input  logic [4:0]  imm5,
                 input  logic [1:0]  ALUK,
                 input  logic        SR2MUX,
                 output logic [15:0] ALU_out);
                 
    logic [15:0] SEXT_imm5, B;
    logic [15:0] ALU0, ALU1, ALU2, ALU3;
    
    always_comb
    begin
        SEXT_imm5 = {{11{imm5[4]}}, imm5};
        
        ALU_out = 16'hXXXX;
        case(ALUK)
            2'b00 : ALU_out = SR1OUT + B;
            2'b01 : ALU_out = SR1OUT & B;
            2'b10 : ALU_out = ~SR1OUT;
            2'b11 : ALU_out = SR1OUT;
        endcase
    end
    
    mux2_1 SR2_MUX(.IN0(SR2OUT), .IN1(SEXT_imm5), .S(SR2MUX), .Out(B));
                 
endmodule
