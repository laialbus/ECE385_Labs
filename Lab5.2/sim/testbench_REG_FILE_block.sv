`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2023 11:58:18 PM
// Design Name: 
// Module Name: testbench_REG_FILE_block
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


module testbench_REG_FILE_block();

timeunit 10ns;

timeprecision 1ns;

logic [15:0]    bus;
logic           Clk, Reset;
logic           LD_REG, DR, SR1;
logic [2:0]     IR11, IR8, IR2;         // IR2 is IR[2:0]; SR2 = IR[2:0]
logic [15:0]    SR1OUT, SR2OUT;

REG_FILE_block register_test(.*);

always begin: CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end

initial begin: TEST_VECTORS
Reset = 1'b0;
bus = 16'h0000;
LD_REG = 1'b0;
DR = 1;             // load IR11
IR11 = 3'b110;      // to reg5
SR1 = 1'b0;
IR8 = 3'b110;       // output reg5
IR2 = 3'b01;        // output reg1 for SR2OUT

#10 bus = 16'hECEB;
    LD_REG = 1;
#5  LD_REG = 0;
#5  bus = 16'hF0F0;
    IR11 = 3'b001;  // load xF0F0 into reg1
#5  LD_REG = 1'b1;
#5  LD_REG = 1'b0;
#5  SR1 = 1'b1;

end

endmodule









