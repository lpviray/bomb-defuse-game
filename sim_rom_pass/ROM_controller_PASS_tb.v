// ECE 5440
// Shasta GuideBot Model S
// ROM Controller Password Testbench Module 
// This module will read in the contents of a ROM
// that holds the user passwords.

`timescale 1ns/100ps

module ROM_controller_PASS_tb ();
	
	reg clk, rst;

	wire[2:0] address;
	wire[19:0] q;

// Instantiate custom ROM module
	ROM_controller_PASS ROM_controller_PASS_DUT(clk, rst, q, address);
	ROM_PASS ROM_PASS_DUT(address, clk, q);

// Clock Procedure
	always begin
		clk <= 0;
		#10;
		clk <= 1;
		#10;
	end

// Vector Procedure
	initial begin
		rst <= 0;
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		@(posedge clk)
		#5;
		rst <= 1;
	end
endmodule // ROM_controller_PASS_tb