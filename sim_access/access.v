// ECE 5440
// Shasta GuideBot Model S
// Multi-User Access Control Module
// This module will create a user authentication system for the
// Bomb Defuse game. A player will have to be identified and then
// log in correctly with the proper password before playing. 

module access(clk, rst, push, random_in, answer_in, id_in, pass_in, random_out, answer_out, id_out, pass_out, red_id, red_pass, green_id, green_pass, red_timeout, timeout, enable, reconfig, q_id, q_pass, address_id, address_pass);

	input clk, rst, push, random_in, answer_in, timeout;
// USER ID LIST
// Leandro = 9489 = 4'b1001, 4'b0100, 4'b1000, 4'b1001
// Shivam = 3842 = 4'b0011, 4'b1000, 4'b0100, 4'b0010
// Emilio = 8321 = 4'b1000, 4'b0011, 4'b0010, 4'b0001
// Rafael = 5114 = 4'b1001, 4'b0001, 4'b0001, 4'b0100
// Son  = 5297 = 4'b1001, 4'b0010, 4'b1001, 4'b0111
// Guest = 1234 = 4'b0001, 4'b0010, 4'b0011, 4'b0100
	input [3:0] id_in, pass_in; 
	input [15:0] q_id;
	input [19:0] q_pass;
// USER PASSWORD LIST
// Leandro = 77777 = 4'b0111, 4'b0111, 4'b0111, 4'b0111, 4'b0111
// Shivam = 11111 = 4'b0001, 4'b0001, 4'b0001, 4'b0001, 4'b0001
// Emilio = FFFFF = 4'b1111, 4'b1111, 4'b1111, 4'b1111, 4'b1111
// Rafael = ABCDE = 4'b1010, 4'b1011, 4'b1100, 4'b1101, 4'b1110
// Son = 07734 = 4'b0000, 4'b0111, 4'b0111, 4'b0011, 4'b0100
// Guest = 12345 = 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101
	
	output reg random_out, answer_out, red_id, red_pass, green_id, green_pass, red_timeout, enable, reconfig;
	output reg [3:0] address_id, address_pass;
	output reg [15:0] id_out;
	output reg [19:0] pass_out;
	reg [4:0] state;
// Need a verification flag to make sure the correct inputs were put in
	reg verify_id, verify_pass;
	reg [15:0] rom_id;
	reg [19:0] rom_pass;
// Need a retry flag to make sure the user only gets 3 tries to enter a password
	reg [1:0] retry;
	
	parameter s_ram_init = 5'b00000, s_enter_id = 5'b00001, s_wait_1_id = 5'b00010, s_wait_2_id = 5'b00011, s_rom_id = 5'b00100, s_compare_id = 5'b00101, s_inc_id = 5'b00110, s_check_id = 5'b00111, s_done_id = 5'b01000, s_enter_pass = 5'b01001, s_wait_1_pass = 5'b01010, s_wait_2_pass = 5'b01011, s_rom_pass = 5'b01100, s_compare_pass = 5'b01101, s_inc_pass = 5'b01110, s_check_pass = 5'b01111, s_done_pass = 5'b10000, s_reconfig = 5'b10001, s_wait = 5'b10010, s_gameplay = 5'b10011, s_gameover = 5'b10100;
	
// id check, password check, game difficulty reconfiguration, wait for start, gameplay, and game over 
	always @ (posedge clk)
		begin
			if (rst == 0)
				begin
					verify_id <= 1'b1;
					verify_pass <= 1'b1;
					red_id <= 1'b0;
					red_pass <= 1'b0;
					red_timeout <= 1'b0;
					green_id <= 1'b0;
					green_pass <= 1'b0;
					random_out <= 1'b0;
					answer_out <= 1'b0;
					pass_out <= 4'b0000;
					enable <= 1'b0;
					reconfig <= 1'b0;
					address_id <= 4'b0000;
					address_pass <= 4'b0000;
					state <= s_ram_init;
				end
				
			else 
				begin
					case (state) 
					
// Initilize RAM for score tracking
						s_ram_init : 	begin
											state <= s_enter_id;
										end
									
