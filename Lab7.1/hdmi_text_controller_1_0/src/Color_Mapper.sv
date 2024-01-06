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


module  color_mapper ( input  logic [31:0] cntrlReg,        // MODIFIED: added for color choosing
                       input  logic [7:0]  colorData,
                       input  logic        IVn,
                       input  logic [9:0]  BallX, BallY, DrawX_color, DrawY, Ball_size,
                       output logic [3:0]  Red, Green, Blue );
/*     
    logic ball_on;
	 
    Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))
       )

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
/*	  
    int DistX, DistY, Size;
    assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
  
    always_comb
    begin:Ball_on_proc
        if ( (DistX*DistX + DistY*DistY) <= (Size * Size) )
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end 
*/       
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
                Red = cntrlReg[12:9];
                Green = cntrlReg[8:5];
                Blue = cntrlReg[4:1];
            end
            else begin
                // bits for FOREGROUND color
                Red = cntrlReg[24:21];
                Green = cntrlReg[20:17];
                Blue = cntrlReg[16:13];
            end
        end
        else begin
            if(IVn) begin
                Red = cntrlReg[24:21];   // changed back
                Green = cntrlReg[20:17];
                Blue = cntrlReg[16:13];
            end
            else begin
                // bits for BACKGROUND color
                Red = cntrlReg[12:9];
                Green = cntrlReg[8:5];  // changed back
                Blue = cntrlReg[4:1];
            end
        end
        
    end 
    
endmodule





