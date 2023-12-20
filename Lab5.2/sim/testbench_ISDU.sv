`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2023 12:03:43 PM
// Design Name: 
// Module Name: testbench_ISDU
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


module testbench_ISDU();

timeunit 10ns;

timeprecision 1ns;

logic         Clk;
logic   	  Reset;
logic	      Run;
logic		  Continue;
									
logic [3:0]   Opcode;
logic         IR_5;
logic         IR_11;
logic         BEN;
				  
logic        LD_MAR;
logic        LD_MDR;
logic        LD_IR;
logic      	 LD_BEN;
logic		 LD_CC;
logic	 	 LD_REG;
logic		 LD_PC;
logic		 LD_LED; // for PAUSE instruction
									
logic        GatePC;
logic		 GateMDR;
logic		 GateALU;
logic		 GateMARMUX;
									
logic [1:0]  PCMUX;
logic        DRMUX;
logic		 SR1MUX;
logic		 SR2MUX;
logic		 ADDR1MUX;
logic [1:0]  ADDR2MUX;
logic [1:0]	 ALUK;
				  
logic        Mem_OE;
logic	 	 Mem_WE;
/*
enum logic [4:0] {Halted, PauseIR1, PauseIR2, S_18, S_33_1, S_33_2, S_33_3, S_35, S_32, S_01, S_05, 
S_09, S_06, S_25_1, S_25_2, S_25_3, S_27, 
S_07, S_23, S_16_1, S_16_2, S_16_3, S_04, S_21, S_12, S_00, S_22
} state;
*/
logic [4:0] state;

ISDU control_test(.*);

always begin: CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end

initial begin: TEST_VECTORS
Reset = 1'b0;
Continue = 1'b0;
#5 Reset = 1'b1;
#5 Reset = 1'b0;

Opcode = 4'b0001;
#10 Run = 1;
#10 Run = 0;
#10 Opcode = 4'b1101;

#10 Opcode = 4'b0001;
#2  Continue = 1'b1;
#2  Continue = 1'b0;
#20 Opcode = 4'b1101;

#10 Opcode = 4'b0101;
#2 Continue = 1'b1;
#2 Continue = 1'b0;
#20 Opcode = 4'b1101;

#10 Opcode = 4'b1001;
#2 Continue = 1'b1;
#2 Continue = 1'b0;
#20 Opcode = 4'b1101;

#10 Opcode = 4'b0110;
#2 Continue = 1'b1;
#2 Continue = 1'b0;
#20 Opcode = 4'b1101;

#10 Opcode = 4'b0111;
#2 Continue = 1'b1;
#2 Continue = 1'b0;
#20 Opcode = 4'b1101;

#10 Opcode = 4'b0100;
#2 Continue = 1'b1;
#2 Continue = 1'b0;
#20 Opcode = 4'b1101;

#10 Opcode = 4'b1100;
#2 Continue = 1'b1;
#2 Continue = 1'b0;
#20 Opcode = 4'b1101;


end

always_comb begin
    state = control_test.State;
end

endmodule










