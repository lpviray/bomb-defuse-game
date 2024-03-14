module Game_Top(RST, CLK, random_btn, set_btn, switch_pos, game_enable, checklight, period,first_display, second_display, third_display, fourth_display, main_display);

	input RST, CLK;
	input random_btn, set_btn;
	input [3:0] switch_pos;
	input game_enable;
	output [1:0] checklight;
	output [7:0] period;

	wire [1:0] first, second, third, fourth;
	output [1:0] first_display, second_display, third_display, fourth_display, main_display;

	LFSR_Four_Screens DUT_Four_Screens(CLK, RST, random_btn, first, second, third, fourth, period);
	Game_Design DUT_Game_Design(RST,CLK, random_btn, set_btn, switch_pos,game_enable, first_display, second_display, third_display,fourth_display, main_disp, checklight, period, first, second, third, fourth);


endmodule
