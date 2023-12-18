`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2023 08:36:46 PM
// Design Name: 
// Module Name: bkg_rom_collection
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


module bkg_rom_collection(
                            input               BKG_s,
                            input        [15:0] BKG_addr,
                            output logic [2:0]  BKG_data
                         );
    
    logic [2:0] bkg_data [2];
              
    always_comb
    begin
        BKG_data = 3'b0;
    
        case(BKG_s)
            1 :
                BKG_data = bkg_data[0];
            0 :
                BKG_data = bkg_data[1];
        endcase
    end

    BKG1_rom bkg1(.a(BKG_addr), .spo(bkg_data[0]));
    BKG2_rom bkg2(.a(BKG_addr), .spo(bkg_data[1]));
  
endmodule









