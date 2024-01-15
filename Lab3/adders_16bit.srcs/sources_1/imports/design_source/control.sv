//simple state machine to convert a pushbutton input to one clock cycle long event
//similar to the hold->reset portion of the serial logic processor


module control (	input logic Clk, Reset, Run, 
						output logic Run_O);
						
	   enum logic [2:0] {A, B, C} curr_state, next_state; //States
	   logic [15:0] counter, next_counter;                //We need an extra counter here, otherwise we might run through
	                                                      //addition before pushbuttons are done bouncing (and add multiple times).
	   
	   //Always FF block for FSMs
	   always_ff @ (posedge Clk or posedge Reset ) 
		begin
            if (Reset) begin
                curr_state <= A;
                counter <= 8'h00;
            end 
            else
                curr_state <= next_state;
                
            counter <= next_counter; //This is the 'two-always' methodology, note that we can change
                                     //next counter via combinational logic.
		end
		
		// Assign 'next_state' based on 'state' and 'Execute'
		always_comb
		begin
            // Default needed to stay in the same state
            next_state = curr_state; 
            
            unique case (curr_state)
                A : if (Run && counter == 16'hFFFF)
                        next_state = B;
                B : next_state = C;
                
                C : if (~Run && counter == 16'hFFFF) // Make sure counter has hit a certain value
                        next_state = A;
            endcase
        end
        
		// Assign outputs based on current state
		always_comb
		begin
		    Run_O = 1'b0;             //Default assignments, notice these are blocking assignments
		    next_counter = counter;   //so they may be overwritten by the assignments below.
            case (curr_state)
                A: 
                    begin
                        Run_O = 1'b0;
                        next_counter = counter + 16'h01;
                    end
                B: 
                    begin
                        Run_O = 1'b1;
                        next_counter = 16'h0000;
                    end
                C: 
                    begin
                        Run_O = 1'b0;
                        next_counter = counter + 16'h01;
                    end
            endcase
		end
		
endmodule