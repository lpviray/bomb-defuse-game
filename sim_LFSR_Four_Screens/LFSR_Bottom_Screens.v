module LFSR_Bottom_Screens(Clk,Rst,Button,First_Screen,Second_Screen,Third_Screen,Fourth_Screen);
input Clk, Rst, Button;
output [1:0] First_Screen,Second_Screen,Third_Screen,Fourth_Screen;
reg [1:0] First_Screen,Second_Screen,Third_Screen,Fourth_Screen;
wire [1:0] Random;
reg Pulse;
lfsr_rng DUT_lfsr_rng(Clk,Rst,Pulse,Random);

parameter Init = 4'b0000, Display1 = 4'b0001, Wait1 = 4'b0010, Wait1Again = 4'b0011, Display2 = 4'b0100, Wait2 = 4'b0101, Wait2Again = 4'b0110, Display3 = 4'b0111, Wait3 = 4'b1000, Wait3Again = 4'b1001, Display4 = 4'b1010, Wait4 = 4'b1011;   

reg[3:0] State;

always @(posedge Clk)
	if (Rst == 0)
		begin
		First_Screen  <= 2'b0;
		Second_Screen <= 2'b0;
		Third_Screen <= 2'b0;
		Fourth_Screen <= 2'b0;
		Pulse <= 0;
		end
	else
		case(State)
			Init:begin
				if(Button == 1)
				begin
				Pulse <= 1;
				State <= Display1;
				end
				else
				State<=Init;
				end
			Display1:begin
				First_Screen <= Random;
				State<=Wait1;
				end
			Wait1:begin
				Pulse <= 0;
				State <= Wait1Again;
				end 
			Wait1Again:begin
				Pulse <= 1;
				State <= Display2;
				end
			Display2:begin
				if(Random == First_Screen)
					State<=Wait1;
				else
				begin
				Second_Screen <= Random;
				State<= Wait2;
				end
				end
			Wait2:begin
				Pulse <= 0;
				State <= Wait2Again;
				end 
			Wait2Again:begin
				Pulse <= 1;
				State <= Display3;
				end
			Display3:begin
				if((Random == First_Screen) || (Random == Second_Screen))
					State<=Wait2;
				else
				begin
				Third_Screen <= Random;
				State<= Wait3;
				end
				end
			Wait3:begin
				Pulse <= 0;
				State <= Wait3Again;
				end 
			Wait3Again:begin
				Pulse <= 1;
				State <= Display4;
				end
			Display4:begin
				if((Random == First_Screen) || (Random == Second_Screen) || (Random == Third_Screen))
					State<=Wait3;
				else
				begin
				Fourth_Screen <= Random;
				State<= Wait4;
				end
				end
			Wait4:begin
				Pulse <= 0;
				State <= Init;
				end
			default:begin
				State <= Init;
				end
		endcase
endmodule
