`timescale 10ns/100ps
module Game_Top_tb();

	reg rst, clk;
	reg rand,set;
	reg [3:0] switch;
	reg enable;
	
	wire [2:0] check;	
	wire [7:0] period;
	wire [1:0] first, second, third, fourth, main;

	Game_Top DUT_Game_Top(rst, clk, rand, set, switch, enable, check, period, first, second, third, fourth, main);


	always begin
	#10 clk = 0;
	#10 clk = 1;
	end


	initial begin
	#20
	switch = 4'b0000;
	enable = 1'b1;
	rst = 1'b1;
	rand = 1'b0;
	set = 1'b0;
	#20
	@ (posedge clk)
	rst = 1'b0;
	#40
	rst = 1'b1;
	#20
	@ (posedge clk);
	rand = 1'b1;
	#40 	
	rand = 1'b0;
	#40
	@ (posedge clk);
	set = 1'b1;
	#40 
	set = 1'b0;
	#100;
	end

endmodule

