// TEAM: Shasta GuideBot Model S
// Module: digit_timer_tb 
// Description: This module tests the digit timer module.
`timescale 10ns/100ps

module digit_timer_tb();
    
    // digit_timer_mod(rst, clk, userDigit, timerCount, timerReconfig, noBorrowDown, borrowUp, noBorrowUp, borrowDown);
    	// digit_timer_mod(rst, clk, userDigit, timerCount, timerReconfig, noBorrowDown, borrowUp, noBorrowUp, borrowDown);
    reg rst_s, clk_s; // input
    reg [3:0] userDigitTEN_s, userDigitONE_s; // input
    reg timerReconfigTEN_s, timerReconfigONE_s; // input
    reg noBorrowUpTEN_s, borrowDownTEN_s; // input
    reg noBorrowUpONE_s, borrowDownONE_s; 
    
    wire [3:0] timerCountTEN_s; // output
    wire [3:0] timerCountONE_s; 

    wire borrowUpTEN_s, noBorrowDownTEN_s; //output
    wire borrowUpONE_s, noBorrowDownONE_s; //output    

	// added wires for config flags
	wire [1:0] configFlagTEN_s, configFlagONE_s;
    
    		// digit_timer_mod(rst, clk, userDigit, timerCount, timerReconfig, noBorrowDown, borrowUp, noBorrowUp, borrowDown);
    // digit_timer_mod timerTEN_DUT(rst_s, clk_s, userDigitTEN_s, timerCountTEN_s, timerReconfigTEN_s, noBorrowDownTEN_s, borrowUpTEN_s, noBorrowUpTEN_s, borrowDownTEN_s);
    // digit_timer_mod timerONE_DUT(rst_s, clk_s, userDigitONE_s, timerCountONE_s, timerReconfigONE_s, noBorrowDownONE_s, borrowUpONE_s, noBorrowUpONE_s, borrowDownONE_s);
    digit_timer_mod timerTEN_DUT(rst_s, clk_s, userDigitTEN_s, timerCountTEN_s, timerReconfigTEN_s, noBorrowDownTEN_s, borrowUpTEN_s, noBorrowUpTEN_s, borrowDownTEN_s, configFlagTEN_s);
    digit_timer_mod timerONE_DUT(rst_s, clk_s, userDigitONE_s, timerCountONE_s, timerReconfigONE_s, noBorrowDownONE_s, borrowUpONE_s, noBorrowUpONE_s, borrowDownONE_s, configFlagONE_s);

    always begin
        clk_s = 1'b1;
        #10;
        clk_s = 1'b0;
        #10;
    end
    /*
    always@(posedge clk_s) begin
	borrowDownONE_s = 1'b1;
	#20
	borrowDownONE_s = 1'b0;
	#60;
    end
	*/
    always begin
	borrowDownONE_s = 1'b1;
	#20;
	borrowDownONE_s = 1'b0;
	#20;
    end

    initial begin
        rst_s = 1'b1; // reset floats
        userDigitTEN_s = 4'b0001;
        userDigitONE_s = 4'b0010;
        timerReconfigTEN_s = 1'b0;
        timerReconfigONE_s = 1'b0;
        
        noBorrowUpTEN_s = 1'b1;
        // borrowDownTEN_s = 1'b0;
        // noBorrowUpONE_s = 1'b0;
        // borrowDownONE_s = 1'b0;

        @(posedge clk_s)
        #5; rst_s = 1'b0; //rst button is pressed
        #20;
        rst_s = 1'b1; // rst button is released
        #30;
        
        // TIMER RECONFIG
	// timer config pressed once
        @(posedge clk_s)
        #5; timerReconfigTEN_s = 1'b1; // begin timer config TEN
        timerReconfigONE_s = 1'b1; // begin timer config ONE
        // #10;
        @(posedge clk_s)
        #5; timerReconfigTEN_s = 1'b0; // timer config
        timerReconfigONE_s = 1'b0; // timer config
	#40;

        @(posedge clk_s)
        #5; timerReconfigTEN_s = 1'b1; // begin timer config TEN
        timerReconfigONE_s = 1'b1; // begin timer config ONE
        // #10;
        @(posedge clk_s)
        #5; timerReconfigTEN_s = 1'b0; // timer config
        timerReconfigONE_s = 1'b0; // timer config
    end // end initial
endmodule
