// ECE 5440
// Shasta GuideBot Model S
// LFSR-based RNG Module
// When the Bomb Defuse games needs a new player command number, 
// the number will be taken from bits 5 and 11 of the number 
// pseudo-randomly generated from the LFSR. 

module lfsr_rng (clk, rst, button, random);

	input clk, rst, button;
	output reg [1:0] random;
	
// Extract 16-bit generated number from the counter
	wire [15:0] q; 
	
// Instantiate counter to obtain a random number
	lfsr_rng_counter DUT_lfsr_rng_counter(clk, rst, q);

	always @ (posedge clk)
// If reset is pressed, clear randomly generated number to 0;
		begin
			if (rst == 1'b0)
				begin	
					random <= 2'b00;
				end 
// Set bits 5 and 11 to become the randomly generated number	
			else 
				begin
					if (button == 1'b1)
						begin
							random[0] <= q[5];
							random[1] <= q[11];
						end
				end
		end
endmodule // lfsr_rng
	
	
	