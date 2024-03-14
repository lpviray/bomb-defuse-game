module RAM_Controller(gameOver_State, hiScore_Check, rst, clk, data_in, data_out, address_set, user_ID, write_enable, score_check, high_score, check);

	input gameOver_State,hiScore_Check;
	input rst,clk;

	// Testing purposes -- DO NOT NEED
	output [2:0] check;
	reg [2:0] check;

	// For setting user's index within RAM
	input [2:0] user_ID;
	
	// For entering user's score
	input [7:0] data_in;

	// For checking for high score
	input [7:0] score_check;
	reg [7:0] score_compare;

	output [7:0] high_score;
	reg [7:0] high_score;

	// Sets read or write operation
	output write_enable;
	reg write_enable;

	// Score that will be sent to RAM
	output [7:0] data_out;
	reg [7:0] data_out;

	// Address that score will be set in RAM
	output [2:0] address_set;
	reg [2:0] address_set;

	reg [2:0] state, nextState;
	
	parameter Init = 3'b000, Wait1 = 3'b001, Wait2 = 3'b010, Finish = 3'b011, HiScore = 3'b100, UserMax = 3'b101, Cycle = 3'b110;

	always @ (posedge clk) begin
	if(rst == 1'b0) begin
		state <= Init;
		address_set <= 3'b000;
		data_out <= 8'b00000000;
		write_enable <= 1'b0;
		score_compare <= 8'b00000000;
		check <= 3'b000;
		high_score <= 8'b00000000;
	end
	else begin
		case(state) 
		Init: begin
		check = 3'b001;
		// Inputting score to RAM
		// 001 with score of 8
		if (gameOver_State == 1'b1) begin
			address_set <= user_ID;
			write_enable <= 1'b1;
			//data_out <= data_in;
			score_compare <= data_in;
			nextState <= UserMax;
			state <= Wait1;
		end
		else begin
			state <= Init;		
		end	
		end
		Wait1: begin
			check = 3'b010;
			state <= Wait2;
		end
		Wait2: begin
			check = 3'b011;
			// Go into max score address
			//address_set <= 3'b110;
			state <= nextState;
		end
		Finish: begin
			check = 3'b100;
			write_enable <= 1'b0;
			if(hiScore_Check == 1'b1) begin
				// Show high score
				address_set = 3'b000;
				nextState <= Cycle;
				state <= Wait1;
			end
			else begin
				state <= Init;
			end
		end
		HiScore: begin
			check = 3'b101;
			write_enable <= 1'b0;
			address_set <= 3'b110;
			if(score_check > score_compare) begin
				//nextState <= Finish;
				write_enable <= 1'b0;
				state <= Finish;
			end
			else begin
				write_enable <= 1'b1;
				high_score <= score_compare;
				data_out <= score_compare;
				nextState <= Finish;
				state <= Wait1;
			end
	
		end
		UserMax: begin
			check = 3'b110;
			if(score_check > score_compare) begin
				write_enable <= 1'b0;
				state <= Finish;
			end
			else begin
				data_out <= score_compare;
				//address_set <= 3'b110;	
				nextState <= HiScore;
				state <= Wait1;
			end
		end	
		Cycle: begin
			check = 3'b111;
			if(address_set == 3'b110) begin
				nextState <= Init;
				state <= Wait1;
			end
			else begin
				address_set = address_set + 1;
				nextState <= Cycle;
				state <= Wait1;
			end
		end
		default: begin
			state <= Init;
		end
		endcase
	end
	end

endmodule