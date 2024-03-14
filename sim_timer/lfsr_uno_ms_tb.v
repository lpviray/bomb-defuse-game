// TEAM: Shasta GuideBot Model S
// Author: Rafael Medina	Peoplesoft ID: 117(5114) 
// Module: lfsr_uno_ms_tb 
// Description: 
// This module computes one [ms] using a LFSR register. 

`timescale 10ns/100ps

module lfsr_uno_ms_tb();
	// lfsr_uno_ms(rst, clk, q, uno_ms_timeout, count);
	reg rst_s, clk_s;
		// wire [15:0] q_s;
	wire uno_ms_timeout_s;
		// wire [15:0] count_s;
	
	// lfsr_uno_ms lfsr_uno_ms_test_instantiation(rst_s, clk_s, q_s, uno_ms_timeout_s, count_s);
	
	lfsr_uno_ms lfsr_uno_ms_intstantiation(rst_s, clk_s, uno_ms_timeout_s);
	
	always begin
	   clk_s = 1'b1; #10;
	   clk_s = 1'b0; #10;
	end
	
	initial begin
	   rst_s = 1'b1;
	   @(posedge clk_s);
	   #5; rst_s = 1'b0;
	   @(posedge clk_s);
	   @(posedge clk_s);
	   @(posedge clk_s);
	   #5; rst_s = 1'b1;
	   
	end
endmodule
