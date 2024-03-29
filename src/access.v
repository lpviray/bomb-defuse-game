// ECE 5440
// Shasta GuideBot Model S
// Multi-User Access Control Module
// This module will create a user authentication system for the
// Bomb Defuse game. A player will have to be identified and then
// log in correctly with the proper password before playing. 

module access(clk, rst, push, /*answer_in,*/ id_in, pass_in, /*answer_out,*/ red_id, red_pass, green_id, green_pass, red_timeout, 
	
	timeout, game_enable, reconfig, timer_enable, Timer_Error, Game_Complete, diff_multi,
	
	q_id, q_pass, address_id, address_pass, 

	max_score, score, button, first_disp, second_disp, third_disp, fourth_disp, main_disp,
	
	main_display, alt_display, first_display, second_display, third_display, fourth_display,

	score_check, data_out, write_enable, address_set);

	input clk, rst, push, /*answer_in,*/ timeout, max_score, button;
// USER ID LIST
// Leandro = 9489 = 4'b1001, 4'b0100, 4'b1000, 4'b1001
// Shivam = 3842 = 4'b0011, 4'b1000, 4'b0100, 4'b0010
// Emilio = 8321 = 4'b1000, 4'b0011, 4'b0010, 4'b0001
// Rafael = 5114 = 4'b1001, 4'b0001, 4'b0001, 4'b0100
// Son  = 5297 = 4'b1001, 4'b0010, 4'b1001, 4'b0111
// Guest = 1234 = 4'b0001, 4'b0010, 4'b0011, 4'b0100
	input [3:0] id_in, pass_in;
 	input [7:0] score;
	input [15:0] q_id;
	input [19:0] q_pass;
// USER PASSWORD LIST
// Leandro = 77777 = 4'b0111, 4'b0111, 4'b0111, 4'b0111, 4'b0111
// Shivam = 11111 = 4'b0001, 4'b0001, 4'b0001, 4'b0001, 4'b0001
// Emilio = FFFFF = 4'b1111, 4'b1111, 4'b1111, 4'b1111, 4'b1111
// Rafael = ABCDE = 4'b1010, 4'b1011, 4'b1100, 4'b1101, 4'b1110
// Son = 07734 = 4'b0000, 4'b0111, 4'b0111, 4'b0011, 4'b0100
// Guest = 12345 = 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101
	
	output reg /*answer_out,*/ red_id, red_pass, green_id, green_pass, red_timeout, game_enable, reconfig;
	output reg [2:0] address_id, address_pass;
	reg [15:0] id_out;
	reg [19:0] pass_out;
	reg [5:0] state,nextState;
// Need a verification flag to make sure the correct inputs were put in
	reg verify_id, verify_pass;
	reg [7:0] player_score;
	reg [15:0] rom_id;
	reg [19:0] rom_pass;
// Need a retry flag to make sure the user only gets 3 tries to enter a password
	reg [1:0] retry;

// Multiplier input
	input [1:0] diff_multi;
	reg [1:0] multiplier;
// Variables for screen displays
	input [1:0] first_disp, second_disp, third_disp, fourth_disp, main_disp;
// Display outputs
	// ID/Password/Game (Main Screen)/ Max Score Tens Place
	output reg [3:0] main_display;
	// Max Score Ones Place
	output reg [3:0] alt_display;

	// Game Screen 1, First digit of max score User ID
	output reg [3:0] first_display;
	// Game Screen 1, Second digit of max score User ID
	output reg [3:0] second_display;
	// Game Screen 3, Third digit of max score User ID
	output reg [3:0] third_display; 
	// Game Screen 4, Fourth digit of max score User ID
	output reg [3:0] fourth_display;


	// ID
	reg [3:0] id_1,id_2,id_3,id_4;
	reg [3:0] score_1,score_2,score_3,score_4;
	reg [3:0] maxHighTens, maxHighOnes;
	

