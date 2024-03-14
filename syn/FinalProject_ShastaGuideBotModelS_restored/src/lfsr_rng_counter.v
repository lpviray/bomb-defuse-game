// ECE 5440
// Shasta GuideBot Model S
// LFSR-based Counter for RNG Module
// This module will create a 16-bit Linear Feedback Shift Register (LFSR)
// that is free running. It uses a many-to-one feedback structure with
// XOR feedback gates. 

module lfsr_rng_counter (clk, rst, q);

  input clk, rst;
  output [15:0] q;

  reg [15:0] LFSR;

  always @(posedge clk)
// If reset is pressed, reset the counter back down to state 0
	begin
		if (rst == 1'b0)
			begin
				LFSR <= 15'b111111111111111;
			end
// Increment up to state 65535 rapidly, start from state 0 otherwise
		else
			begin
    LFSR[0] <= LFSR[1] ^ LFSR[2] ^ LFSR[4] ^ LFSR[15];
    LFSR[15:1] <= LFSR[14:0];
			end
	end

// Update output with the counter value 
  assign q = LFSR;
  
endmodule // lfsr_rng_counter 



