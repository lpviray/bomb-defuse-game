// ECE 5440 
// Shasta GuideBot Model S
// ROM Controller Password Module
// This module will read in the contents of a ROM 
// that holds the user passwords.

module ROM_controller_PASS(clk, rst, q, address);

	input clk, rst;
	input[19:0] q;
	
	output reg[2:0] address;
	reg[1:0] state;
	
	parameter init = 2'b00, wait_1 = 2'b01, wait_2 = 2'b10, finish = 2'b11;
	
	always @(posedge clk) begin
		if (rst == 0)
			begin
				state <= init;
				address <= 2'b00;
			end
		else 
			case (state)
				init : begin 
						if (q == 0)
							begin
								state <= finish;
							end
						else 
							begin
								state <= wait_1;
								address <= address + 1;
							end
					end
				wait_1 : begin
							state <= wait_2;
						end
				wait_2 : begin
							state <= init;
						end
				finish : begin
							state <= state;
						end
			endcase
	end
endmodule // ROM_controller_PASS