// Variables for score tracking
	// input [2:0] UserID;
	//input [7:0] data_in;
	input [7:0] score_check;
	reg [7:0] score_compare;
	//output reg [7:0] high_score;
	output reg [7:0] data_out;
	//
	output reg write_enable;
	output reg [2:0] address_set;
// Variables for calculating score
	reg [3:0] TensScore, OnesScore;
// Variables from game design
	input Game_Complete;
// Variables for digit timer
	output reg timer_enable;
	output reg Timer_Error;
	
	reg RAM_Flag;
	
	parameter s_ram_init = 6'b000000, s_enter_id_1 = 6'b000001, s_enter_id_2 = 6'b000010, s_enter_id_3 = 6'b000011, s_enter_id_4 = 6'b000100, s_wait_1_id = 6'b000101, s_wait_2_id = 6'b000110, s_rom_id = 6'b000111, s_compare_id = 6'b001000, s_done_id = 6'b001001, s_enter_pass_1 = 6'b001010, s_enter_pass_2 = 6'b001011, s_enter_pass_3 = 6'b001100, s_enter_pass_4 = 6'b001101, s_enter_pass_5 = 6'b001110, s_wait_1_pass = 6'b001111, s_wait_2_pass = 6'b010000, s_rom_pass = 6'b010001, s_compare_pass = 6'b010010, s_done_pass = 6'b010011, s_reconfig = 6'b010100, s_wait = 6'b010101, s_gameplay = 6'b010110, s_gameover = 6'b010111;
	// States for RAM
	parameter Init = 6'b011000, Wait1 = 6'b011001, Wait2 = 6'b011010, Finish = 6'b011011, HiScore = 6'b011100, UserMax = 6'b011101;
	// States for score calculating
	parameter ScoreInit = 6'b011110, ScoreMulti = 6'b011111, ScoreDisplay = 6'b100000; 
	//Timer pulses
	parameter timer_enable_pulse1 = 6'b100001, timer_enable_pulse2 = 6'b100010, timer_enable_pulse3 = 6'b100011, timer_enable_pulse4 = 6'b100100; 
	
// id check, password check, game difficulty reconfiguration, wait for start, gameplay, and game over 
	always @ (posedge clk)
		begin
			if (rst == 0)
				begin
					red_id <= 1'b1;
					verify_id <= 1'b1;
					verify_pass <= 1'b1;
					red_id <= 1'b0;
					red_pass <= 1'b0;
					red_timeout <= 1'b0;
					green_id <= 1'b0;
					green_pass <= 1'b0;
					//answer_out <= 1'b0;
					game_enable <= 1'b0;
					reconfig <= 1'b0;
					address_id <= 3'b000;
					address_pass <= 3'b000;
					state <= s_ram_init;
					retry <= 2'b00;
					
					//
					main_display <= 4'b0000;
					alt_display <= 4'b0000;
					first_display <= 4'b0000;
					second_display <= 4'b0000;
					third_display <= 4'b0000;
					fourth_display <= 4'b0000;


					// RAM 
					address_set <= 3'b000;
					data_out <= 8'b00000000;
					write_enable <= 1'b0;
					score_compare <= 8'b00000000;
					
					// Timer
					timer_enable <= 1'b0;
					Timer_Error <= 1'b1;
					RAM_Flag <= 1'b0;
				end
				
			else 
				begin
					case (state) 
					
