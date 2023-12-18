`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2023 03:11:59 PM
// Design Name: 
// Module Name: addr_calc_sim
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


module addr_calc_sim();

timeunit 10ns;
timeprecision 1ns;

logic           clk_100MHz;
logic  [17:0]   FB_addra;
logic           FB_WEA;                 // blitter to frame buffer
logic  [7:0]    FB_dina;

// addr_calc
logic  [17:0]   FB_addrb;
logic           FB_OEB;
logic  [7:0]    FB_doutb;
logic  [9:0]    drawX, drawY;

// palette collection
logic  [3:0]    red, green, blue;

frame_buffer frame_buffer_inst  // Simple Dual Port RAM
(
    // first port
    .addra(FB_addra),
    .clka(clk_100MHz),
    .dina(FB_dina),
    .ena(FB_WEA),
    .wea(FB_WEA),
    // second port
    .addrb(FB_addrb),
    .clkb(clk_100MHz),
    .doutb(FB_doutb),
    .enb(FB_OEB)
);

addr_calc calc1
(
    .DrawX(drawX),
    .DrawY(drawY),
    .Addrb(FB_addrb),
    .FB_OEB(FB_OEB)
);

palette_collection palette_inst
(
    .DrawX(drawX),
    .DrawY(drawY),
    .pixel(FB_doutb),
    .Red(red),
    .Green(green),
    .Blue(blue)
);


always begin: CLOCK_GENERATION
#1 clk_100MHz = ~clk_100MHz;
end

initial begin: CLOCK_INITIALIZATION
    clk_100MHz = 0;
end

initial begin: TEST_VECTORS

FB_addra = 17'h00000;
FB_dina = 8'b00000010;  // sprite: 00000, pltt code: 010
FB_WEA = 1'b1;

#5 FB_addra = 17'h00001;
   FB_dina = 8'b00011001;   // sprite: 00011

#2 FB_addra = 17'h00002;
   FB_dina = 8'b00111010;   // sprite: 00111

#2 FB_addra = 17'h00003;
   FB_dina = 8'b01000011;   // sprite: 01000

#2 FB_addra = 17'h00004;
   FB_dina = 8'b00000100;

#2 FB_addra = 17'h00005;
   FB_dina = 8'b01111001;

#10 drawX = 10'b0010100000;
    drawY = 10'b0000000000;
    
#5  drawX = 10'b0010100001;
    drawY = 10'b0000000000;
    
#5  drawX = 10'b0010100010;
    drawY = 10'b0000000000;

#5  drawX = 10'b0010100011;
    drawY = 10'b0000000000;

#5  drawX = 10'b0010100100;
    drawY = 10'b0000000000;

#5  drawX = 10'b0010100101;
    drawY = 10'b0000000000;
end

endmodule














