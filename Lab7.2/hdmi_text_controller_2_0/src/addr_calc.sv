`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2023 10:20:00 PM
// Design Name: 
// Module Name: addr_calc
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


module addr_calc(input  [9:0]   DrawX, DrawY,
                 output [9:0]   DrawX_color,        // passes on DrawX
                                                    // in fear of timing issue
                 output [10:0]  Addrb,
                 output [31:0]  Doutb,              // ONLY calculates addr, not getting its values
                 output         OEB,
                 output [10:0]  addrR,
                 output         IVn,
                 output [3:0]   FGD_Addr,
                 output [3:0]   BKG_Addr
                 );
                 
    // byte_addr for the numberth of byte; reg_idx for addr of VRAM
    // byte_idx for one of the four bytes in each address
    logic [11:0]  byte_addr;    // 2400 requires 12 bits which is 4048
    logic         byte_idx;     // only needs two bits to indicate individual byte
    //logic [10:0]  font_rom;
    //logic         drawX, ivn;
    //logic [3:0]   fgd_addr, bkg_addr;
    
    assign DrawX_color = DrawX;
    assign OEB = 1'b1;
    assign Addrb = byte_addr[11:1];
    assign addrR = {(Doutb[(byte_idx*16+8)+:7]), DrawY[3:0]};
    assign FGD_Addr = Doutb[(byte_idx*16+4)+:4];
    assign BKG_Addr = Doutb[(byte_idx*16)+:4];
    assign IVn = Doutb[byte_idx*16+15];
    assign byte_idx = byte_addr[0];
    
    always_comb
    begin
        byte_addr = (DrawY[9:4] * 80) + DrawX[9:3];
        //font_rom = {(Doutb[(byte_idx*16+8)+:7]), DrawY[3:0]};
        //ivn <= Doutb[byte_idx*16+15];
        //fgd_addr <= Doutb[(byte_idx*16+4)+:4];
        //bkg_addr <= Doutb[(byte_idx*16)+:4];
        
        //Addrb = byte_addr[11:1];
        //addrR = {(Doutb[(byte_idx*16+8)+:7]), DrawY[3:0]};
        //IVn = Doutb[byte_idx*16+15];
    end
    
endmodule


/*
// Add user logic here
logic [9:0] charR, charC;
logic [10:0] charVal;
//logic [10:0] charNum;
    // byte_addr for the numberth of byte; reg_idx for addr of VRAM
    // byte_idx for one of the four bytes in each address
logic [11:0]  byte_addr;    // 2400 requires 12 bits which is 4048
logic [1:0]   byte_idx;     // only needs two bits to indicate individual byte
//int reg_idx; // byte_idx;// byte_addr;


assign  CntrlReg = slv_regs[600];
assign  DrawX_color = DrawX;

always_comb // CALCULATE CHAR ROW AND COL
begin
    //charR = DrawY >> 4;     // divide 16
    //charC = DrawX >> 3;     // divide 8
    
    //row = charR * 80;       // calculate how many characters are in the lines
                            // before the current line
    byte_addr = (DrawY[9:4] * 80) + DrawX[9:3];
    // row + charC;    // int = int + bit logic
    //reg_idx = byte_addr[11:2];   // divide 4
    byte_idx = byte_addr[1:0];   // could be (byte_addr & 3), mod 4
////////////////////////////////////////////////////////////////////////////////////////
    case(byte_idx)
        00 : //begin
            charVal = {4'b0, slv_regs[byte_addr[11:2]][6:0]};
            //IVn = slv_regs[reg_idx][7];
        //end
        01 : //begin
            charVal = {4'b0, slv_regs[byte_addr[11:2]][14:8]};
            //IVn = slv_regs[reg_idx][15];
        //end
        10 : //begin
            charVal = {4'b0, slv_regs[byte_addr[11:2]][22:16]};
            //IVn = slv_regs[reg_idx][23];
        //end
        11 : //begin
            charVal = {4'b0, slv_regs[byte_addr[11:2]][30:24]};
            //IVn = slv_regs[reg_idx][31];
        //end
    endcase
/////////////////////////////////////////////////////////////////////////////////////////
    IVn = slv_regs[byte_addr[11:2]][(byte_idx*8)+7];        // the bit indicating color inverse
    
    //charNum = charVal << 4;                  // calculating the line on which the char is
    AddrR = {(slv_regs[byte_addr[11:2]][(byte_idx*8)+:7]), DrawY[3:0]};       // the row on which the screen is on (%16 could be & 15)
    //AddrC = DrawX & 7;                       // mod 8
end
*/

// User logic ends





