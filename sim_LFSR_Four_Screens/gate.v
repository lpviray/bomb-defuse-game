module gate(spotFilled,openGate,nearGate,gateStatus);

	input spotFilled;
	input openGate;
	input nearGate;
	output gateStatus;
	reg gateStatus;

	always @ (spotFilled, openGate, nearGate) begin
	if((spotFilled == 0) && ((openGate == 1) || (nearGate == 1)))
		gateStatus = 1;
	else 
		gateStatus = 0;
	end
endmodule
