`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2023 07:13:57 PM
// Design Name: 
// Module Name: control
// Project Name: Torture4_DamageMulitiplied
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


module control(input logic Clk, Run, ClrA_LdB, B0,
               output logic Clr_A, Shift,
               output logic Ld_A, Ld_B,   // Ld_A is equivalent to ADD
               output logic Ad_Sb); // Ad_Sb controls whether sum or subtraction is performed
                                    // Ad_Sb = 1 means subtract
    // Declare the states of the control unit
    // which are expressed with signals
    // However, they will be represented with enum values of A to R
    enum logic [5:0] {A, B, C, D, E, F, G, H, I,
                      J, K, L, M, N, O, P, Q, R}    curr_state, next_state;
    
    // updates current state which should be stored in FF
    always_ff @ (posedge Clk)
    begin
        if(ClrA_LdB)
            curr_state <= A;
        else
            curr_state <= next_state;
    end
    
    // Determine the next_state with the curr_state through comb logic
    always_comb
    begin
    
        next_state = curr_state;    // ensure all cases are covered **
        
        unique case (curr_state)
            A :     
                if(Run)
                   // if(B0)
                        next_state = B;
                   // else
                     //   next_state = C; // no else statement since ** takes care of the other case
                else
                    next_state = A;
            B :     
                next_state = C;
            C :
              //  begin     
                //    if(B0)  // If B[0] is zero, jump to the next shift state
                        next_state = D;
                  //  else
                    //    next_state = E;
                // end
            D :     
                next_state = E;
            E :     
              //  begin     
                //    if(B0)
                        next_state = F;
                  //  else
                    //    next_state = G;
                // end
            F :     
                next_state = G;
            G :
               // begin     
                 //   if(B0)
                        next_state = H;
                   // else
                  //      next_state = I;
                //end
            H :     
                next_state = I;
            I :
            //    begin     
              //      if(B0)
                        next_state = J;
                //    else
                  //      next_state = K;
                //end
            J :
                next_state = K;
            K :
              //  begin     
                //    if(B0)
                        next_state = L;
                  //  else
                    //    next_state = M;
                //end
            L :
                next_state = M;
            M :
                /*begin     
                    if(B0) */
                        next_state = N;
                   // else
                     //   next_state = O;
                //end
            N :
                next_state = O;
            O : 
                /*begin     
                    if(B0)*/
                        next_state = P;
                   /* else
                        next_state = Q;
                end */
            P :
                next_state = Q;
            Q :
                next_state = R;
            R :
                if(~Run)    // ensures that if multiply only occurs once each time Run is pressed
                    next_state = A;
        endcase

        // assign output signals based on states
        case (curr_state)
            A:
                begin
                    Ld_B = ClrA_LdB;
                    if(Run)
                        Clr_A = 1'b1;
                    else
                        Clr_A = 1'b0;
                    Shift = 1'b0;
                    Ld_A = 1'b0;
                    Ad_Sb = 1'b0;
                end
            P:                      // final add state is slightly different
                begin
                    Ld_B = 1'b0;
                    Clr_A = 1'b0;
                    Shift = 1'b0;
                    if(B0)
                        Ld_A = 1'b1;
                    else
                        Ld_A = 1'b0;
                  //  if(B0)
                        Ad_Sb = 1;  // do subtraction
                  //  else
                    //    Ad_Sb = 0;
                end            
            R:                      // Hold state
                begin
                    Ld_B = 1'b0;
                    Clr_A = 1'b0;
                    Shift = 1'b0;
                    Ld_A = 1'b0;
                    Ad_Sb = 1'b0;
                end           
            B, D, F, H, J, L, N:    // During the ordinary ADD states
                begin
                    Ld_B = 1'b0;
                    Clr_A = 1'b0;
                    Shift = 1'b0;
                    if(B0)
                        Ld_A = 1'b1;
                    else
                        Ld_A = 1'b0;
                    Ad_Sb = 1'b0;   // add during all Add state except for MSB during P
                end
            default:                // All other states which are Shift states
                begin
                    Ld_B = 1'b0;
                    Clr_A = 1'b0;
                    Shift = 1'b1;
                    Ld_A = 1'b0;    // can't load sum into A during shifting (avoid glitch)
                    Ad_Sb = 1'b0;   // can be don't care, put 0 (add) for simplicity
                end
        endcase
    
    end
    
endmodule

















