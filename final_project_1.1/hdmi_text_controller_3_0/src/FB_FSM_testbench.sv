`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2023 12:57:28 AM
// Design Name: 
// Module Name: FB_FSM_testbench
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


module FB_FSM_testbench();

timeunit 10ns;
timeprecision 1ns;

// FSM
logic           clk_100MHz, reset_ah, vblank, hblank;
logic  [31:0]   dina, douta, doutb, dinb;
logic  [10:0]   ctr, addra, addrb;
logic           OEA, OEB, FB_ENA, FB_BKG;
logic  [4:0]    sprite_x, sprite_y;
logic  [3:0]    WEA, WEB;
logic  [8:0]    BKG_X;

// monitor internal signals
//logic  [8:0]   ctr;
logic           fb_en, R, nxt, nxt_sprt, en;
logic  [10:0]   ctr2;                             // for ctr2
logic  [6:0]    spriteX, spriteY;
logic  [15:0]   y_mod, bkgY, reg_mv, test;

// blitter
logic  [2:0]    rom_data, BKG_data;
logic  [9:0]    sprt_addr, drawY;
logic  [4:0]    sprt_s;
logic  [17:0]   FB_addra;
logic           FB_WEA;
logic  [7:0]    FB_dina;
logic           BKG_s;
logic  [15:0]   BKG_addr;
logic  [8:0]    fb_addr_y;

FB_FSM  FB_FSM_inst
(
    // input
    .clk(clk_100MHz),
    .reset(reset_ah),           // should be ACTIVE HIGH
    .vblank(vblank),
    .hblank(hblank),
    // output
    .loco_addr(addrb),
    .OEB(OEB),
    .WEB(WEB),
    // BKG
    .FB_BKG(FB_BKG),
    .BKG_X(BKG_X),
    // sprt
    .FB_ENA(FB_ENA),
    .sprite_x(sprite_x),
    .sprite_y(sprite_y)
);

blitter blitter_inst
(
    // input
    .loco_data(doutb),
    .rst(reset_ah),
    .vblank(vblank),
    // background
    .fb_bkg(FB_BKG),
    .DrawY(drawY),
    .BKG_data(BKG_data),
    .BKG_X(BKG_X),
    .BKG_s(BKG_s),
    .BKG_addr(BKG_addr),
    // sprite
    .rom_data(rom_data),
    .spriteX(sprite_x),
    .spriteY(sprite_y),
    .fb_en(FB_ENA),
    .sprt_addr(sprt_addr),
    .sprt_s(sprt_s),
    // frame buffer
    .fb_addr(FB_addra),
    .fb_wea(FB_WEA),            // will be used for both ENA and WEA for frame buffer BRAM
    .pixel(FB_dina)
);

rom_collection rom_inst
(
    .sprt_addr(sprt_addr),
    .sprt_s(sprt_s),
    .rom_data(rom_data)
);

bkg_rom_collection bkg_rom_inst
(
    .BKG_s(BKG_s),
    .BKG_addr(BKG_addr),
    .BKG_data(BKG_data)
);

blk_mem_gen_0 ram0
(
    // 1st Port
    .addra(addra),
    .clka(clk_100MHz),
    .dina(dina),
    .douta(douta),
    .ena(OEA),
    .wea(WEA),
    // 2nd Port
    .addrb(addrb),
    .clkb(clk_100MHz),
    .dinb(dinb),                    // NOT writing
    .doutb(doutb),              // 32 bit
    .enb(OEB),
    .web(WEB)               // NOT writing
);

// add frame buffer here

always begin: CLOCK_GENERATION
#1 clk_100MHz = ~clk_100MHz;
end

initial begin: CLOCK_INITIALIZATION
    clk_100MHz = 0;
end

initial begin: TEST_VECTORS

for(int i = 0; i < 500; i++)
    begin
    #2  addra = i+50;
        dina = (i+32'h008FFFDD);
        OEA = 1'b1;
        WEA = 4'b1111;
    end
    
#5 OEA = 1'b0;
   WEA = 4'b0;

reset_ah = 1'b1;
#5 reset_ah = 1'b0;

#5 vblank = 1'b1;
#5 vblank = 1'b0;

#130000
   drawY = 10'b0001111000;      // 120
   hblank = 1'b1;
#5 hblank = 1'b0;
end

always_comb
begin
    // counter 1
    ctr = FB_FSM_inst.counter1.ctr;
    
    // blitter
    y_mod = blitter_inst.y_mod;
    bkgY = blitter_inst.bkgY;
    reg_mv = blitter_inst.reg_mv;
    test = blitter_inst.test;
    fb_addr_y = blitter_inst.fb_addr_y;
    
    // counter 2
    fb_en = FB_FSM_inst.ctr_2D.fb_en;
    en = FB_FSM_inst.counter2.en;
    ctr2 = FB_FSM_inst.counter2.ctr;
    R = FB_FSM_inst.counter2.R;
    nxt = FB_FSM_inst.counter2.nxt;
    nxt_sprt = FB_FSM_inst.counter2.nxt_sprt;
    spriteX = FB_FSM_inst.ctr_2D.spriteX;
    spriteY = FB_FSM_inst.ctr_2D.spriteY;
end

endmodule













