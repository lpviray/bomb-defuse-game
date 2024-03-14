// Course:ECE5440
// Author: Emilio Baguioro (1038321)
// Seven_Seg 
// Using a 4-bit input, a 7-bit output is created that is correlated
// to creating the value within the seven segment display
module Seven_Seg (Seg_in, Seg_out);

	input [3:0] Seg_in;
	output [6:0] Seg_out;
	reg [6:0] Seg_out;

	always @ (Seg_in) begin
		case (Seg_in)
		4'b0000: // 0
			begin 
				Seg_out = 7'b1000000;
			end
		4'b0001: // 1
			begin
				Seg_out = 7'b1111001;
			end
		4'b0010: // 2
			begin 
				Seg_out = 7'b0100100;
			end
		4'b0011: // 3
			begin
				Seg_out = 7'b0110000;
			end
		4'b0100: // 4
			begin
				Seg_out = 7'b0011001;
			end
		4'b0101: // 5
			begin
				Seg_out = 7'b0010010;
			end
		4'b0110: // 6
			begin
				Seg_out = 7'b0000010;
			end
		4'b0111: // 7
			begin
				Seg_out = 7'b1111000;
			end
		4'b1000: // 8
			begin 
				Seg_out =7'b0000000;
			end
		4'b1001: // 9
			begin
				Seg_out = 7'b0010000;
			end
		4'b1010: // 10
			begin
				Seg_out = 7'b0001000;
			end
		4'b1011: // 11
			begin 
				Seg_out = 7'b0000011;
			end
		4'b1100: // 12
			begin
				Seg_out = 7'b1000110;
			end
		4'b1101: // 13
			begin
				Seg_out = 7'b0100001;
			end
		4'b1110: // 14
			begin
				Seg_out = 7'b0000110;
			end
		4'b1111: // 15
			begin
				Seg_out = 7'b0001110;
			end
		default: 
			begin
				Seg_out = 7'b1000000;
			end
		endcase
	end
endmodule
	
