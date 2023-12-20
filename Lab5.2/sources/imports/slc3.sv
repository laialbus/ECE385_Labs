//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Given Code - SLC-3 core
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//	  Revised 03-02-2021
//    Xilinx vivado
//    Revised 07-25-2023 
//------------------------------------------------------------------------------


module slc3(
	input logic [15:0] SW,
	input logic	Clk, Reset, Run, Continue,
	output logic [15:0] LED,
	input logic [15:0] Data_from_SRAM,
	output logic OE, WE,
	output logic [7:0] hex_seg,
	output logic [3:0] hex_grid,
	output logic [7:0] hex_segB,
	output logic [3:0] hex_gridB,
	output logic [15:0] ADDR,
	output logic [15:0] Data_to_SRAM
);

// Internal connections
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic SR2MUX, ADDR1MUX, MARMUX;
logic BEN, MIO_EN, DRMUX, SR1MUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [15:0] MDR_In;
logic [15:0] MAR, MDR, IR;
logic [3:0] hex_4[3:0]; 

HexDriver HexA (
    .clk(Clk),
    .reset(Reset),
    //.in({IR[15:12], IR[11:8], IR[7:4], IR[3:0]}),        // used to show IR in Lab5.1
    .in({hex_4[3][3:0],  hex_4[2][3:0], hex_4[1][3:0], hex_4[0][3:0]}), 
    .hex_seg(hex_seg),
    .hex_grid(hex_grid)
);

// You may use the second (right) HEX driver to display additional debug information
// For example, Prof. Cheng's solution code has PC being displayed on the right HEX


HexDriver HexB (
    .clk(Clk),
    .reset(Reset),
    .in({PC_out[15:12], PC_out[11:8], PC_out[7:4], PC_out[3:0]}),   // outputs PC value
    .hex_seg(hex_segB),
    .hex_grid(hex_gridB)
);

// Connect MAR to ADDR, which is also connected as an input into MEM2IO
//	MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
//	input into MDR)
assign ADDR = MAR; 
assign MIO_EN = OE;

    // CODE ADDED       ///////////////////////////////////////////////////////////////////
// Instantiate the rest of your modules here according to the block diagram of the SLC-3
// including your register file, ALU, etc..
logic [15:0]    PC_out, PC_calc_out, ALU_out, bus, A, B;    // the bus that transmit multiple signals
                // A = SR1OUT, B = SR2OUT
logic [9:0]     addra;  // wires for the actual SRAM address input

REG_FILE_block  REG_unit(.*, .LD_REG(LD_REG), .DR(DRMUX), .SR1(SR1MUX), .IR11(IR[11:9]), .IR8(IR[8:6]), .IR2(IR[2:0]), .SR1OUT(A), .SR2OUT(B));

datapath        Datapath(.*, .PC_calc_out, .PC_out(PC_out), .ALU_out, .MDR_out(MDR), .dp_out(bus));

PC_block        PC_unit(.Clk, .Reset, .LD_PC, .PCMUX, .PC_calc_out, .bus(bus), .PC_out(PC_out));

PC_calc_block   PC_calc_unit(.ADDR1MUX, .ADDR2MUX, .off11(IR[10:0]), .SR1OUT(A), .PC_out(PC_out), .PC_calc_out);

ALU_block       ALU_unit(.SR2OUT(B), .SR1OUT(A), .imm5(IR[4:0]), .ALUK, .SR2MUX, .ALU_out);

NZP_BEN_block   BEN_unit(.Clk, .Reset, .bus, .IR11(IR[11:9]), .LD_CC, .LD_BEN, .BEN_out(BEN));

MAR             MAR_unit(.Clk, .Reset, .LD_MAR, .bus(bus), .MAR_out(MAR), .addra);

MDR_block       MDR_unit(.Clk, .Reset, .LD_MDR, .Data_to_CPU(MDR_In), .bus(bus), .MDR_out(MDR), .*);

reg_16          IR_unit(.*, .Load(LD_IR), .D(bus), .Q(IR));   //needs datapath
    
assign LED = IR;    
    // END OF CODE ADDED /////////////////////////////////////////////////////////////////

// Our I/O controller (note, this plugs into MDR/MAR)
Mem2IO memory_subsystem(
    .*, .Reset(Reset), .ADDR(ADDR), .Switches(SW),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]), 
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// State machine, you need to fill in the code here as well
ISDU state_controller(
	.*, .Reset(Reset), .Run(Run), .Continue(Continue),
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
   .Mem_OE(OE), .Mem_WE(WE)
);
	
endmodule
