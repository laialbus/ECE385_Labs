`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2023 06:57:51 PM
// Design Name: 
// Module Name: FB_FSM
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


module FB_FSM(  
                input  logic         clk, reset,
                input  logic         vblank,
                input  logic         hblank,
                
                output logic [10:0]  loco_addr,
                output logic         OEB,
                output logic [3:0]   WEB,
                // signal for BKG drawing
                output logic         FB_BKG,
                output logic [8:0]   BKG_X,
                // dimensions for sprite drawing
                output logic         FB_ENA,
                output logic [4:0]   sprite_x,
                output logic [4:0]   sprite_y
             );

    parameter [10:0] addr_off = 11'b00000110010;                // updated "old" locations are stored starting from address 50

    // OFF: display is on, DON'T update
    // Update1: copy new address to output address
    // Update2: update frame buffer
    enum logic [1:0] {OFF, Update1, Update2} State, Next_state;
    
    // ctr1 enable, ctr2 enable
    logic           en1, en2;       // GIVE
    logic           R1, R2;         // RECEIVE: indicate counter has reached its end
    logic [10:0]    ctr1, ctr2;     // these logics are for determining the signals sent to the BRAM
    logic [3:0]     WEB1;           // WEB2 = 4'b0000
    logic           nxt;            // dim_ctr -> ctr2: indicates a sprite drawn
    logic           nxt_sprt;       // ctr2 -> dim_ctr: indicates draw next sprite

    always_ff @ (posedge clk) 
    begin
        if(reset)
            State <= OFF;
        else
            State <= Next_state;
    end

    always_comb
    begin
        Next_state = State;
        
        en1 = 1'b0;
        en2 = 1'b0;
        loco_addr = 11'b11111111111;
        OEB = 1'b0;
        WEB = 4'b0000;
        
        unique case (State)
            OFF :
                if(vblank)
                    Next_state = Update2;
                else if(hblank)
                    Next_state = Update1;
            Update1 : 
                if(R1)
                    Next_state = OFF;
            Update2 : 
                if(R2)
                    Next_state = OFF;
        endcase
        
        case (State)
            OFF :
                begin
                    en1 = 1'b0;
                    en2 = 1'b0;
                end
            Update1 :
                begin
                    en1 = 1'b1;
                    en2 = 1'b0;
                    loco_addr = 11'b0;              // read data from addr 0
                    OEB = 1'b1;
                    WEB = 4'b0000;
                end
            Update2 : 
                begin
                    en1 = 1'b0;
                    en2 = 1'b1;
                    loco_addr = ctr2 + addr_off;
                    OEB = 1'b1;
                    WEB = 4'b0000;
                end
        endcase
    end

    ctr1 counter1(.clk(clk), .en(en1), .R(R1), .fb_bkg(FB_BKG), .ctr(BKG_X));
    ctr2 counter2(.clk(clk), .en(en2), .nxt(nxt), .R(R2), .ctr(ctr2), .nxt_sprt(nxt_sprt));
    ctr_2D ctr_2D(.clk(clk), .rst(reset), .nxt_sprt(nxt_sprt), .fb_en(FB_ENA), .nxt(nxt), .sprite_x(sprite_x), .sprite_y(sprite_y));
    //dim_ctr dim_1(.clk(clk), .rst(reset), .nxt_sprt(nxt_sprt), .nxt(nxt), .fb_en(FB_ENA), .sprite_x(sprite_x), .sprite_y(sprite_y));

endmodule















