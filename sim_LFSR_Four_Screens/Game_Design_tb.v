`timescale 1ns/100ps
module Game_Design_tb();

	reg start_btn_press;
	reg [3:0] switch;
	reg rst, clk;
	reg game_enable;
	wire [1:0] first, second, third, fourth, main, check;
	wire screen_done;
	wire [3:0] s1, s2, s3;
	wire [7:0] score;
	wire game_complete;

	Game_Design DUT_Game_Design(rst,clk,start_btn_press,switch, game_enable,first, second, third, fourth,main, check, screen_done, s1, s2, s3,score,game_complete);

	always begin
	#10 clk = 0;
	#10 clk = 1;
	end

	initial begin 
	#23
	switch = 4'b0001;
	rst = 1'b1;
	game_enable = 1'b1;
	start_btn_press = 1'b0;
	#40
	@ (posedge clk);
	rst = 1'b0;
	#40
	rst = 1'b1;
	#1000;
	@ (posedge clk);
	start_btn_press = 1'b1;
	#60
	start_btn_press = 1'b0;
	#1000;
	switch = 4'b1000;
	// Stage 2 Press
	switch = 4'b1000;
	start_btn_press = 1'b1;
	#60
	start_btn_press = 1'b0;
	#1000;
	// Stage 3 Press
	switch = 4'b1000;
	start_btn_press = 1'b1;
	#60
	start_btn_press = 1'b0;
	#1000;
	// Stage 4 Incorrect
	//switch = 4'b0100;
	// Stage 4 Press
	start_btn_press = 1'b1;
	#60
	start_btn_press = 1'b0;
	
	/*
	@ (posedge clk);
	btn_press = 1'b1;
	#60
	btn_press = 1'b0;
	#80
	@ (posedge clk);
	btn_press = 1'b1;
	#60
	btn_press = 1'b0;
	*/
	end

endmodule
