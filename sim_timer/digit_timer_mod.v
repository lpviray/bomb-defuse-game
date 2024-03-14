// Author: Rafael Medina	Peoplesoft ID: 117(5114) 
// Module: digit_timer_mod 
// Description: This module accepts a digit value input from user (0-9)and counts down to 0.

// module digit_timer_mod(rst, clk, userDigit, timerCount, timerReconfig, noBorrowDown, borrowUp, noBorrowUp, borrowDown);
module digit_timer_mod(rst, clk, userDigit, timerCount, timerReconfig, noBorrowDown, borrowUp, noBorrowUp, borrowDown, configFlag);

    input rst, clk, timerReconfig;
    input [3:0] userDigit;
    input noBorrowUp, borrowDown; // request "from" up/down
    output borrowUp, noBorrowDown;
    reg borrowUp, noBorrowDown;
    output [3:0] timerCount;
	output [1:0] configFlag; // ONLY FOR SIMULATION
    reg [3:0] timerCount;
    reg [1:0] configFlag;
    
    
    always@(posedge clk) begin // sequential!
        if(rst == 1'b0) begin
            borrowUp <= 1'b0;
            noBorrowDown <= 1'b0;
            timerCount <= 4'b0000;
            configFlag <= 2'b00; 
        end
        else begin
            if(timerReconfig == 1'b1 && userDigit > 4'b1001) begin // if timer reconfig button is pressed
                borrowUp <= 1'b0;
                noBorrowDown <= 1'b0;
                // configFlag <= 1'b1;
                configFlag <= 2'b01;
                timerCount <= 4'b1001;
            end
            if(timerReconfig == 1'b1 && userDigit <= 4'b1001) begin
                borrowUp <= 1'b0;
                noBorrowDown <= 1'b0;
                // configFlag <= 1'b1;
                configFlag <= 2'b01;
                timerCount <= userDigit;
                // timerCount <= 4'b1111;
            end
            if (timerReconfig == 1'b1 && configFlag == 2'b01) begin
                configFlag <= 2'b10;
            end
            if(configFlag == 2'b10) begin // configFlag == 2: timer digit loaded and config pressed
                borrowUp <= 1'b0; // intiate request to borrow from top digit to low
                if(borrowDown == 1'b1)begin // if we have been requested to borrow a digit
                    if(timerCount > 4'b0000) begin
                        if(timerCount == 4'b0001) begin
                            if(noBorrowUp == 1'b1) begin // if we can't borrow from the upper digit
                                noBorrowDown <=  1'b1; // signal to the lower digit that we can't let borrow anymore
                            end
                        end
                        timerCount <= timerCount - 1; // decrement the timerCount      
                    end // end if(timerCount > 4'b0000)
                    else begin // we are at timerCount == 0
                        borrowUp <= 1'b1;
                        if(noBorrowUp == 1'b0) begin // we can borrow
                            timerCount <= 4'b1001; // reset the count to 9
                        end
                    end // end timerCount == 0
                end // end request to borrow from upper digit
                // else if we weren't requested to borrow we don't do anything
            end // end if configFlag == 1
        end // end else
    end // end always
endmodule
