// TEAM: Shasta GuideBot Model S
// Module: level_control_tb
// Description: 
// This module test the level_control module.

`timescale 10ns/100ps

module level_control_tb();
	// level_control(clk, rst, enable, user_level_in, timer_val, score_multiplier);
	reg clk_s, rst_s, enable_s;
	reg [1:0] user_level_in_s;
	wire [3:0]timer_val_TEN_s, timer_val_ONE_s;
	wire [1:0] score_multiplier_s;

	level_control level_control_instantiation(clk_s, rst_s, enable_s,
			user_level_in_s, timer_val_TEN_s, timer_val_ONE_s, score_multiplier_s);
	
	always begin
		clk_s = 1'b1; #10;
		clk_s = 1'b0; #10;
	end
	
	initial begin
		rst_s = 1'b1;
		user_level_in_s = 2'b00;
		enable_s = 1'b0;
		
		@(posedge clk_s);
		#5; rst_s = 1'b0; #25;
		@(posedge clk_s);
		#5; rst_s = 1'b1;

		// user level enter un-enabled
		@(posedge clk_s); // level_3 enter
		#5; user_level_in_s = 2'b11;
		#65;
		@(posedge clk_s); // level_1 enter
		#5; user_level_in_s = 2'b01;
		#65;
		@(posedge clk_s); // level_2 enter
		#5; user_level_in_s = 2'b10;
		#65;
		@(posedge clk_s);
		#5; user_level_in_s = 2'b00;
		#65;

		// user level enter enabled
		@(posedge clk_s);
		#5; enable_s = 1'b1;
		@(posedge clk_s); // level_3 enter
		#5; user_level_in_s = 2'b11;
		#65;
		@(posedge clk_s); // level_1 enter
		#5; user_level_in_s = 2'b01;
		#65;
		@(posedge clk_s); // level_2 enter
		#5; user_level_in_s = 2'b10;
		#65;
		@(posedge clk_s);
		#5; user_level_in_s = 2'b00;
		#65;

		@(posedge clk_s);
		#5; rst_s = 1'b0; #25;
		@(posedge clk_s);
		#5; rst_s = 1'b1;
	end // end initial
endmodule