`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2023 01:17:19 AM
// Design Name: 
// Module Name: NZP_BEN_block
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:     CHALLENGE WRITING EVERYTHING IN ONE MODULE B/C WHY NOT? IT'S HARD ENOUGH ALREADY ANYWAYS. :)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module NZP_BEN_block(input logic            Clk, Reset,
                     input logic [15:0]     bus,
                     input logic [2:0]      IR11,
                     input logic            LD_CC, LD_BEN,
                     output logic           BEN_out);

    logic [2:0] NZP;
    
    //assign BEN_out = BEN;
    
    always_ff @ (posedge Clk)
    begin
        if(Reset) begin
            NZP = 3'b000;
            BEN_out = 1'b0;
        end
        
        // NZP Block
        if(LD_CC) begin
            // Base Case: set as when bus value is positive
            NZP = 3'b001;   // P = 1
            
            if(bus == 16'h0000)     // Z = 1
                NZP = 3'b010;
            else if(bus[15] == 1)   // N = 1
                NZP = 3'b100;
        end
        
        // BEN Block
        if(LD_BEN) begin
            // Base Case: BEN = 0
            BEN_out = 1'b0;
        
            if((NZP[2]&IR11[2]) || (NZP[1]&IR11[1]) || (NZP[0]&IR11[0]))    // Branch Condition met: BEN = 1
                BEN_out = 1'b1;
        end
        
    end
    
endmodule










