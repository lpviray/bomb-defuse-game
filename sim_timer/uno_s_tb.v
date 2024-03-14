// TEAM: Shasta GuideBot Model S
// Module: uno_s_tb 
// Description: 
// This module tests the uno_s module to make sure that it computes 1[s] accurately.
`timescale 10ns/100ps

module uno_s_tb();
    
    // uno_s(rst, clk, enable, uno_second, count_ten_cien_ms); // count_ten_cien_ms is used for simulating purposes
    reg rst_s, clk_s, enable_s;
    wire uno_second_s;
    wire [3:0] count_ten_cien_ms_s; // remove count_ten_cien_ms_s after simulations are done

    uno_s startCountingSeconds(rst_s, clk_s, enable_s, uno_second_s, count_ten_cien_ms_s);
    
    always begin
        clk_s = 1'b1; #10;
        clk_s = 1'b0; #10;
    end
    
    initial begin
        rst_s = 1'b1; // reset floats
        enable_s = 1'b0; // disabled
        @(posedge clk_s);
        #5; rst_s = 1'b0; #20; //rst button is pressed
        rst_s = 1'b1; #30; // rst button is released
        #200;
	
        @(posedge clk_s);
        #5; enable_s = 1'b1; // 100ms counting is enabled
        #2300;
        @(posedge clk_s);
        #5; enable_s = 1'b0; // counting diabled
    end // end initial
endmodule
