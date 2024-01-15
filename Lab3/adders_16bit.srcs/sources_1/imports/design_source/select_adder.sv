module select_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output logic  cout
);

    /* TODO
     *
     * Insert code here to implement a CSA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */

    logic [1:0] c4, c8, c12, c16;   // the two C16 outputs will be used to determine cout
    logic C4, C8, C12, C16;

    always_comb
    begin
        C4 = c4[0]; // cin is 0 for sure, so no need to perform logic computation
        C8 = c8[0]|(c8[1]&C4);
        C12 = c12[0]|(c12[1]&C8);
        C16 = c16[0]|(c16[1]&C12);
        cout = C16; // shows an error when module definition for cout does NOT contain "logic"
    end

    select4 SA0(.A(A[3:0]), .B(B[3:0]), .cin(cin), .S(S[3:0]), .cout0(c4[0]), .cout1(c4[1]));
    select4 SA1(.A(A[7:4]), .B(B[7:4]), .cin(C4), .S(S[7:4]), .cout0(c8[0]), .cout1(c8[1]));
    select4 SA2(.A(A[11:8]), .B(B[11:8]), .cin(C8), .S(S[11:8]), .cout0(c12[0]), .cout1(c12[1]));
    select4 SA3(.A(A[15:12]), .B(B[15:12]), .cin(C12), .S(S[15:12]), .cout0(c16[0]), .cout1(c16[1]));


endmodule
