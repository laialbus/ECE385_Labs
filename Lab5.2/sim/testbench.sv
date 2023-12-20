
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 08:45:24 PM
// Design Name: 
// Module Name: testbench
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


module testbench();

timeunit 10ns;

timeprecision 1ns;

logic [15:0] SW;
logic	Clk, Reset,Run, Continue;
logic [15:0] LED;
logic [7:0] hex_seg;
logic [3:0] hex_grid;
logic [7:0] hex_segB;
logic [3:0] hex_gridB;

// hierarchial simulating signals?
logic [15:0] PC, PC_inc, MAR_out, MDR_out, IR, bus, dp_out, dp_PC;
logic [15:0] register [8];
logic [15:0] A, B, PC_calc_out;
logic        GateMARMUX, GatePC, GateMDR, GateALU;

slc3_testtop    slc3_test(.*);

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

#5  SW = 16'h005A;

#5 Run = 1;
#5 Run = 0;

#40 SW = 16'h0002;
#100 Continue = 1'b1;
#2  Continue = 1'b0;

#250us SW = 16'h0003;
#20 Continue = 1'b1;
#2  Continue = 1'b0;
    
#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;    // 7
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;

#4us Continue = 1'b1;
#2  Continue = 1'b0;
/*
#20 Continue = 1'b1;
#2  Continue = 1'b0;
*/
end

always_comb begin
    PC = slc3_test.slc.PC_out;
    //PC_inc = slc3_test.slc.PC_unit.PC_inc;
    MAR_out = slc3_test.slc.MAR_unit.MAR_out;
    IR = slc3_test.slc.IR;
    register[1] = slc3_test.slc.REG_unit.reg_file[1];
    register[2] = slc3_test.slc.REG_unit.reg_file[2];
    register[3] = slc3_test.slc.REG_unit.reg_file[3];
    register[4] = slc3_test.slc.REG_unit.reg_file[4];
    register[5] = slc3_test.slc.REG_unit.reg_file[5];
    register[6] = slc3_test.slc.REG_unit.reg_file[6];
    MDR_out = slc3_test.slc.MDR_unit.MDR_out;
    //GateMARMUX = slc3_test.slc.GateMARMUX;
    //GatePC = slc3_test.slc.GatePC;
    //GateALU = slc3_test.slc.GateALU;
    //GateMDR = slc3_test.slc.GateMDR;
    A = slc3_test.slc.PC_calc_unit.A;
    B = slc3_test.slc.PC_calc_unit.B;
    PC_calc_out = slc3_test.slc.PC_calc_unit.PC_calc_out;
    //bus = slc3_test.slc.bus;
    //dp_out = slc3_test.slc.Datapath.dp_out;
    //dp_PC = slc3_test.slc.Datapath.PC_out;
end

endmodule




