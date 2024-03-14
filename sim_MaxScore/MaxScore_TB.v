`timescale 10ns/100ps
module MaxScore_TB();

reg Clk, Rst, Button;
reg [7:0] PlayerScore;
reg [1:0] Multiplier;

wire [3:0] Display10, Display1,TensScore, OnesScore;

MaxScore DUT_MaxScore(Clk, Rst, Button, PlayerScore, Multiplier, Display10, Display1,TensScore, OnesScore);
	
always begin
	Clk <= 0;
	#10;
	Clk <= 1;
	#10;
	end
	
initial begin 
	Rst = 1;
	Button = 0;
	@(posedge Clk);
	#5 Rst = 0;
        @(posedge Clk);
	#5 Rst = 1;
 	@(posedge Clk);
	#10;
	@(posedge Clk);
	PlayerScore = 8'b00010101;
	Multiplier = 2'b10;
	@(posedge Clk);
	#5 Button = 1;
	
	end
endmodule
