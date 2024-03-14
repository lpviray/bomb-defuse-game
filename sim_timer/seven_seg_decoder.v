// TEAM: Shasta GuideBot Model S
// Module: seven_seg_decoder
// Description:
// This module takes a four bit input and decodes the binary input to a visual output 
// displayed on a seven segment display on the FPGA.

module seven_seg_decoder(seg_in, seg_out);
	
	input [3:0] seg_in;
	output [6:0] seg_out;
	reg [6:0] seg_out;
	
	always @ (seg_in) begin
		case(seg_in)
			4'b0000: //0
				begin
					seg_out = 7'b1000000;
				end
			4'b0001: //1
				begin
					seg_out = 7'b1001111;
				end
			4'b0010: //2
				begin
					seg_out = 7'b0100100;
				end
			4'b0011: //3
				begin
					seg_out = 7'b0110000;
				end
			4'b0100: //4
				begin
					seg_out = 7'b0011001;
				end
			4'b0101: //5
				begin
					seg_out = 7'b0010010;
				end
			4'b0110: //6
				begin
					seg_out = 7'b0000010;
				end
			4'b0111: //7
				begin
					seg_out = 7'b1111000;
				end
			4'b1000: //8
				begin
					seg_out = 7'b0000000;
				end
			4'b1001: //9
				begin
					seg_out = 7'b0011000;
				end
			4'b1010: //A
				begin
					seg_out = 7'b0001000;
				end
			4'b1011: //b
				begin
					seg_out = 7'b0000011;
				end
			4'b1100: //c
				begin
					seg_out = 7'b0100111;
				end
			4'b1101: //d
				begin
					seg_out = 7'b0100001;
				end
			4'b1110: //E
				begin
					seg_out = 7'b0000110;
				end
			4'b1111: //F
				begin
					seg_out = 7'b0001110;
				end
			default: //-
				begin
					seg_out = 7'b0111111;
				end
		endcase
	end
endmodule
