module Player_Select_Screens(Rst, Clk, button, first, second, third, fourth);

	input Rst, Clk;
	input button;
	output [1:0] first, second, third, fourth;
	reg [1:0] first, second, third, fourth;
	wire [1:0] Random;

	lfsr_rng DUT_lfsr_rng(Clk,Rst,button,Random);

	parameter choice1 = 4'b0000, choice2 = 4'b0001, choice3 = 4'b0010, choice4 = 4'b0011;

	
	always @ (posedge Clk) begin
		if (Rst == 1'b0) begin
			first <= 2'b00;
			second <= 2'b00;
			third <= 2'b00;
			fourth <= 2'b00;
		end
		else begin
			if(button == 1'b1) begin
			case(Random)
				choice1: begin
					first <= 2'b01;
					second <= 2'b00;
					third <= 2'b10;
					fourth <= 2'b11;
				end
				choice2: begin
					first <= 2'b10;
					second <= 2'b00;
					third <= 2'b01;
					fourth <= 2'b11;
				end
				choice1: begin
					first <= 2'b00;
					second <= 2'b01;
					third <= 2'b10;
					fourth <= 2'b11;
				end
				choice1: begin
					first <= 2'b11;
					second <= 2'b00;
					third <= 2'b10;
					fourth <= 2'b01;
				end
				default: begin
					first <= 2'b11;
					second <= 2'b11;
					third <= 2'b11;
					fourth <= 2'b11;
				end
			endcase
		end
	end
	end

endmodule
				