module lookahead_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completely combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */

    logic C4, C8, C12;  // C16 is cout
    logic [3:0] PG4;
    logic [3:0] GG4;

    lookahead4 LA0(.A(A[3:0]), .B(B[3:0]), .cin(cin), .S(S[3:0]), .cout(), .PG(PG4[0]), .GG(GG4[0]));
    lookahead4 LA1(.A(A[7:4]), .B(B[7:4]), .cin(C4), .S(S[7:4]), .cout(), .PG(PG4[1]), .GG(GG4[1]));
    lookahead4 LA2(.A(A[11:8]), .B(B[11:8]), .cin(C8), .S(S[11:8]), .cout(), .PG(PG4[2]), .GG(GG4[2]));
    lookahead4 LA3(.A(A[15:12]), .B(B[15:12]), .cin(C12), .S(S[15:12]), .cout(), .PG(PG4[3]), .GG(GG4[3]));
    
    lookahead_unit LAU(.P(PG4), .G(GG4), .cin(cin), .c1(C4), .c2(C8), .c3(C12), .cout(cout), .PG(), .GG());

endmodule
