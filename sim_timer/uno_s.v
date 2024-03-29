// TEAM: Shasta GuideBot Model S
// Module: uno_s 
// Description: 
// This module computes 1 [s].

`timescale 10ns/100ps

// module uno_s(rst, clk, enable, uno_second, count_ten_cien_ms); // count_ten_cien_ms is used for simulating purposes
module uno_s(rst, clk, enable, uno_second);
    input rst, clk, enable;
    output uno_second;
    reg uno_second;
    	  // output [3:0] count_ten_cien_ms; // REMOVE AFTER SIMULATION
    reg [3:0] count_ten_cien_ms; // used to count ten 100[ms] increments
    // wire cien_m_second_signal, count_cien_ms_signal; // remove count_cien_ms_signal after simulation
    wire cien_m_second_signal;
    
    // cien_ms(rst, clk, cien_m_second, count_ten);
    // cien_ms countHundredMiliSec(rst, clk, cien_m_second_signal, count_cien_ms_signal); 
    cien_ms countHundredMiliSec(rst, clk, cien_m_second_signal);
    
    always@(posedge clk) begin
        if(rst == 1'b0) begin
            count_ten_cien_ms <= 4'b0000;
            uno_second <= 1'b0;
        end
        else if(enable == 1'b1) begin
            if(cien_m_second_signal == 1'b1) begin // received a signal from 100[ms] mod
                if(count_ten_cien_ms == 4'b1001) begin // we received 10 signals from 100[ms]
                // if(count_ten_cien_ms == 4'b0010) begin // we received 2 signals from 100[ms] TESTING
                    count_ten_cien_ms <= 4'b0000; // re-initiate the count
                    uno_second <= 1'b1; // one second pulse signal
                end // end if count == 10
                else begin // continue counting
                    count_ten_cien_ms <= count_ten_cien_ms + 1;
                end // end counting
            end // end if 100[ms] received
            else begin
                uno_second <= 1'b0;
            end // end else
        end // end else if
    end // end always
endmodule
