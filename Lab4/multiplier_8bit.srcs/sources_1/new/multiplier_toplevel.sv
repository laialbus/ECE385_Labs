`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 09:27:54 PM
// Design Name: 
// Module Name: multiplier_toplevel
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


module multiplier_toplevel(input logic  [7:0] SW,
                           input logic  Clk,
                           input logic  Reset_Clear, Run_Accumulate,    // Reset_Clr is ClrA_LdB; Run_Accumulate is Run
                           output logic sign_LED,   // used for Xval
                           output logic   [7:0]   hex_segA,
                           output logic   [3:0]   hex_gridA,
                           output logic   [7:0]   Aval, Bval
                           );
    
    logic [7:0] SW_S;
    logic Reset_Clear_S, Run_Accumulate_S;      
    logic [8:0] S;                 
    logic A0, M, ClrA, Xval, Shift, Sum, Ad_Sb, Ld_B; // Xval holds S[8] of sum

    control control_unit (.Clk, .Run(Run_Accumulate_S), .ClrA_LdB(Reset_Clear_S), .B0(M), .Clr_A(ClrA), .Shift(Shift), .Ld_A(Sum), .Ld_B(Ld_B), .Ad_Sb(Ad_Sb));
    
    // Ad_Sb is needed for carry-in to negate SW input
    adder9  compute_unit (.A(Aval), .B(SW_S), .Ad_Sb(Ad_Sb), .C(Ad_Sb), .S(S));
    
    reg_8              A (.Clk, .Reset(ClrA), .Shift_In(Xval), .Load(Sum), .Shift_En(Shift), .D(S[7:0]), .Shift_Out(A0), .Data_Out(Aval));
    // regB doesn't need reset
    reg_8              B (.Clk, .Reset(), .Shift_In(A0), .Load(Ld_B), .Shift_En(Shift), .D(SW_S), .Shift_Out(M), .Data_Out(Bval));
    
    X_bit9             X (.Clk, .Reset(ClrA), .Ld(Sum), .bit9(S[8]), .Xval(Xval));

    // Hex units that display contents of register B and A in hex
	HexDriver HexA (
		.clk(Clk),
		.reset(Reset_Clear_S),
		.in({Aval[7:4],  Aval[3:0], Bval[7:4], Bval[3:0]}),
		.hex_seg(hex_segA),
		.hex_grid(hex_gridA)
	);

    // S stands for synchronized
    sync SW_sync[7:0] (Clk, SW, SW_S);
    sync Reset_sync   (Clk, Reset_Clear, Reset_Clear_S);
    sync Run_sync     (Clk, Run_Accumulate, Run_Accumulate_S);

    assign sign_LED = Xval;

endmodule




