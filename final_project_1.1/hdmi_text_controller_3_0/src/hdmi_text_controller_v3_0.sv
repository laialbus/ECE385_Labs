`timescale 1 ns / 1 ps

module hdmi_text_controller_v3_0 #
(
    // Users to add parameters here

    // User parameters ends
    // Do not modify the parameters beyond this line


    // Parameters of Axi Slave Bus Interface S00_AXI
    parameter integer C_AXI_DATA_WIDTH	= 32,
    parameter integer C_AXI_ADDR_WIDTH	= 16 //note that we changed this from 4 in the provided template
                                             // changed to 16 because the input register from Microblaze would be 16-bit
)
(
    // Users to add ports here

    output wire hdmi_clk_n,
    output wire hdmi_clk_p,
    output wire [2:0] hdmi_tx_n,
    output wire [2:0] hdmi_tx_p,

    // User ports ends
    // Do not modify the ports beyond this line


    // Ports of Axi Slave Bus Interface AXI
    input logic  axi_aclk,
    input logic  axi_aresetn,
    input logic [C_AXI_ADDR_WIDTH-1 : 0] axi_awaddr,
    input logic [2 : 0] axi_awprot,
    input logic  axi_awvalid,
    output logic  axi_awready,
    input logic [C_AXI_DATA_WIDTH-1 : 0] axi_wdata,
    input logic [(C_AXI_DATA_WIDTH/8)-1 : 0] axi_wstrb,
    input logic  axi_wvalid,
    output logic  axi_wready,
    output logic [1 : 0] axi_bresp,
    output logic  axi_bvalid,
    input logic  axi_bready,
    input logic [C_AXI_ADDR_WIDTH-1 : 0] axi_araddr,
    input logic [2 : 0] axi_arprot,
    input logic  axi_arvalid,
    output logic  axi_arready,
    output logic [C_AXI_DATA_WIDTH-1 : 0] axi_rdata,
    output logic [1 : 0] axi_rresp,
    output logic  axi_rvalid,
    input logic  axi_rready
);

//additional logic variables as necessary to support VGA, and HDMI modules.
logic clk_25MHz, clk_125MHz, clk, clk_100MHz;
logic locked;
logic [9:0]  drawX, drawY, drawX_color, drawY_off;
logic [31:0] cntrlReg;
logic [7:0]  data;
logic        IVn;

logic hsync, vsync, vde;
logic [3:0] red, green, blue;
logic reset_ah;

// logic for BRAM
logic [10:0] addra, addrb;
logic clka, clkb;
logic [31:0] dina, dinb, douta, doutb;
logic OEA, OEB;
logic [3:0] WEA, WEB;

// logic added
logic [10:0] addrR;
logic [3:0]  addrC;

// logic for COLOR PALETTE
logic  [3:0]   FGD_Addr, BKG_Addr;
logic  [11:0]  FGD_RGB, BKG_RGB;

/* logic for FRAME BUFFER IMPLEMENTATION */
// FB_FSM
logic           vblank, hblank;
logic           FB_ENA, FB_BKG;            // FSM to blitter
logic  [8:0]    BKG_X;                     // counter1 in FSM
logic  [4:0]    sprite_x, sprite_y;

// blitter
logic  [31:0]   loco_data;              // BRAM port b to blitter
logic  [2:0]    rom_data;               // rom_collection to blitter
logic  [2:0]    BKG_data;               // bkg_rom_collection to blitter
logic  [9:0]    sprt_addr;              // blitter to rom_collection
logic  [4:0]    sprt_s;                 // blitter to rom_collection
logic  [15:0]   BKG_addr;               // blitter to bkg_rom_collection
logic           BKG_s;                  // blitter to bkg_rom_collection
logic  [17:0]   FB_addra;
logic           FB_WEA;                 // blitter to frame buffer
logic  [7:0]    FB_dina;

// addr_calc
logic  [17:0]   FB_addrb;
logic           FB_OEB;
logic  [7:0]    FB_doutb;
logic  [5:0]    reg_addr;

assign reset_ah = ~axi_aresetn; // components in Microblaze is somehow active low. 
                                // But this IP is active high. Thus, not the reset signal.

// Instantiation of Axi Bus Interface AXI
hdmi_text_controller_v3_0_AXI # ( 
    .C_S_AXI_DATA_WIDTH(C_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_AXI_ADDR_WIDTH)
) hdmi_text_controller_v3_0_AXI_inst (
    .S_AXI_ACLK(clk_100MHz),
    .S_AXI_ARESETN(axi_aresetn),
    .S_AXI_AWADDR(axi_awaddr),
    .S_AXI_AWPROT(axi_awprot),
    .S_AXI_AWVALID(axi_awvalid),
    .S_AXI_AWREADY(axi_awready),
    .S_AXI_WDATA(axi_wdata),
    .S_AXI_WSTRB(axi_wstrb),
    .S_AXI_WVALID(axi_wvalid),
    .S_AXI_WREADY(axi_wready),
    .S_AXI_BRESP(axi_bresp),
    .S_AXI_BVALID(axi_bvalid),
    .S_AXI_BREADY(axi_bready),
    .S_AXI_ARADDR(axi_araddr),
    .S_AXI_ARPROT(axi_arprot),
    .S_AXI_ARVALID(axi_arvalid),
    .S_AXI_ARREADY(axi_arready),
    .S_AXI_RDATA(axi_rdata),
    .S_AXI_RRESP(axi_rresp),
    .S_AXI_RVALID(axi_rvalid),
    .S_AXI_RREADY(axi_rready),
    // AXI to BRAM port a
    .Addra(addra),
    .Dina(dina),                      // writing
    .Douta(douta),                    // reading
    .OEA(OEA),
    .WEA(WEA),
    // slv_reg
    .DrawY_off(drawY_off),            // from addr_calc
    .reg_addr(reg_addr),
    .AddrR(addrR)                     // to font_rom
);


//Instiante clocking wizard, VGA sync generator modules, and VGA-HDMI IP here. For a hint, refer to the provided
//top-level from the previous lab. You should get the IP to generate a valid HDMI signal (e.g. blue screen or gradient)
//prior to working on the text drawing.

clk_wiz_0 clk_wiz(
    .clk_out1(clk_25MHz),
    .clk_out2(clk_125MHz),
    .clk_out3(clk_100MHz),
    .reset(reset_ah),
    .locked(locked),
    .clk_in1(axi_aclk)
);

// TAKEN FROM PREV LAB
vga_controller vga (
    .pixel_clk(clk_25MHz),
    .reset(reset_ah),
    .hs(hsync),
    .vs(vsync),
    .active_nblank(vde),
    .vblank(vblank),                  // ADDED BY ME
    .hblank(hblank),                  // ADDED BY ME
    .drawX(drawX),
    .drawY(drawY)
);

//Real Digital VGA to HDMI converter
hdmi_tx_0 vga_to_hdmi (
    //Clocking and Reset
    .pix_clk(clk_25MHz),
    .pix_clkx5(clk_125MHz),
    .pix_clk_locked(locked),
    //Reset is active HIGH
    .rst(reset_ah),
    //Color and Sync Signals
    .red(red),
    .green(green),
    .blue(blue),
    .hsync(hsync),
    .vsync(vsync),
    .vde(vde),
        
    //aux Data (unused)
    .aux0_din(4'b0),
    .aux1_din(4'b0),
    .aux2_din(4'b0),
    .ade(1'b0),
        
    //Differential outputs
    .TMDS_CLK_P(hdmi_clk_p),          
    .TMDS_CLK_N(hdmi_clk_n),          
    .TMDS_DATA_P(hdmi_tx_p),         
    .TMDS_DATA_N(hdmi_tx_n)          
);

font_rom char(
    .addrR(addrR),              // 11 bit
    //.addrC(addrC),
    .data(data)                 // now to palette collection
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
    .FB_OEB(FB_OEB),
    .reg_addr(reg_addr),
    .DrawY_off(drawY_off)
);

palette_collection palette_inst
(
    .pixel(FB_doutb),
    .DrawX(drawX),
    .DrawY(drawY),
    .data(data),        // char data from font_rom
    .Red(red),
    .Green(green),
    .Blue(blue)
);

// User logic ends

endmodule


/*
//Color Mapper Module   
color_mapper color_instance(
    .BallX(),
    .BallY(),
    .DrawX_color(drawX_color),
    .DrawY(),
    .Ball_size(),
    .Red(red),
    .Green(green),
    .Blue(blue),
    .colorData(data),           // input
    .IVn(IVn),                  // input
    // COLOR PALETTE
    .FGD_RGB(FGD_RGB),          // input 12 bit
    .BKG_RGB(BKG_RGB)
    //.cntrlReg(cntrlReg),      // input
);
*/






