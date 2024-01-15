`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2023 08:24:46 PM
// Design Name: 
// Module Name: mb_hdmi_2_top
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


module mb_hdmi_2_top(input logic Clk,
                     input logic reset_rtl_0,
                     
                     //USB signals
                     input logic [0:0] gpio_usb_int_tri_i,
                     output logic gpio_usb_rst_tri_o,
                     input logic usb_spi_miso,
                     output logic usb_spi_mosi,
                     output logic usb_spi_sclk,
                     output logic usb_spi_ss,
    
                     // UART
                     input logic uart_rtl_0_rxd,
                     output logic uart_rtl_0_txd,
                     
                     // HDMI
                     output logic hdmi_tmds_clk_n,
                     output logic hdmi_tmds_clk_p,
                     output logic [2:0]hdmi_tmds_data_n,
                     output logic [2:0]hdmi_tmds_data_p);

mb_hdmi_2 mb_hdmi_2_i
(
    .HDMI_0_tmds_clk_n(hdmi_tmds_clk_n),
    .HDMI_0_tmds_clk_p(hdmi_tmds_clk_p),
    .HDMI_0_tmds_data_n(hdmi_tmds_data_n),
    .HDMI_0_tmds_data_p(hdmi_tmds_data_p),
    .clk_100MHz(Clk),
    .reset_rtl_0(~reset_rtl_0),
    .uart_rtl_0_rxd(uart_rtl_0_rxd),
    .uart_rtl_0_txd(uart_rtl_0_txd),
    // FOR USB
    .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
    .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
    .usb_spi_miso(usb_spi_miso),
    .usb_spi_mosi(usb_spi_mosi),
    .usb_spi_sclk(usb_spi_sclk),
    .usb_spi_ss(usb_spi_ss)
);

endmodule











