`timescale 10ns/100ps
module LFSR_Four_Screens_tb();

	reg clk, rst;
	reg button;	
	wire [1:0] first, second, third, fourth, main;
	wire screen_done;
		
	LFSR_Four_Screens DUT_LFSR_Four_Screens(clk,rst,button,first,second,third,fourth,main,screen_done);

	always begin
	#10 clk = 0;
	#10 clk = 1;
	end


	initial begin
	#3
	rst = 1'b1;
	button = 1'b0;
	#20
	@ (posedge clk);
	rst = 1'b0;
	#60
	rst = 1'b1;
	#43
	button = 1'b1;
	#20
	button = 1'b0;
	#1000;
	button = 1'b1;
	#20
	button = 1'b0;
	#100;
	end

endmodule
	
