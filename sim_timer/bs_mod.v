// TEAM: Shasta GuideBot Model S
// Module: bs_mod
// Description:
// This module takes the raw input from the user through a button press and converts the 
// unprecise signal to a precise one pulse signal using FSM.

// module bs_mod (clk, reset, b_in, b_out, state); // state is only used as an output to simulate
module bs_mod (clk, reset, b_in, b_out);
	input clk, reset, b_in;
 	output b_out;
	// output state; // remove state after simulation phase
	reg b_out;
 	reg [1:0] state;
	
	parameter s0_init = 2'b00, s1_pulse = 2'b01;
	parameter s2_waiting = 2'b10, s3_impossible = 2'b11;

	always @(posedge clk)
		begin
 		if (reset == 1'b0)
 			begin
 			state <= s0_init;
 			b_out <= 1'b0;
 			end
		else
 			begin
 			case (state)
 				s0_init:begin
					if (b_in == 1'b0)
						begin
 						state <= s1_pulse;
 						b_out <= 1'b1;
 						end
					// else we stay in the s1_init state
 				end
 				s1_pulse:begin
					state <= s2_waiting;
					b_out <= 1'b0;
 				end
 				s2_waiting:begin
					if (b_in == 1'b1)
						begin
						state <= s0_init;
						b_out <= 1'b0;
						end
 				end
 				s3_impossible: begin
					state <= s0_init;
					b_out <= 1'b0;
 				end
 				default: begin
	 				state <= s0_init;
					b_out <= 1'b0;
				 end
			endcase
			end
		end
endmodule
