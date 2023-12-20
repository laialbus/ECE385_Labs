`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2023 02:10:08 AM
// Design Name: 
// Module Name: simulation_NZP_BEN_block
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


module simulation_NZP_BEN_block();

timeunit 10ns;

timeprecision 1ns;

logic            Clk, Reset;
logic [15:0]     bus;
logic [2:0]      IR11;
logic            LD_CC, LD_BEN;
logic            BEN_out;

logic            BEN;

NZP_BEN_block CC_test(.*);

always begin: CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end

initial begin: TEST_VECTORS
Reset = 1'b0;
bus = 16'h0001;
LD_CC = 1'b0;
LD_BEN = 1'b0;
//BEN_out = 1'b0;
//BEN = 1'b0;

IR11 = 3'b001;

#2  Reset = 1;
#2  Reset = 0;
#10 LD_CC = 1;
#5  LD_CC = 0;
#4  LD_BEN = 1;
#1  LD_BEN = 0;
// try testing LD_CC and LD_BEN 1 simultaneously?

end
/*
always_comb
begin
    BEN = CC_test.BEN;
end
*/
endmodule










