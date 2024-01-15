//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2023 03:33:04 PM
// Design Name: 
// Module Name: individual_testbench
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


module individual_testbench();
    
timeunit 10ns;

timeprecision 1ns;

logic [15:0] Ar, Br, Al, Bl, As, Bs;
logic cin;
logic [15:0] S;
logic cout;

logic [16:0] sumr, suml, sums;

integer Error = 0;

ripple_adder ripple0(.A(Ar), .B(Br), .*);
initial begin: TEST_VECTORS0
Ar = 16'hFFFF;
Br = 16'h0001;
cin = 0;

sumr = (16'hFFFF + 16'h0001);
if(S != sumr[15:0])
    Error++;
if(cout != sumr[16])
    Error++;

end    

lookahead_adder lookahead0(.A(Al), .B(Bl), .*);
initial begin: TEST_VECTORS1

Al = 16'hFF02;
Bl = 16'h1001;
cin = 0;

suml = (16'hFF02 + 16'h1001);
if(S != suml[15:0])
    Error++;
if(cout != suml[16])
    Error++;

end

lookahead_adder select0(.A(As), .B(Bs), .*);
initial begin: TEST_VECTORS2

As = 16'hFF02;
Bs = 16'h1001;
cin = 0;

sums = (16'hFF02 + 16'h1001);
if(S != sums[15:0])
    Error++;
if(cout != sums[16])
    Error++;

end

endmodule