// ECE 5440
// Shasta GuideBot Model S
// LSFR Four Screen Display
// Sets up gamescreens for gameplay. Each screen will have random value from 0 to 3. 
// Four Display values with have random value and none will be the same. 

module LFSR_Four_Screens(CLK,RST,Button,First_Screen,Second_Screen,Third_Screen,Fourth_Screen,Main_Screen,Screen_Done);

	input CLK, RST, Button;
	output [1:0] First_Screen,Second_Screen,Third_Screen,Fourth_Screen, Main_Screen;
	reg [1:0] First_Screen,Second_Screen,Third_Screen,Fourth_Screen, Main_Screen;
	wire [1:0] Random;
	reg Pulse;
	output Screen_Done;
	reg Screen_Done;
	
	lfsr_rng DUT_lfsr_rng(CLK,RST,Pulse,Random);
	

	parameter Init = 4'b0000, SetFirst = 4'b0001, SetSecond = 4'b0010, SetThird = 4'b0011, SetFourth = 4'b0100, SetMain= 4'b0101, Wait = 4'b0110, Wait2 = 4'b0111;
	
	reg [3:0] State, LastState, NextState;


	always @ (posedge CLK) begin
		if(RST == 1'b0) begin
			First_Screen <= 2'b00;
			Second_Screen <= 2'b00;
			Third_Screen <= 2'b00;
			Fourth_Screen <= 2'b00;
			Main_Screen <= 2'b00;
			Pulse <= 1'b0;
			Screen_Done <= 1'b0;
		end
		else begin
			case(State) 
				Init: begin
				if(Button == 1'b1) begin
					Screen_Done <= 1'b0;
					Pulse <= 1'b1;
					State <= SetFirst;
				end
				else begin
					State <= Init;
				end
				end
				SetFirst: begin
					Pulse <= 1'b0;
					First_Screen <= Random;
					NextState <= SetSecond;
					State <= Wait;
				end
				Wait: begin
					Pulse <= 1'b1;
					State <= Wait2;
				end
				Wait2: begin
					Pulse <= 1'b0;
					State <= NextState;
				end
				SetSecond: begin
					if(Random == First_Screen) begin
						NextState <= SetSecond;
						State <= Wait;
					end
					else begin
						Second_Screen <= Random;
						NextState <= SetThird;
						State <= Wait;
					end
				end
				SetThird: begin
					if((Random == Second_Screen) || (Random == First_Screen)) begin
						NextState <= SetThird;
						State <= Wait;
					end
					else begin
						Third_Screen <= Random;
						NextState <= SetFourth;
						State <= Wait;
					end
				end
				SetFourth: begin	
					if((Random == Third_Screen) || (Random == Second_Screen) || (Random == First_Screen)) begin
						NextState <= SetFourth;
						State <= Wait;
					end
					else begin
						Fourth_Screen <= Random;	
						NextState <= SetMain;
						State <= Wait;
					end
				end
				SetMain: begin
					Main_Screen <= Random;
					Screen_Done <= 1'b1;
					State <= Init;
				end
				default: begin	
					State <= Init;
				end
			endcase
		end
	end

endmodule

			
		
					
					
				
			
