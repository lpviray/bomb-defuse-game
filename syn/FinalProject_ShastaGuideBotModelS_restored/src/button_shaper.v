//Course Number: ECE5540
//Author: Emilio Baguioro
//Module: button_shaper
//Notes: The button_shaper module transforms a button press with a long output 
// 	 into a short pulse that will run for only one cycle.
module button_shaper(b_in,Clk,Rst,b_out);

	input b_in;
	input Clk;
	input Rst;
	output b_out;
	reg b_out;

	parameter b_init = 0, b_pulse = 1,
		  b_wait = 2;

	reg [1:0] State, StateNext;
	
	always @(State, b_in) begin
		case(State)
			b_init: begin
			b_out = 1'b0;
			if(b_in == 1'b1) 
				StateNext = b_init;
			else
				StateNext = b_pulse;
			end
			b_pulse: begin
			b_out = 1'b1;
			StateNext = b_wait;
			end
			b_wait: begin
			b_out = 1'b0;
			if(b_in == 1'b1)
				StateNext = b_init;
			else
				StateNext = b_wait;
			end
		endcase
	end

	// StateReg
	always @(posedge Clk) begin
		if (Rst == 0)
			State <= b_init;
		else
			State <= StateNext;
	end
endmodule
 
			