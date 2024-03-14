// TEAM: Shasta GuideBot Model S
// Module: digit_timer_top_tb 
// Description: 
// This module tests the digit timer top module.
`timescale 10ns/100ps

module digit_timer_top_tb();
        // digit_timer_top(rst, clk, enable, userDigitTEN, userDigitONE, timerReconfigTEN_ONE, 
    	//    // timerDisplayTEN, timerDisplayONE,
    	//    timerCountTEN, timerCountONE, // SIMULATION
        // uno_second_timeout, // SIMULATION
        // timeOutCTRL);

    reg rst_s, clk_s, enable_s;
    reg [3:0] userDigitTEN_s, userDigitONE_s;
    reg timerReconfigTEN_ONE_s;
    // wire [6:0] timerDisplayTEN_s, timerDisplayONE_s;
    wire [3:0] timerCountTEN_s, timerCountONE_s;
    wire uno_second_s;
    wire timeOutCTRL_s;   
    
    // digit_timer_top(rst, clk, enable, userDigitTEN, userDigitONE, timerReconfigTEN_ONE, timerDisplayTEN, timerDisplayONE, timeOut);
    digit_timer_top timer_top_DUT(rst_s, clk_s, enable_s, userDigitTEN_s, userDigitONE_s, timerReconfigTEN_ONE_s, timerCountTEN_s, timerCountONE_s, uno_second_s, timeOutCTRL_s);
    
    always begin
        clk_s = 1'b1; #10;
        clk_s = 1'b0; #10;
    end
    
    initial begin
        rst_s = 1'b1; // reset floats
	enable_s = 1'b0; // one second timer disabled from the beginning
        userDigitTEN_s = 4'b0010;
        userDigitONE_s = 4'b0010;
	timerReconfigTEN_ONE_s = 1'b1;
        
       // first reset
       // enable
       // timerReconfig

////////INITIATE TIMER
        @(posedge clk_s);
        #5; rst_s = 1'b0; #20; //rst button is pressed
        rst_s = 1'b1; // rst button is released
        
        @(posedge clk_s);
        #5; enable_s = 1'b1; #60; // enabling

        @(posedge clk_s);
        #5; timerReconfigTEN_ONE_s = 1'b0; #40; // begin timer config TEN_ONE
        @(posedge clk_s);
        #5; timerReconfigTEN_ONE_s = 1'b1; #40;

        @(posedge clk_s);
        #5; timerReconfigTEN_ONE_s = 1'b0; #40; // begin timer config TEN_ONE
        @(posedge clk_s);
        #5; timerReconfigTEN_ONE_s = 1'b1; #40; 
	#15000;
	
////////RE-INITIATE TIMER
        @(posedge clk_s);
        #5; rst_s = 1'b0; #20; //rst button is pressed
        rst_s = 1'b1; // rst button is released

        @(posedge clk_s);
        #5; timerReconfigTEN_ONE_s = 1'b0; #40; // begin timer config TEN_ONE
        @(posedge clk_s);
        #5; timerReconfigTEN_ONE_s = 1'b1; #40;

        @(posedge clk_s);
        #5; timerReconfigTEN_ONE_s = 1'b0; #40; // begin timer config TEN_ONE
        @(posedge clk_s);
        #5; timerReconfigTEN_ONE_s = 1'b1; #40;
	#9990;
	
	@(posedge clk_s);
	#5; enable_s = 1'b0;
	
    end // end initial
endmodule
