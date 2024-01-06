//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( //input  logic [31:0] cntrlReg,        // MODIFIED: added for color choosing
                       input  logic [11:0] FGD_RGB, BKG_RGB,
                       input  logic [7:0]  colorData,
                       input  logic        IVn,
                       input  logic [9:0]  BallX, BallY, DrawX_color, DrawY, Ball_size,
                       output logic [3:0]  Red, Green, Blue );
   
    always_comb
    begin:RGB_Display
        /*
        if ((ball_on == 1'b1)) begin 
            Red = 4'hf;
            Green = 4'h7;
            Blue = 4'h0;
        end       
        else begin
        
            Red = 4'hf - DrawX[9:6]; 
            Green = 4'hf - DrawX[9:6];
            Blue = 4'hf - DrawX[9:6];
        
        end
        */
        
        if(colorData[7 - DrawX_color[2:0]]) begin         // FOREGROUND COLOR by default
            if(IVn) begin
                Red = BKG_RGB[11:8];
                Green = BKG_RGB[7:4];
                Blue = BKG_RGB[3:0];
            end
            else begin
                // bits for FOREGROUND color
                Red = FGD_RGB[11:8];
                Green = FGD_RGB[7:4];
                Blue = FGD_RGB[3:0];
            end
        end
        else begin
            if(IVn) begin
                Red = FGD_RGB[11:8];
                Green = FGD_RGB[7:4];
                Blue = FGD_RGB[3:0];
            end
            else begin
                // bits for BACKGROUND color
                Red = BKG_RGB[11:8];
                Green = BKG_RGB[7:4];
                Blue = BKG_RGB[3:0];
            end
        end
        
    end 
    
endmodule





