`timescale 1 ns / 1 ps

module hdmi_text_controller_v2_0 #
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
logic [9:0]  drawX, drawY, drawX_color;
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
    
assign reset_ah = ~axi_aresetn; // components in Microblaze is somehow active low. 
                                // But this IP is active high. Thus, not the reset signal.

// Instantiation of Axi Bus Interface AXI
hdmi_text_controller_v2_0_AXI # ( 
    .C_S_AXI_DATA_WIDTH(C_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_AXI_ADDR_WIDTH)
) hdmi_text_controller_v2_0_AXI_inst (
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
    //.DrawX(drawX),                  // input: 10 bit
    //.DrawY(drawY),                  // input: 10 bit
    //.DrawX_color(drawX_color),
    //.AddrR(addrR),                  // output: 11 bits
    //.AddrC(addrC),                  // output: 4 bits
    //.CntrlReg(cntrlReg),            // output: 32 bits
    //.IVn(IVn)                       // output: 1 bit
    .Addra(addra),
    .Dina(dina),                      // writing
    .Douta(douta),                    // reading
    .OEA(OEA),
    .WEA(WEA),
    // COLOR PALETTE
    .FGD_Addr(FGD_Addr),              // input 4 bit
    .BKG_Addr(BKG_Addr),
    .FGD_RGB(FGD_RGB),                // output 12 bit
    .BKG_RGB(BKG_RGB)
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
    .drawX(drawX),
    .drawY(drawY)
);

//Real Digital VGA to HDMI converter
hdmi_tx_0 vga_to_hdmi (
    //Clocking and Reset
    .pix_clk(clk_25MHz),
    .pix_clkx5(clk_125MHz),
    .pix_clk_locked(locked),
    //Reset is active LOW
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

font_rom char(
    .addrR(addrR),              // 11 bit
    //.addrC(addrC),
    .data(data)
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
    .dinb(),                    // NOT writing
    .doutb(doutb),              // 32 bit
    .enb(OEB),
    .web(4'b0000)               // NOT writing
);

addr_calc calc1
(
    .DrawX(drawX),
    .DrawY(drawY),
    .DrawX_color(drawX_color),
    .Addrb(addrb),
    //.Dinb(),                  // NOT writing
    .Doutb(doutb),
    .OEB(OEB),
    //.WEB(),                   // NOT writing
    .addrR(addrR),
    .IVn(IVn),
    // COLOR PALETTE
    .FGD_Addr(FGD_Addr),        // output 4 bit
    .BKG_Addr(BKG_Addr)
);
// User logic ends

endmodule









