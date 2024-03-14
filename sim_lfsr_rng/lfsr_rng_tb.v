// ECE 5440
// Shasta GuideBot Model S
// LFSR-based Counter for RNG Testbench Module
// This module will create a 16-bit Linear Feedback Shift Register (LFSR)
// that is free running. It uses a many-to-one feedback structure with
// XOR feedback gates. 

`timescale 10ns/100ps

module lfsr_rng_tb ();

	reg CLOCK, RESET, BUTTON;
	wire [1:0] RANDOM;
	
// Instantiate custom random number generator module
	lfsr_rng DUT_rng_rng(CLOCK, RESET, BUTTON, RANDOM);
	
// Clock Procedure
	always begin
		CLOCK = 0;
		#10;
		CLOCK = 1;
		#10;
	end
	
// Vector Procedure
	initial begin
		#3;
		RESET = 0;
		BUTTON = 1; 
		#100;
		RESET = 1;
		#20;
		BUTTON = 0;
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		#5;
		BUTTON = 1;
		#5
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		@ (posedge CLOCK)
		#5;
		BUTTON = 0;
	end
endmodule // lfsr_rng_tb