// TEAM: Shasta GuideBot Model S
// Module: digit_timer_top 
// Description: 
// This module instantiates two digit timer modules allowing the ability to time from 0 - 90 seconds.
`timescale 10ns/100ps

module digit_timer_top(rst, clk, enable, userDigitTEN, userDigitONE, timerReconfigTEN_ONE, 
    	timerCountTEN, timerCountONE,
    	// uno_second_timeout, // SIMULATION
    	timeOutCTRL);
    
    input rst, clk, enable, timerReconfigTEN_ONE;
    
    input [3:0] userDigitTEN, userDigitONE;
    output timeOutCTRL; // noBorrowDownONE or !enable signals
    output [3:0] timerCountTEN, timerCountONE;
    wire [3:0] timerCountTEN, timerCountONE;
    
    	// output uno_second_timeout; // borrowDownONE // SIMULATION
    wire uno_second_timeout; // needed for 1[s]_timer and digit_timer_module
    // wire noBorrowDownTEN, borrowUpTEN, borrowDownTEN; // noBorrowUpTEN = 1'b1; borrowUpTEN will just float
    wire noBorrow_DownTEN_UpONE, borrowUpTEN, noBorrowUpTEN, borrow_DownTEN_UpONE; // noBorrowUpTEN = 1'b1; borrowUpTEN will just float
    
    // wire timerReconfigTEN_pressed, timerReconfigONE_pressed;
    wire timeOut;

    assign noBorrowUpTEN = 1'b1;
    assign timeOutCTRL = ~enable || timeOut;
    
    // bs_mod (clk, reset, b_in, b_out);
    // bs_mod reconfigTENpress(clk, rst, timerReconfigTEN_ONE, timerReconfigTEN_pressed); // dont need to shape
    // bs_mod reconfigONEpress(clk, rst, timerReconfigTEN_ONE, timerReconfigONE_pressed); // dont need to shape
    
    // uno_s(rst, clk, enable, uno_second);
    //uno_s startOneSecondTimer(rst, clk, enablePressed, uno_second_timeout);
    uno_s startOneSecondTimer(rst, clk, enable, uno_second_timeout);
    
    // digit_timer_mod(rst, clk, userDigit, timerCount, timerReconfig, noBorrowDown, borrowUp, noBorrowUp, borrowDown);
    
    // digit_timer_mod digitTEN(rst, clk, userDigitTEN, timerCountTEN, timerReconfigTEN, noBorrowDownTEN, borrowUpTEN, noBorrowUpTEN, borrowDownTEN);
    // digit_timer_mod digitTEN(rst, clk, userDigitTEN, timerCountTEN, timerReconfigTEN_pressed, noBorrow_DownTEN_UpONE, borrowUpTEN, noBorrowUpTEN, borrow_DownTEN_UpONE);
    digit_timer_mod digitTEN(rst, clk, userDigitTEN, timerCountTEN, timerReconfigTEN_ONE, noBorrow_DownTEN_UpONE, borrowUpTEN, noBorrowUpTEN, borrow_DownTEN_UpONE);
    
    // digit_timer_mod digitONE(rst, clk, userDigitONE, timerCountONE, timerReconfigONE, noBorrowDownONE, borrowUpONE, noBorrowUpONE, borrowDownONE);
    // digit_timer_mod digitONE(rst, clk, userDigitONE, timerCountONE, timerReconfigONE_pressed, timeOut, borrow_DownTEN_UpONE, noBorrow_DownTEN_UpONE, uno_second_timeout);
    digit_timer_mod digitONE(rst, clk, userDigitONE, timerCountONE, timerReconfigTEN_ONE, timeOut, borrow_DownTEN_UpONE, noBorrow_DownTEN_UpONE, uno_second_timeout);    

    // seven_seg_decoder(seg_in, seg_out);
    // seven_seg_decoder digitTENdisplay(timerCountTEN, timerDisplayTEN);
    // seven_seg_decoder digitONEdisplay(timerCountONE, timerDisplayONE);

endmodule