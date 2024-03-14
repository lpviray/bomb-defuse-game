// TEAM: Shasta GuideBot Model S
// Module: level_control
// Description: 
// This module controls the level difficulty of the game.

module level_control(
	// inputs
	clk, rst, enable, user_level_in,
	// outputs 
	timer_val_TENS, timer_val_ONES, score_multiplier);
	
	input clk, rst, enable;
	input [1:0] user_level_in;
	output reg [3:0] timer_val_TENS, timer_val_ONES;
	output reg [1:0] score_multiplier;
	
	parameter LEVEL_1 = 2'b01, LEVEL_2 = 2'b10, LEVEL_3 = 2'b11;
	
	always@(posedge clk) begin
		if(rst == 1'b0) begin
			timer_val_TENS <= 4'b0000; // TENS = 0
			timer_val_ONES <= 4'b0000; // ONES = 0
			score_multiplier <= 2'b00;
		end
		else begin
			if(enable == 1'b1) begin
				case(user_level_in)
					LEVEL_1: begin // timer = 90 sec
						timer_val_TENS <= 4'b1001; // TENS = 9
						timer_val_ONES <= 4'b0000; // ONES = 0
						score_multiplier <= 2'b01;
					end // end LEVEL_1
					LEVEL_2: begin // timer = 60 sec
						timer_val_TENS <= 4'b0110; // TENS = 6
						timer_val_ONES <= 4'b0000; // ONES = 0
						score_multiplier <= 2'b10;
					end // end LEVEL_2
					LEVEL_3: begin // timer = 30 sec
						timer_val_TENS <= 4'b0011; // TENS = 3
						timer_val_ONES <= 4'b0000; // ONES = 0
						score_multiplier <= 2'b11;
					end // end LEVEL_3
					default: begin // timer = 60 sec LEVEL 2
						timer_val_TENS <= 4'b0110; // TENS = 6
						timer_val_ONES <= 4'b0000; // ONES = 0
						score_multiplier <= 2'b10;
					end
				endcase
			end // end if enable			
		end // end else
	end // end always
endmodule
