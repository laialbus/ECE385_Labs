module ripple_adder
(
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
     
     logic fa_c0, fa_c1, fa_c2;
     
     // UNSURE: how to assign multiple var(multiple ports) 
     adder4 AR0(.A(A[3:0]), .B(B[3:0]), .c_in(cin), .S(S[3:0]), .c_out(fa_c0));
     adder4 AR1(.A(A[7:4]), .B(B[7:4]), .c_in(fa_c0), .S(S[7:4]), .c_out(fa_c1));
     adder4 AR2(.A(A[11:8]), .B(B[11:8]), .c_in(fa_c1), .S(S[11:8]), .c_out(fa_c2));
     adder4 AR3(.A(A[15:12]), .B(B[15:12]), .c_in(fa_c2), .S(S[15:12]), .c_out(cout));
    
endmodule