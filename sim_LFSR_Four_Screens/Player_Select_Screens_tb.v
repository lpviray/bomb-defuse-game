module Player_Select_Screens_tb();
	reg rst,clk;
	reg button;	
	wire [1:0] first,second,third,fourth;
	
	Player_Select_Screens DUT_PSS(rst,clk,button,first,second,third,fourth);
	
	always begin
	#10 clk = 0;
	#10 clk = 1;
	end

	initial begin
	#10
	rst = 1'b1;
	button = 1'b0;
	#20
	@ (posedge clk)
	rst = 1'b0;
	#40
	rst = 1'b1;
	#20
	@ (posedge clk)
	button = 1'b1;
	#60
	button = 1'b0;
	#60;
	@ (posedge clk)
	button = 1'b1;
	#60
	button = 1'b0;
	end

endmodule
