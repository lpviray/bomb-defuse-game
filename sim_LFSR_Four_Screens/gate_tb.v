`timescale 10ns/100ps
module gate_tb();
	
	reg spotfilled;
	reg opengate;
	reg neargate;
	wire gatestatus;

	gate DUT_gate(spotfilled,opengate,neargate,gatestatus);

	initial begin
	#10 
	spotfilled = 0;
	opengate = 0;
	neargate = 0;
	#100
	spotfilled = 1;
	opengate = 0;
	neargate = 0;
	#100;
	spotfilled = 1;
	opengate = 1;
	neargate = 0;
	#100
	spotfilled = 1;
	opengate = 1;
	neargate = 1;
	#100
	spotfilled = 0;
	opengate = 1;
	neargate = 0;
	#100
	spotfilled = 0;
	opengate = 0;
	neargate = 0;
	#100
	spotfilled = 0;
	opengate = 0;
	neargate = 1;

	end

endmodule
