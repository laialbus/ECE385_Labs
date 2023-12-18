module explode2_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'h0, 4'h0, 4'h0},
	{4'h6, 4'h5, 4'h3},
	{4'hC, 4'hC, 4'hC},
	{4'h9, 4'h0, 4'h0},
	{4'hE, 4'hE, 4'h0},
	{4'hB, 4'hB, 4'h0},
	{4'hE, 4'h0, 4'h0},
	{4'h9, 4'h9, 4'h9}
};

assign {red, green, blue} = palette[index];

endmodule
