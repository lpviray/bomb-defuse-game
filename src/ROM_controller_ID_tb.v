// ECE 5440
// Shasta GuideBot Model S
// ROM Controller ID Testbench Module 
// This module will read in the contents of a ROM
// that holds the user IDs.

`timescale 1ns/100ps

module ROM_controller_ID_tb ();
	
	reg clk, rst;

	wire[2:0] address;
	wire[15:0] q;

// Instantiate custom ROM module
	ROM_controller_ID ROM_controller_ID_DUT(clk, rst, q, address);
	ROM_ID ROM_ID_DUT(address, clk, q);

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
endmodule // ROM_controller_ID_tb