// Initilize RAM for score tracking
						s_ram_init : 	begin
									if(RAM_Flag == 1'b0)
									begin
										address_set <= 3'b110;
										if(address_set == 3'b110)
										begin
											write_enable <= 1'b1;
											data_out <= 8'b00000000;
											//address_ram <= address_ram + 1;
											RAM_Flag <= 1'b1;
											state <= s_enter_id_1;
										end
									end
									else
										begin
										RAM_Flag <= 1'b1;
										state <= s_enter_id_1;
										end
							
								end
									
// Catch the entered player ID digit 1
						s_enter_id_1 :	begin
											red_id <= 1'b1;
											game_enable <= 1'b0; 
											reconfig <= 1'b0;
											//answer_out <= 1'b0;
											
											if (push == 1'b1)
												begin
													id_out[15:12] <= id_in;
													id_1 <= id_in;
													main_display <= id_in;
													state <= s_enter_id_2;
												end
											else 
												begin
													state <= s_enter_id_1;
												end
										end
// Catch the entered player ID digit 2
						s_enter_id_2 :	begin
											if (push == 1'b1)
												begin
													id_out[11:8] <= id_in;
													id_2 <= id_in;
													main_display <= id_in;
													state <= s_enter_id_3;
												end
											else 
												begin
													state <= s_enter_id_2;
												end
										end

// Catch the entered player ID digit 3
						s_enter_id_3 : 	begin
											if (push == 1'b1)
												begin
													id_out[7:4] <= id_in;
													id_3 <= id_in;
													main_display <= id_in;
													state <= s_enter_id_4;
												end
											else
												begin
													state <= s_enter_id_3;
												end
										end

// Catch the entered player ID digit 4
						s_enter_id_4 :	begin
											if (push == 1'b1)
												begin
													id_out[3:0] <= id_in;
													id_4 <= id_in;
													main_display <= id_in;
													state <= s_wait_1_id;
												end
											else 
												begin
													state <= s_enter_id_4;
												end
										end
	
// Wait one clock cycle for processing
						s_wait_1_id :	begin
											state <= s_wait_2_id;
										end
										
// Wait another clock cycle for processing
						s_wait_2_id :	begin
											state <= s_rom_id;
										end
										
// Catch the ID ROM output for the corresponding address
						s_rom_id :		begin
											rom_id <= q_id;
											state <= s_compare_id;
										end
										
// Compare if the entered player ID is valid 
						s_compare_id :	begin
											red_id <= 1'b1;
											if (id_out == rom_id)
												begin
													state <= s_done_id;
												end
											else 
												begin
													if (address_id == 3'b111)
														begin
															red_id <= 1'b1;
															green_id <= 1'b0;
															state <= s_enter_id_1;
														end
													else 
														begin
															address_id <= address_id + 3'b001;
															state <= s_wait_1_id;
														end
												end
										end
										
// Let user know the entered ID was verified and they can now enter a password
						s_done_id :		begin
											red_id <= 1'b0;
											green_id <= 1'b1;
											address_pass <= address_id;
											retry <= 2'b00;
											state <= s_enter_pass_1;
										end
										
// Catch the entered player password digit 1
						s_enter_pass_1 : begin
											red_pass <= 1'b1;
											if (push == 1'b1)
												begin
													pass_out[19:16] <= pass_in;
													main_display <= pass_in;
													state <= s_enter_pass_2;
												end
											else 
												begin
													state <= s_enter_pass_1;
												end
										end

// Catch the entered player password digit 2
						s_enter_pass_2 : begin
											if (push == 1'b1)
												begin
													pass_out[15:12] <= pass_in;
													main_display <= pass_in;
													state <= s_enter_pass_3;
												end
											else 
												begin
													state <= s_enter_pass_2;
												end
										end

// Catch the entered player password digit 3
						s_enter_pass_3 : begin
											if (push == 1'b1)
												begin
													pass_out[11:8] <= pass_in;
													main_display <= pass_in;
													state <= s_enter_pass_4;
												end
											else 
												begin
													state <= s_enter_pass_3;
												end
										end

// Catch the entered player password digit 4
						s_enter_pass_4 : begin
											if (push == 1'b1)
												begin
													pass_out[7:4] <= pass_in;
													main_display <= pass_in;
													state <= s_enter_pass_5;
												end
											else 
												begin
													state <= s_enter_pass_4;
												end
										end

// Catch the entered player password digit 5
						s_enter_pass_5 : begin
											if (push == 1'b1)
												begin
													pass_out[3:0] <= pass_in;
													main_display <= pass_in;
													state <= s_wait_1_pass;
												end
											else 
												begin
													state <= s_enter_pass_5;
												end
										end

// Wait one clock cycle for processing
						s_wait_1_pass :	begin
											state <= s_wait_2_pass;
										end
										
// Wait another clock cycle for processing
						s_wait_2_pass :	begin
											state <= s_rom_pass;
										end
											
// Catch the ID ROM output for the corresponding address
						s_rom_pass :	begin
											rom_pass <= q_pass;
											state <= s_compare_pass;
										end
										
// Compare if the entered player ID is valid 
						s_compare_pass : begin
											if (pass_out == rom_pass)
												begin
													state <= s_done_pass;
												end
											else if (retry == 2'b10)
												begin
													red_pass <= 1'b0;
													green_pass <= 1'b0;
													address_id <= 3'b000;
													state <= s_enter_id_1;
												end
											else 
												begin
													red_pass <= 1'b1;
													green_pass <= 1'b0;
													pass_out <= 20'b00000000000000000000;
													retry <= retry + 2'b01;
													state <= s_enter_pass_1;
												end
										end
										
// Let user know the entered password was verified and they can now play the game
						s_done_pass :	begin
											red_pass <= 1'b0;
											green_pass <= 1'b1;
											state <= s_reconfig;
										end
										
// Let user choose game difficulty 
						s_reconfig :	begin
											red_timeout <= 1'b0;
											//answer_out <= 1'b0;
											game_enable <= 1'b0;
											reconfig <= 1'b0;
											Timer_Error <= 1'b1;
											if (push == 1'b1)
												begin
													//timer_enable <= 1'b1;
													reconfig <= 1'b1;
													multiplier <= diff_multi;
													 state <= s_wait;
													//state <= s_gameplay;
												end
											else 
												begin
													reconfig <= 1'b0;
													state <= s_reconfig;
												end
										end
										
// Wait for player to be ready to actually play the game
						s_wait :		begin
											reconfig <= 1'b0;
											//timer_enable <= 1'b0;
											//answer_out <= 1'b0;
											
											if (push == 1'b1)
												begin
								
													// changed from 0 to 1
													//timer_enable <= 1'b1;
													//signal to start timer needs two pulses
													state <= timer_enable_pulse1;
													
												end
											else 
												begin
													state <= s_wait;
												end
										end
						timer_enable_pulse1: begin
										timer_enable <= 1'b1;
										state <= timer_enable_pulse2;
											end
						timer_enable_pulse2: begin
										timer_enable <= 1'b0;
										state <= timer_enable_pulse3;
											end
						timer_enable_pulse3: begin
										timer_enable <= 1'b1;
										state <= timer_enable_pulse4;
											end
						timer_enable_pulse4: begin
										timer_enable <= 1'b0;
										state <= s_gameplay;
											end
											
// Gameplay has commenced
						s_gameplay : 	begin
											reconfig <= 1'b0;
											timer_enable <= 1'b0;
												if (timeout == 1'b0)
												begin
													begin
														//answer_out <= answer_in;
														game_enable <= 1'b1;
														first_display <= first_disp;
														second_display <= second_disp;
														third_display <= third_disp;
														fourth_display <= fourth_disp;
														main_display <= main_disp;
														state <= s_gameplay;
													end
													if(Game_Complete == 1'b0)
													begin
														//
														//timer_enable <= 1'b0;
														Timer_Error <= 1'b0;
														player_score <= score;
														state <= ScoreInit;
													end
												end
												else
													begin
														//
														//timer_enable <= 1'b0;
														Timer_Error <= 1'b0;
														player_score <= score;
														state <= ScoreInit;
													end
											
								end
                    
                    
// Score calculating after game is over

						ScoreInit: begin
								TensScore <= player_score[7:4];
								OnesScore<= player_score[3:0];
								state <= ScoreMulti;
							   end
						ScoreMulti: begin
							if(multiplier == 2'b01)
								begin
								state <= ScoreDisplay;
								end
							else if (multiplier == 2'b10)
								begin
									if(OnesScore == 4'b0101)
										begin 
										OnesScore <= 4'b0000;
										TensScore <= ((TensScore+TensScore)+1);
										state <= ScoreDisplay;
										end 
									else
										begin
										OnesScore <= 4'b0000;
										TensScore <= TensScore+TensScore;
										state <= ScoreDisplay;
										end
								end
							else 
								begin
									if(OnesScore == 4'b0101)
										begin
										OnesScore <= 4'b0101;
										TensScore <= ((TensScore+TensScore+TensScore)+1);
										state <= ScoreDisplay;
										end
									else
										begin
										OnesScore <= 4'b0000;
										TensScore <= TensScore+TensScore+TensScore;
										state <= ScoreDisplay;
										end
								end
							end

						ScoreDisplay: begin
							// flipped main and alt
							alt_display <= TensScore;
							main_display <= OnesScore;
							state <= Init;
							end

// Update score for users

						Init :		begin
											address_set <= address_id;
											write_enable <= 1'b1;
											score_compare <= player_score;
											nextState <= UserMax;
											state <= Wait1;
								end
						Wait1:		begin
											state <= Wait2;
								end
						Wait2: 		begin
											state <= nextState;
								end
						UserMax: 	begin
											
											if(score_check > score_compare) begin
													write_enable <= 1'b0;
													state <= Finish;
											end
											else begin
													data_out <= score_compare;
													nextState <= HiScore;
													state <= Wait1;
											end
								end	
						Finish: 	begin
										
											write_enable <= 1'b0;
											state <= s_gameover; // CHANGE
								end
						HiScore: 	begin
											write_enable <= 1'b0;
											address_set <= 3'b110;
											if(score_check > score_compare) begin
													//nextState <= Finish;
													write_enable <= 1'b0;
													state <= Finish;
											end
											else begin
													write_enable <= 1'b1;
													data_out <= score_compare;
													maxHighTens <= score_compare [7:4];
													maxHighOnes <= score_compare [3:0];
													score_1 <= id_1;
													score_2 <= id_2;
													score_3 <= id_3;
													score_4 <= id_4;
													nextState <= Finish;
													state <= Wait1;
											end
	
								end
		
// The game ran out of time. Allow for another session if desired or you can logout
						s_gameover : 	begin
											multiplier <= 2'b00;
											//answer_out <= answer_in;
											game_enable <= 1'b0;
											red_timeout <= 1'b1;
											
											if (max_score == 1'b1) 
												begin
													main_display <= maxHighTens;
													alt_display <= maxHighOnes;
													first_display <= score_1;
													second_display <= score_2;
													third_display <= score_3;
													fourth_display <= score_4;											
												end
											else if	(button == 1'b1)
												begin
												   red_id <= 1'b1;
													red_timeout <= 1'b0;
													green_id <= 1'b0;
													green_pass <= 1'b0;
													state <= s_enter_id_1;

												end
											else if (push == 1'b1)
												begin
													red_timeout <= 1'b0;
													state <= s_reconfig;
												end
											else 
												begin
													state <= s_gameover;
												end
										end
										
// Loop back into ID enter state if any discrepancies occur
						default :		begin
											red_id <= 1'b1;
											state <= s_enter_id_1;
											verify_id <= 1'b1;
											verify_pass <= 1'b1;
											red_id <= 1'b0;
											red_pass <= 1'b0;
											red_timeout <= 1'b0;
											green_id <= 1'b0;
											green_pass <= 1'b0;
											//answer_out <= 1'b0;
											pass_out <= 4'b0000;
											game_enable <= 1'b0;
											reconfig <= 1'b0;
											address_id <= 4'b0000;
											address_pass <= 4'b0000; 
										end
						endcase
					end
		end
endmodule 
											
