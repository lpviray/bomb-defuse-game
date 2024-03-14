module MaxScore(Clk, Rst, Button, PlayerScore, Multiplier, Display10, Display1, TensScore, OnesScore);
	input Clk, Rst, Button;
	input [7:0] PlayerScore;
	input [1:0] Multiplier;
	output reg [3:0] Display10, Display1;

	output reg [3:0] TensScore, OnesScore;

	parameter Init = 2'b00, Multiply = 2'b01, Displays = 2'b10;
	reg [1:0] State;

	always @(posedge Clk)begin
	if (Rst == 0)
		begin
		TensScore <= 4'b0000;
		OnesScore<= 4'b0000;
		end
	else begin
		//TensScore <= PlayerScore[7:4];
		//OnesScore<= PlayerScore[3:0];
		case(State)
		Init: begin
			TensScore <= PlayerScore[7:4];
			OnesScore<= PlayerScore[3:0];
			State <= Multiply;
		end
		Multiply: begin
		if (Button == 1)
		begin
		if(Multiplier == 2'b01)
			begin
			//TensScore <= PlayerScore[7:4];
			//OnesScore<= PlayerScore[3:0];
			State <= Displays;
			end
		else if (Multiplier == 2'b10)
			begin
			//TensScore <= PlayerScore[7:4];
			//OnesScore<= PlayerScore[3:0];
				if(OnesScore == 4'b0101)
					begin 
					OnesScore <= 4'b0000;
					TensScore <= ((TensScore+TensScore)+1);
					State <= Displays;
					end 
				else
					begin
					OnesScore <= 4'b0000;
					TensScore <= TensScore+TensScore;
					State <= Displays;
					end
			end
		else 
			begin
			//TensScore <= PlayerScore[7:4];
			//OnesScore<= PlayerScore[3:0];
				if(OnesScore == 4'b0101)
					begin
					OnesScore <= 4'b0101;
					TensScore <= ((TensScore+TensScore+TensScore)+1);
					State <= Displays;
					end
				else
					begin
					OnesScore <= 4'b0000;
					TensScore <= TensScore+TensScore+TensScore;
					State <= Displays;
					end
			end
		end
		else
			begin
			State <= Init;
			end
		end
		Displays: begin
			Display10 <= TensScore;
			Display1 <= OnesScore;
			State <= Displays;
		end
		default:begin
			State <= Init;
			end
		endcase
		end
	end
endmodule
