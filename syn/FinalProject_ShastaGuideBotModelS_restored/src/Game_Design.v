module Game_Design (RST, CLK, button, switch_position, Game_Enable, first_disp, second_disp, third_disp, fourth_disp,main_disp, Score, Game_Complete);

	input RST, CLK;
	input button;
	input [3:0] switch_position;

	// Must be set to 1 to activate
	input Game_Enable;

	// Output signal to indicate loss or win (if 1, game is complete)
	// Goes to Timer module to signal that game has ended, goes to access controller to grab score
	output reg Game_Complete;


	// Pulse
	reg pulse;

	// Actual four screen values that will be used by game design
	output [1:0] first_disp, second_disp, third_disp, fourth_disp;
	reg [1:0] first_disp, second_disp, third_disp, fourth_disp;
	output [1:0] main_disp;
	reg [1:0] main_disp;
	//output screen_test;
	reg screen_test;

	// TESTING PURPOSES
	//output [1:0] check;
	reg [1:0] check;

	// Scoring 
	output [7:0] Score;
	reg [7:0] Score;
	
	
	// Placeholder to compare values
	//output [3:0] Stage1, Stage2, Stage3;
	reg [3:0] Stage1, Stage2, Stage3;

	// Random value from four screens module
	wire [1:0] first_out, second_out, third_out, fourth_out, main_out;
	wire screen_done;

	
	// Instantiation for random values of four screens
	//LFSR_Bottom_Screens IN_LFSR_Bottom_Screens(CLK,RST,rand_button,first_out,second_out,third_out,fourth_out);
	LFSR_Four_Screens IN_LFSR_Four_Screens(CLK,RST,pulse,first_out,second_out,third_out,fourth_out,main_out,screen_done);


	parameter Init = 4'b0000, Start = 4'b0001, Round1 = 4'b0010, End1 = 4'b0011, Wait = 4'b0100, Wait2 = 4'b0101, Win = 4'b0110, Loss = 4'b0111, Round2 = 4'b1000, Round3 = 4'b1001, Round4 = 4'b1010, Restart = 4'b1011;

	reg [3:0] state,lastState,nextState;
	
	always @ (posedge CLK) begin
		if (RST == 1'b0) begin
			first_disp <= 2'b00;
			second_disp <= 2'b00;
			third_disp <= 2'b00;
			fourth_disp <= 2'b00;
			main_disp <= 2'b00;
			screen_test <= 1'b0;
			check <= 2'b00;
			pulse <= 1'b0;
			Stage1 <= 4'b0000;
			Stage2 <= 4'b0000;
			Stage3 <= 4'b0000;
			Score <= 8'b00000000;
			Game_Complete <= 1'b1;
		end
		else begin 
			case (state) 
				Init: begin
				if((Game_Enable == 1'b1) && (Game_Complete <= 1'b1)) begin
					first_disp <= 2'b00;
					second_disp <= 2'b00;
					third_disp <= 2'b00;
					fourth_disp <= 2'b00;
					main_disp <= 2'b00;
					screen_test <= 1'b0;
					check <= 2'b00;
					pulse <= 1'b0;
					Stage1 <= 4'b0000;
					Stage2 <= 4'b0000;
					Stage3 <= 4'b0000;
					Score <= 8'b00000000;
					state <= Wait;
					nextState <= Round1;
				end
				else begin	
					state <= Init;
				end
				end
				Start: begin	
				if(screen_done == 1'b1) begin
					screen_test <= screen_done;
					first_disp <= first_out;
					second_disp <= second_out;
					third_disp <= third_out;
					fourth_disp <= fourth_out;
					main_disp <= main_out;
	
					state <= nextState;
				end 
				else begin			
					state <= Start;
				end
				end
				Wait: begin
					screen_test <= screen_done;
					pulse <= 1'b1;
					state <= Wait2;
				end
				Wait2: begin
					screen_test <= screen_done;
					pulse <= 1'b0;
					state <= Start;
				end
				Round1: begin
				if(button == 1'b1) begin
				screen_test <= screen_done;
				if(main_disp == 2'b00) begin
					if(switch_position == 4'b0100) begin
						Stage1 <= switch_position;
						nextState <= Round2;
						state <= Wait;
						Score <= 8'b00000101;
					end
					else begin
						Score <= 8'b00000000;
						state <= Loss;
					end
				end
				else if (main_disp == 2'b01) begin
					if(switch_position == 4'b0100) begin
						Stage1 <= switch_position;
						nextState <= Round2;
						state <= Wait;
						Score <= 8'b00000101;
					end
					else begin
						Score <= 8'b00000000;
						state <= Loss;
					end
				end
				else if (main_disp == 2'b10) begin
					if(switch_position == 4'b0010) begin
						Stage1 <= switch_position;
						nextState <= Round2;
						state <= Wait;
						Score <= 8'b00000101;
					end
					else begin
						Score <= 8'b00000000;
						state <= Loss;
					end
				end
				else begin
					if(switch_position == 4'b0001) begin
						Stage1 <= switch_position;
						nextState <= Round2;
						state <= Wait;
						Score <= 8'b00000101;
					end
					else begin
						Score <= 8'b00000000;
						state <= Loss;
					end
				end
				end
				else begin
					state <= Round1;
				end
				end
				Round2: begin
				if(button == 1'b1) begin
				screen_test <= screen_done;
				if(main_disp == 2'b00) begin
					if(first_disp == 2'b11) begin
						if(switch_position == 4'b1000) begin
						Stage2 <= switch_position;
						nextState <= Round3;
						state <= Wait;
						Score <= 8'b00010000;
						end
						else begin
						state <= Loss;
						end
					end
					else if (second_disp == 2'b11) begin
						if(switch_position == 4'b0100) begin
						Stage2 <= switch_position;
						nextState <= Round3;
						state <= Wait;
						Score <= 8'b00010000;
						end
						else begin
						state <= Loss;
						end
					end
					else if (third_disp == 2'b11) begin
						if(switch_position == 4'b0010) begin
						Stage2 <= switch_position;
						nextState <= Round3;
						state <= Wait;
						Score <= 8'b00010000;
						end
						else begin
						state <= Loss;
						end
					end
					else begin
						if(switch_position == 4'b0001) begin
						Stage2 <= switch_position;
						nextState <= Round3;
						state <= Wait;
						Score <= 8'b00010000;
						end
						else begin
						state <= Loss;
						end
					end					
				end
				else if (main_disp == 2'b01) begin
					if(switch_position == Stage1) begin
						Stage2 <= switch_position;
						nextState <= Round3;
						state <= Wait;
						Score <= 8'b00010000;
					end
					else begin
						state <= Loss;
					end
				end
				else if (main_disp == 2'b10) begin
					if(switch_position == 4'b1000) begin
						Stage2 <= switch_position;
						nextState <= Round3;
						state <= Wait;
						Score <= 8'b00010000;
					end
					else begin
						state <= Loss;
					end
				end
				else begin
					if(switch_position == 4'b0100) begin
						Stage2 <= switch_position;
						nextState <= Round3;
						state <= Wait;
						Score <= 8'b00010000;
					end
					else begin
						state <= Loss;
					end
				end
				end
				else begin
					state <= Round2;
				end
				end
				Round3: begin
				if(button == 1'b1) begin
				screen_test <= screen_done;
				if(main_disp == 2'b00) begin
					if(switch_position == Stage2) begin
						Stage3 <= switch_position;
						nextState <= Round4;
						state <= Wait;
						Score <= 8'b00010101;
					end
					else begin
						state <= Loss;
					end
									
				end
				else if (main_disp == 2'b01) begin
					if(switch_position == Stage1) begin
						Stage3 <= switch_position;
						nextState <= Round4;
						state <= Wait;
						Score <= 8'b00010101;
					end
					else begin
						state <= Loss;
					end
				end
				else if (main_disp == 2'b10) begin
					if(switch_position == 4'b0010) begin
						Stage3 <= switch_position;
						nextState <= Round4;
						state <= Wait;
						Score <= 8'b00010101;
					end
					else begin
						state <= Loss;
					end
				end
				else begin
					if(first_disp == 2'b11) begin
						if(switch_position == 4'b1000) begin
						Stage3 <= switch_position;
						nextState <= Round4;
						state <= Wait;
						Score <= 8'b00010101;
						end
						else begin
						state <= Loss;
						end
					end
					else if (second_disp == 2'b11) begin
						if(switch_position == 4'b0100) begin
						Stage3 <= switch_position;
						nextState <= Round4;
						state <= Wait;
						Score <= 8'b00010101;
						end
						else begin
						state <= Loss;
						end
					end
					else if (third_disp == 2'b11) begin
						if(switch_position == 4'b0010) begin
						Stage3 <= switch_position;
						nextState <= Round4;
						state <= Wait;
						Score <= 8'b00010101;
						end
						else begin
						state <= Loss;
						end
					end
					else begin
						if(switch_position == 4'b0001) begin
						Stage3 <= switch_position;
						nextState <= Round4;
						state <= Wait;
						Score <= 8'b00010101;
						end
						else begin
						state <= Loss;
						end
					end	
				end
				end
				else begin
					state <= Round3;
				end
				end
				Round4: begin
				if(button == 1'b1) begin
				screen_test <= screen_done;
				if(main_disp == 2'b00) begin
					if(switch_position == Stage1) begin
						state <= Win;
						Score <= 8'b00100000;
					end
					else begin
						state <= Loss;
					end
				end
				else if (main_disp == 2'b01) begin
					if(switch_position == 4'b1000) begin
						state <= Win;
						Score <= 8'b00100000;
					end
					else begin
						state <= Loss;
					end
				end
				else if (main_disp == 2'b10) begin
					if(switch_position == Stage2) begin
						state <= Win;
						Score <= 8'b00100000;
					end
					else begin
						state <= Loss;
					end
				end
				else begin
					if(switch_position == Stage3) begin
						state <= Win;
						Score <= 8'b00100000;
					end
					else begin
						state <= Loss;
					end
				end
				end
				else begin
					state <= Round4;
				end
				end
				Win: begin
					check <= 2'b10;
					Game_Complete <= 1'b0;
					//nextState <= Restart;
					state <= Restart;
				end
				Loss: begin
					check <= 2'b01;
					Game_Complete <= 1'b0;
					//nextState <= Restart;
					state <= Restart;
				end
				Restart: begin
					Game_Complete <= 1'b1; 
					state <= Init;
				end			
				default: begin
					state <= Init;
				end
			endcase
		end
	end
			
				

endmodule
