`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2023 09:00:25 PM
// Design Name: 
// Module Name: ctr2
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


module ctr2(
            input                clk,
            input                en,
            input                nxt,    // signal from blitter indicating a sprite-draw is complete
            output logic         R,      // indicate counter has reached its end
            output logic [10:0]  ctr,    // to location buffer
            output logic         nxt_sprt
            );
            
    parameter [10:0] stop = 11'b00000110010;    // counts 50 times; indexed 0 to 49
    parameter [10:0] init = 11'b11111111111;    // indicate not counting
    
    always_ff @ (posedge clk)
    begin
        nxt_sprt <= 1'b0;
        
        if(~en) begin
            ctr <= init;    // use all 1's to indicate end
        end
        else if(en && (ctr == init)) begin
            ctr <= (ctr + 1);
            nxt_sprt <= 1'b1;
        end
        else begin
            if(ctr == stop) begin
                ctr <= init;
            end
            else if(nxt) begin
                ctr <= (ctr + 1);
                if((ctr+1) != stop)
                    nxt_sprt <= 1'b1;
            end
        end
    end
   
    always_comb
    begin
        R = 1'b0;
        
        if(ctr == stop)
            R = 1'b1;
    end

endmodule










