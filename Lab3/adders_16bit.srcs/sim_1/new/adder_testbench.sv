//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2023 10:52:48 PM
// Design Name: 
// Module Name: adder_testbench
// Project Name: Torture385
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


module adder_testbench();

timeunit 10ns;

timeprecision 1ns;

// internal signals
logic Clk = 0;
logic Reset_Clear, Run_Accumulate;
logic [15:0] SW;
logic sign_LED;
logic [16:0] Out;
logic [7:0] hex_segA;
logic [3:0] hex_gridA;
logic [7:0] hex_segB;
logic [3:0] hex_gridB;

// To store expected result
logic [16:0] sum;

// records the number of errors
integer Error = 0;

adder_toplevel adder_toplevel0(.*);

always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end

initial begin: TEST_VECTORS
Reset_Clear = 1;    // Toggle reset_clear

Run_Accumulate = 1;
SW = 16'h0;
#2 Reset_Clear = 0;
#2 Reset_Clear = 1;
#2 SW = 16'hFFF0;  // specify SW value for input
// Out = 16'h0001; // try FFFF + 0001 which overflows

#2 Run_Accumulate = 0;  // toggle Run_Accumulate
    sum = (16'hFFF0 + 16'h0000);    // Expected result of the 1st operation
    // Out is now supposed to be equal to sum
    // S cannot be used because it is an internal signal
    if (Out != sum)
     Error++;
#2 Run_Accumulate = 1;

#2 SW = 16'h000F;   // Try another set of input

#2 Run_Accumulate = 0;
#2 Run_Accumulate = 1;
    sum = (16'hFFF0 + 16'h000F);    // Expected sum
    // check if output is correct
    if (Out != sum)
     Error++;
     

if(Error == 0)
    $display("Success!");   
else
    $display("%d error(s) detected. QQ!", Error);

end
endmodule