// Catch the entered player ID
						s_enter_id :	begin
											red_id <= 1'b1;
											enable <= 1'b0; 
											reconfig <= 1'b0;
											
											if (push == 1'b1)
												begin
													id_out[15:12] <= id_in;
													
													if (push == 1'b1)
														begin
															id_out[11:8] <= id_in;
															
															if (push == 1'b1)
																begin
																	id_out[7:4] <= id_in;
																
																	if (push == 1'b1)
																		begin
																			id_out[3:0] <= id_in;
																			state <= s_wait_1_id;
																		end
																end
														end
												end
										
											else 
												begin
													state <= s_enter_id;
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
											if (id_out == rom_id)
												begin
													state <= s_done_id;
												end
											else 
												begin
													if (address_id == 4'b1000)
														begin
															red_id <= 1'b1;
															green_id <= 1'b0;
															state <= s_enter_id;
														end
													else 
														begin
															address_id <= address_id + 4'b0001;
															state <= s_wait_1_id;
														end
												end
										end
										
// Let user know the entered ID was verified and they can now enter a password
						s_done_id :		begin
											red_id <= 1'b0;
											green_id <= 1'b1;
											state <= s_enter_pass;
										end
										
// Catch the entered player password 
						s_enter_pass :	begin
											red_pass <= 1'b1;
											
											if (push == 1'b1)
												begin
													pass_out[19:16] <= pass_in;
													
													if (push == 1'b1)
														begin
															pass_out[15:12] <= pass_in;
															
															if (push == 1'b1)
																begin
																	pass_out[11:8] <= pass_in;
																
																	if (push == 1'b1)
																		begin
																			pass_out[7:4] <= pass_in;
																		
																			if (push == 1'b1)
																				begin
																					pass_out[3:0] <= pass_in;
																					state <= s_wait_1_pass;
																				end
																		end
																end
														end
												end
										
											else 
												begin
													state <= s_enter_pass;
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
						s_compare_id :	begin
											if (pass_out == rom_pass)
												begin
													state <= s_done_pass;
												end
											else 
												begin
													if (address_pass == 4'b1000)
														begin
															red_pass <= 1'b1;
															green_pass <= 1'b0;
															state <= s_enter_pass;
														end
													else 
														begin
															address_pass <= address_pass + 4'b0001;
															state <= s_wait_1_pass;
														end
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
											random_out <= 1'b0;
											answer_out <= 1'b0;
											enable <= 1'b0;
											reconfig <= 1'b0;
											
											if (push == 1'b1)
												begin
													reconfig <= 1'b1;
													state <= s_wait;
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
											random_out <= 1'b0;
											answer_out <= 1'b0;
											
											if (push == 1'b1)
												begin
													state <= s_gameplay;
												end
											else 
												begin
													state <= s_wait;
												end
										end
										
// Gameplay has commenced
						s_gameplay : 	begin
											reconfig <= 1'b0;
											
											if (timeout == 1'b0)
												begin
													random_out <= random_in;
													answer_out <= answer_in;
													enable <= 1'b1;
													state <= s_gameplay;
												end
											else
												begin
													state <= s_gameover;
												end
										end
										
// The game ran out of time. Allow for another session if desired
						s_gameover : 	begin
											random_out <= 1'b0;
											answer_out <= 1'b0;
											enable <= 1'b0;
											red_timeout <= 1'b1;
											
											if (push == 1'b1)
												begin
													state <= s_reconfig;
												end
											else 
												begin
													state <= s_gameover;
												end
										end
										
// Loop back into ID enter state if any discrepancies occur
						default :		begin
											state <= s_enter_id;
											verify_id <= 1'b1;
											verify_pass <= 1'b1;
											red_id <= 1'b0;
											red_pass <= 1'b0;
											red_timeout <= 1'b0;
											green_id <= 1'b0;
											green_pass <= 1'b0;
											random_out <= 1'b0;
											answer_out <= 1'b0;
											pass_out <= 4'b0000;
											enable <= 1'b0;
											reconfig <= 1'b0;
											address_id <= 4'b0000;
											address_pass <= 4'b0000;
										end
						endcase
					end
		end
endmodule 
											