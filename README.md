# bomb-defuse-game
This is a 2 player cooperative game with the goal of having one player defuse a bomb based on the instructions of another player before the time runs out. This game is played on an Altera DE2-115 developmental FPGA board, and involves knowledge of binary numbers to play effectively. As this was a group project, my technical contributions to the project include creating an access control system using a complex finite state machine algorithm in conjunction with the buttons, LEDs, switches, and ROM loader file on the board. Furthermore, I also developed a custom random number generator utilizing a free running 16-bit linear feedback shift register. The game is programmed completely with the Verilog hardware description language.<br/>

A video demonstraction of the game can be viewed here at: [https://drive.google.com/file/d/1Y7pN3T6fMQBQ5Xeo2sp4vJ9jVRI0VJXx/view?usp=sharing](https://drive.google.com/file/d/1Y7pN3T6fMQBQ5Xeo2sp4vJ9jVRI0VJXx/view?usp=sharing)

The user manual for how the game is played can be read here at: [https://docs.google.com/document/d/1musIX8NnxoofgyY9qV-8Z59hVW2BQT1ulZodSQ3Of7Q/edit?usp=sharing](https://docs.google.com/document/d/1musIX8NnxoofgyY9qV-8Z59hVW2BQT1ulZodSQ3Of7Q/edit?usp=sharing)

The design documentation for how the game was tested and developed can be read here at: [https://docs.google.com/document/d/1Q9krNVxX1oPK5uylUnpgJs5nDEiaaaKsB6kO8qklem0/edit?usp=sharing](https://docs.google.com/document/d/1Q9krNVxX1oPK5uylUnpgJs5nDEiaaaKsB6kO8qklem0/edit?usp=sharing)

The various instructions a player can receieve can include:<br/>

Stage 1:</br>
If the display is 0, flip up the 2nd switch.</br>
If the display is 1, flip up the 2nd switch.</br>
If the display is 2, flip up the 3rd switch.</br>
If the display is 3, flip up the 4th switch.<br/>

Stage 2:</br>
If the display is 0, flip up the switch under the display showing “3”.</br>
If the display is 1, flip up the switch that was set in Stage 1.</br>
If the display is 2, flip up the 1st switch.</br>
If the display is 3, flip up the 2nd switch.</br>

Stage 3:</br>
If the display is 0, flip up the switch you flipped in Stage 2.</br>
If the display is 1, flip up the switch you flipped in Stage 1.</br>
If the display is 2, flip up the 3rd switch.</br>
If the display is 3, flip up the switch under the display showing “3”.<br/>

Stage 4:</br>
If the display is 0, flip up the switch you flipped in Stage 1.</br>
If the display is 1, flip up the 1st switch.</br>
If the display is 2, flip up the switch you flipped in Stage 2.</br>
If the display is 3, flip up the switch you flipped in Stage 3.<br/>

# Additional Features
 • Login with specific username and password<br/>
 • ROM based user authentication<br/>
 • RAM based score tracking system<br/>
 • 3 difficulty levels scaling with time available to defuse<br/>

# Technologies Used
 • Verilog<br/>
 • Testbench<br/>
 • Quartus<br/>
 • ModelSim<br/>
 • GitHub<br/>
