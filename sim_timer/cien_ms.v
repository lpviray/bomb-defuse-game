// TEAM: Shasta GuideBot Model S
// Author: Rafael Medina	Peoplesoft ID: 117(5114) 
// Module: cien_ms 
// Description: 
// This module computes 100 [ms].
`timescale 10ns/100ps

// module cien_ms(rst, clk, cien_m_second, count_cien); // count_cien is used for simulating purposes
module cien_ms(rst, clk, cien_m_second);
    input rst, clk;
    output cien_m_second;
    reg cien_m_second;
    	// output [6:0] count_cien; // REMOVE AFTER SIMULATION
    reg [6:0] count_cien; // used to count one hundred 1[ms] increments
    wire uno_ms_signal;
    
    //// uno_ms(rst, clk, enable, uno_m_second);
    // uno_ms countOneMiliSecond(rst, clk, enable, uno_ms_signal);
    
    // lfsr_uno_ms(rst, clk, uno_ms_timeout);
    lfsr_uno_ms lfsr_uno_ms_instantiation(rst, clk, uno_ms_signal);
    
    always@(posedge clk) begin
        if(rst == 1'b0) begin
            count_cien <= 4'b0000;
            cien_m_second <= 1'b0;
        end
        // else if(enable == 1'b1) begin
        else if(uno_ms_signal == 1'b1) begin // receive signal from the 1ms module
            if(count_cien == 7'b1100011) begin // 99 = 64+32+2+1 // check 100[ms]
            // if(count_cien == 7'b0000010) begin // testing	// TO TEST ADJUST THIS LINE
                count_cien <= 7'b0000000;
                cien_m_second <= 1'b1;
            end // end 100[ms] count
            else begin // we just keep counting
                count_cien <= count_cien + 1;
            end // end else
        end // end if uno_ms_signal == 1
        else begin // if we don't receive a signal from the 1ms module
            cien_m_second <= 1'b0; // clear output signal
        end
        // end // end else if enable
    end // end always

endmodule

