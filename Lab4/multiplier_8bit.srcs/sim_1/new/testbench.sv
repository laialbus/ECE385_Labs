`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2023 09:10:22 PM
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

logic [7:0] SW;
logic Clk =0;
logic Reset_Clear, Run_Accumulate;
logic sign_LED;
logic [7:0] hex_segA;
logic [3:0] hex_gridA;
logic [7:0] Aval;
logic [7:0] Bval;

integer product = 0;
integer Error = 0;

multiplier_toplevel multiplier(.*);

always begin: CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end

initial begin: TEST_VECTORS
SW = 8'h00;
sign_LED = 1'b0;
Run_Accumulate = 1'b0;

// 1st set
SW = 8'h07;
#10 Reset_Clear = 1;
#10 Reset_Clear = 0;

#10 SW = 8'h3B;
#2 Run_Accumulate = 1;
#20 Run_Accumulate = 0;

// 2nd set
#20 SW = 8'hF9;
#10 Reset_Clear = 1;
#10 Reset_Clear = 0;

#10 SW = 8'h3B;
#2 Run_Accumulate = 1;
#20 Run_Accumulate = 0;

// 3rd set
#20 SW = 8'hF9;
#10 Reset_Clear = 1;
#10 Reset_Clear = 0;

#10 SW = 8'hC5;
#2 Run_Accumulate = 1;
#20 Run_Accumulate = 0;

// 4th set
#20 SW = 8'h07;
#10 Reset_Clear = 1;
#10 Reset_Clear = 0;

#10 SW = 8'hC5;
#2 Run_Accumulate = 1;
#20 Run_Accumulate = 0;
end

endmodule







