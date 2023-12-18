`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2023 09:00:25 PM
// Design Name: 
// Module Name: ctr1
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

/*Takes care of background in frame buffer*/
module ctr1(
            input                clk,
            input                en,
            output logic         R,             // indicate counter has reached its end
            output logic         fb_bkg,        // indicate draw BKG to FB
            output logic [8:0]   ctr            // horizontal position on display
            );
            
    parameter [8:0] stop  = 9'b100111111;    // 319: counter should count 320 times (0~319)        
    parameter [8:0] init  = 9'b111111111;    // indicate not counting
    
    always_ff @ (posedge clk)
    begin
        if(~en) begin
            ctr <= init;    // use all 1's to indicate end
        end
        else begin
            if(ctr == stop) begin
                ctr <= init;
            end
            else begin
                ctr <= (ctr + 1);
            end
        end
    end
    
    
    always_comb
    begin
        fb_bkg = 1'b0;
        R = 1'b0;
        
        if(ctr == stop)
            R = 1'b1;
        if(ctr != init)
            fb_bkg = 1'b1;
    end
    
endmodule















