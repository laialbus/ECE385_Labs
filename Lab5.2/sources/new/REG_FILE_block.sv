`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2023 11:22:47 PM
// Design Name: 
// Module Name: REG_FILE_block
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


module REG_FILE_block(input  logic [15:0]    bus,
                      input  logic           Clk, Reset,
                      input  logic           LD_REG, DR, SR1,
                      input  logic [2:0]     IR11, IR8, IR2,         // IR2 is IR[2:0]; SR2 = IR[2:0]
                      output logic [15:0]    SR1OUT, SR2OUT);

    logic [15:0] reg_file [8];  // The 8 registers that would store values as required
    logic [2:0]  DRMUX_out, SR1MUX_out, reg_7;
    
    assign reg_7 = 3'b111;  // use to indicate register 7
    
    // for INPUT
    always_ff @ (posedge Clk)
    begin
        if(Reset) begin
            reg_file[0] = 16'h0000;
            reg_file[1] = 16'h0000;
            reg_file[2] = 16'h0000;
            reg_file[3] = 16'h0000;
            reg_file[4] = 16'h0000;
            reg_file[5] = 16'h0000;
            reg_file[6] = 16'h0000;
            reg_file[7] = 16'h0000;
            
        end        
        
        if(LD_REG) begin
            case(DRMUX_out)
                3'b000 : reg_file[0] = bus;
                3'b001 : reg_file[1] = bus;
                3'b010 : reg_file[2] = bus;
                3'b011 : reg_file[3] = bus;
                3'b100 : reg_file[4] = bus;
                3'b101 : reg_file[5] = bus;
                3'b110 : reg_file[6] = bus;
                3'b111 : reg_file[7] = bus;
            endcase
        end
    end

    // for OUTPUT
    always_comb
    begin
        SR1OUT = 16'hXXXX;
        SR2OUT = 16'hXXXX;
        
        case(SR1MUX_out)              // chooses SR1OUT
            3'b000 : SR1OUT = reg_file[0];
            3'b001 : SR1OUT = reg_file[1];
            3'b010 : SR1OUT = reg_file[2];
            3'b011 : SR1OUT = reg_file[3];
            3'b100 : SR1OUT = reg_file[4];
            3'b101 : SR1OUT = reg_file[5];
            3'b110 : SR1OUT = reg_file[6];
            3'b111 : SR1OUT = reg_file[7];
        endcase
        
        case(IR2)              // chooses SR2OUT
            3'b000 : SR2OUT = reg_file[0];
            3'b001 : SR2OUT = reg_file[1];
            3'b010 : SR2OUT = reg_file[2];
            3'b011 : SR2OUT = reg_file[3];
            3'b100 : SR2OUT = reg_file[4];
            3'b101 : SR2OUT = reg_file[5];
            3'b110 : SR2OUT = reg_file[6];
            3'b111 : SR2OUT = reg_file[7];
        endcase
    end
    
    mux2_1 #(3) DR_MUX (.S(DR), .IN0(reg_7), .IN1(IR11), .Out(DRMUX_out));
    mux2_1 #(3) SR1_MUX(.S(SR1), .IN0(IR11), .IN1(IR8), .Out(SR1MUX_out));
    
endmodule






