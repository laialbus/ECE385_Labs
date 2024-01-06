`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2023 07:37:28 PM
// Design Name: 
// Module Name: mb_hdmi_top_level
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


module mb_hdmi_top_level(input logic  Clk,
                         input logic  reset_rtl_0,
               
                         //UART
                         input logic  uart_rtl_0_rxd,
                         output logic uart_rtl_0_txd,
               
                         //HDMI
                         // maybe need to change to HDMI_0_tmds_clk_n, etc.
                         output logic hdmi_tmds_clk_n,
                         output logic hdmi_tmds_clk_p,
                         output logic [2:0]hdmi_tmds_data_n,
                         output logic [2:0]hdmi_tmds_data_p);
               
// INVERT RESET SIGNAL
mb_hdmi mb_hdmi_i
(
    .HDMI_0_tmds_clk_n(hdmi_tmds_clk_n),
    .HDMI_0_tmds_clk_p(hdmi_tmds_clk_p),
    .HDMI_0_tmds_data_n(hdmi_tmds_data_n),
    .HDMI_0_tmds_data_p(hdmi_tmds_data_p),
    .clk_100MHz(Clk),
    .reset_rtl_0(~reset_rtl_0),
    .uart_rtl_0_rxd(uart_rtl_0_rxd),
    .uart_rtl_0_txd(uart_rtl_0_txd)
);

endmodule










