// TEAM: Shasta GuideBot Model S
// Module: lfsr_uno_ms 
// Description: 
// This module computes one [ms] using a LFSR register. 

module lfsr_uno_ms(rst, clk 
	// , q 
	, uno_ms_timeout
	// , count
	);
	
	input rst, clk;
	output uno_ms_timeout;
	reg uno_ms_timeout;
		 // output [15:0] q;
		 // reg [15:0] q;		
		 // output [15:0] count;	
		 // reg [15:0] count; // counts up to 49,999 = 1100 0011 0100 1111
	
	reg [15:0] LFSR;
  	wire feedback = LFSR[15];

  	always @(posedge clk) begin
	   if(rst == 1'b0) begin
	         // q <= 16'b0000_0000_0000_0000;
	         // count <= 16'b0000_0000_0000_0000;
	      LFSR <= 16'b0000_0000_0000_0000;
	      uno_ms_timeout <= 1'b0;
	   end
	   else begin
	      LFSR[0] <= feedback;
	      LFSR[1] <= LFSR[0];
	      LFSR[2] <= LFSR[1] ~^ feedback;
	      LFSR[3] <= LFSR[2] ~^ feedback;
	      LFSR[4] <= LFSR[3];
	      LFSR[5] <= LFSR[4] ~^ feedback;
	      LFSR[6] <= LFSR[5];
	      LFSR[7] <= LFSR[6];
	      LFSR[8] <= LFSR[7];
	      LFSR[9] <= LFSR[8];
	      LFSR[10] <= LFSR[9];
	      LFSR[11] <= LFSR[10];
	      LFSR[12] <= LFSR[11];
	      LFSR[13] <= LFSR[12];
	      LFSR[14] <= LFSR[13];
	      LFSR[15] <= LFSR[14];

	      // if(LFSR == 16'b0000_0000_0111_0100) begin // 116: 2 cycles
	      // if(LFSR == 16'b1111_1110_0001_0101) begin // 65045: 15 cycles
	      if(LFSR == 16'b1001_0010_0100_1001) begin // 37449: 50k cycles
	         uno_ms_timeout <= 1'b1;
	         LFSR <= 16'b0000_0000_0000_0000;
	      end
	      else begin
	         uno_ms_timeout <= 1'b0;
	      end
	
	   end // end else
	end // end always
endmodule
