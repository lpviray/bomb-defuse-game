// ECE 5440
// Shasta GuideBot Model S
// Multi-User Access Control Testbench Module
// This module will create a user authentication system for the
// Bomb Defuse game. A player will have to be identified and then
// log in correctly with the proper password before playing. 

`timescale 10ns/100ps

module access_tb ();

// Define parameters
	reg clk, rst, push, answer_in, timeout, button;
	reg [3:0] id_in, pass_in, score;
	
	wire answer_out, red_id, red_pass, green_id, green_pass, red_timeout, enable, reconfig;
	wire [2:0] address_id, address_pass;
	wire [15:0] q_id, id_out;
	wire [19:0] q_pass, pass_out;
	
// Instantiate custom access control module
	access DUT_access(clk, rst, push, answer_in, id_in, pass_in, answer_out, id_out, pass_out, red_id, red_pass, green_id, green_pass, red_timeout, timeout, enable, reconfig, q_id, q_pass, address_id, address_pass, score, button);
	ROM_ID DUT_ROM_ID(address_id, clk, q_id);
	ROM_PASS DUT_ROM_PASS(address_pass, clk, q_pass);
	
// Clock Procedure
	always begin
		clk <= 0;
		#10;
		clk <= 1;
		#10;
	end
	
// Vectore Procedure
	initial begin
// Logging in as Shivam
		rst <= 0;
		#40;
		rst <= 1;
		push <= 0;
		id_in <= 4'b0011;
		#20;
		@ (posedge clk)
		push <= 1;
		@ (posedge clk)
		push <= 0;
		id_in <= 4'b1000;
		@ (posedge clk)
		push <= 1;
		@ (posedge clk)
		push <= 0;
		id_in <= 4'b0100;
		@ (posedge clk)
		push <= 1;
		@ (posedge clk)
		push <= 0;
		id_in <= 4'b0010;
		@ (posedge clk)
		push <= 1;
		@ (posedge clk)
		push <= 0;
		@ (posedge clk)
		@ (posedge clk)
		@ (posedge clk)
		@ (posedge clk)
		@ (posedge clk)
		@ (posedge clk)
		@ (posedge clk)
		@ (posedge clk)
		@ (posedge clk)
		@ (posedge clk)
// Wrong password entry "01234"
		pass_in <= 4'b0000;
		#20;
		push <= 1;
		#20;
		push <= 0;
		pass_in <= 4'b0001;
		#20;
		push <= 1;
		#20;
		push <= 0;
		pass_in <= 4'b0010;
		#20;
		push <= 1;
		#20;
		push <= 0;
		pass_in <= 4'b0011;
		#20;
		push <= 1;
		#20;
		push <= 0;
		pass_in <= 4'b0100;
		#20;
		push <= 1;
		@ (posedge clk)
		@ (posedge clk)
		push <= 0;
		@ (posedge clk)
		@ (posedge clk)
		@ (posedge clk)
		@ (posedge clk)

// Correct password entry "11111"
		pass_in <= 4'b0001;
		#20;
		push <= 1;
		#20;
		push <= 0;
		pass_in <= 4'b0001;
		#20;
		push <= 1;
		#20;
		push <= 0;
		pass_in <= 4'b0001;
		#20;
		push <= 1;
		#20;
		push <= 0;
		pass_in <= 4'b0001;
		#20;
		push <= 1;
		#20;
		push <= 0;
		pass_in <= 4'b0001;
		#20;
		push <= 1;
		@ (posedge clk)
		@ (posedge clk)
		push <= 0;



//// Test here

	end
endmodule // access_tb
		
		
		

