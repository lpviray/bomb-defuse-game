module FinalProject_ShastaGuideBotModelS(
	// Inputs
		// 
		rst, clk, 
		
		// Game Buttons (pass_btn is for entering ID and Password, reconfiguring time, setting time)
		// (game_btn is specific for gameplay and for logging out)
		// (high_btn is specific for displaying high score) 
		pass_btn, game_btn, high_btn,
	
		// ID 
		idpass_switches,
	
		// Gameplay switches
		game_switches,

		// Timer (Configures level control which will set the timer automatically) 
		timer_switches,
	// Outputs
		
		// Timer
		timer_tens_display, timer_ones_display,
		// ID / Password / Game / Ones place of Max Score
		main_display, alt_display, first_display, second_display, third_display, fourth_display,
		// LEDs
		ID_RED, ID_GREEN, PASS_RED, PASS_GREEN,GAME_OVER_LED);
		
	// Inputs
	input rst, clk;
	input pass_btn, game_btn, high_btn;
	input [3:0] idpass_switches;
	input [3:0] game_switches;
	input [1:0] timer_switches;

	// Outputs
	output [6:0] timer_tens_display, timer_ones_display;
	output [6:0] main_display, alt_display, first_display, second_display, third_display, fourth_display;
	output ID_RED, ID_GREEN, PASS_RED, PASS_GREEN;
	output GAME_OVER_LED; 
	
	
	// Wires
	wire pass_btn_shaped, game_btn_shaped, high_btn_shaped;

	// Coming from access controller
	wire [3:0] main_display_access, alt_display_access, first_display_access, second_display_access, third_display_access, fourth_display_access;
	
	wire [3:0] timer_tens_timer, timer_ones_timer;

	// Memory addresses for ROM
	wire [2:0] ID_address,PASS_address,RAM_address; 
	wire write_enable;
	wire [19:0] PASS_out; 
	wire [15:0] ID_out;
	wire [7:0] SCORE_in, SCORE_out;
	

	// Wires from game design
	wire game_enable, game_complete_game;
	wire [1:0] main_display_game, first_display_game, second_display_game, third_display_game, fourth_display_game;
	wire [7:0] player_score_game;

	// Wires from difficulty module
	wire [3:0] timer_tens_diff, timer_ones_diff;
	wire [1:0] multiplier_diff;
	wire diff_enable;
	

	// Wires from timer module
	wire timeout_timer;

	// Wires from access controller
	wire timer_enable_access;
	wire timer_enable2_access;
	wire time_error_access;

	// Modules to instantiate
	// 3 button shaper, 7 segment display, access controller, timer module, game design module, difficulty module
	// 2 ROMS, 1 RAM modules
	
	// Buttons
	button_shaper password(pass_btn, clk, rst, pass_btn_shaped);
	button_shaper gameplay(game_btn, clk, rst, game_btn_shaped);
	button_shaper maxscore(high_btn, clk, rst, high_btn_shaped);

	// Displays
	// flipped alt and main
	Seven_Seg main(main_display_access,alt_display);
	Seven_Seg alt(alt_display_access,main_display);
	Seven_Seg first(first_display_access,first_display);
	Seven_Seg second(second_display_access,second_display);
	Seven_Seg third(third_display_access,third_display);
	Seven_Seg fourth(fourth_display_access,fourth_display);
	Seven_Seg timer_ten(timer_tens_timer, timer_tens_display);
	Seven_Seg timer_one(timer_ones_timer, timer_ones_display);

	// Memory 
	ROM_PASS password_ROM(PASS_address,clk,PASS_out);
	ROM_ID id_ROM(ID_address,clk,ID_out);
	RAM scores(RAM_address, clk, SCORE_in, write_enable, SCORE_out);
	

	// Game Design
	Game_Design game(rst, clk, game_btn_shaped, game_switches, game_enable, first_display_game, second_display_game, third_display_game, fourth_display_game, main_display_game, player_score_game, game_complete_game);

	// Timer and level difficulty modules
	// Check if to use game_complete_game or game_complete_access
	level_control difficulty_set(clk, rst, diff_enable, timer_switches, timer_tens_diff, timer_ones_diff, multiplier_diff);
	digit_timer_top game_timer(rst, clk, time_error_access, timer_tens_diff, timer_ones_diff, timer_enable_access, timer_tens_timer, timer_ones_timer, timeout_timer);
	// third param was time_error_access
	
	

	// Access controller
	access access_top(clk, rst, pass_btn_shaped, idpass_switches, idpass_switches, ID_RED, PASS_RED, ID_GREEN, PASS_GREEN, GAME_OVER_LED, timeout_timer, game_enable, diff_enable, timer_enable_access, time_error_access, game_complete_game, multiplier_diff, ID_out, PASS_out, ID_address, PASS_address, high_btn_shaped, player_score_game, game_btn_shaped, first_display_game, second_display_game, third_display_game, fourth_display_game, main_display_game, main_display_access, alt_display_access, first_display_access, second_display_access, third_display_access, fourth_display_access, SCORE_out, SCORE_in, write_enable, RAM_address);





endmodule


	