// ECE 5440 
// Shasta GuideBot Model S
// ROM Controller ID Module
// This module will read in the contents of a ROM 
// that holds the user IDs.

module ROM_controller_ID(clk, rst, q, address);

	input clk, rst;
	input[15:0] q;
	
	output reg[2:0] address;
	reg[1:0] state;
	
	parameter init = 2'b00, wait_1 = 2'b01, wait_2 = 2'b10, finish = 2'b11;
	
	always @(posedge clk) begin
		if (rst == 0)
			begin
				state <= init;
				address <= 3'b000;
			end
		else 
			case (state)
				init : begin 
						if (q == 16'b0000000000000000)
							begin
								state <= finish;
							end
						else 
							begin
								state <= wait_1;
								address <= address + 3'b001;
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
endmodule // ROM_controller_ID