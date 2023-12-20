`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 01:54:26 PM
// Design Name: 
// Module Name: datapath
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


module datapath(input logic     GateMARMUX, GatePC, GateALU, GateMDR,
                input logic     [15:0] PC_calc_out, PC_out, ALU_out, MDR_out,
                output logic    [15:0] dp_out);
    // gate signals
    logic [3:0] gate_sig;
    
    //assign PC_calc_out = 16'h0000;
    //assign ALU_out = 16'h0000;

    always_comb
    begin
        gate_sig = {GateMARMUX, GatePC, GateALU, GateMDR};
        dp_out = 16'hXXXX;  // when no gate is opened, don't care value on bus
        
        unique case(gate_sig)
            4'b1000 :   dp_out = PC_calc_out;
            4'b0100 :   dp_out = PC_out;
            4'b0010 :   dp_out = ALU_out;
            4'b0001 :   dp_out = MDR_out;
        endcase
    end

endmodule
