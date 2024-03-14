// TEAM: Shasta GuideBot Model S
// Module: cien_ms_tb 
// Description: 
// This module tests the cien_ms module to make sure that it computes 100 [ms].
`timescale 10ns/100ps

module cien_ms_tb();
    
    // cien_ms(rst, clk, cien_m_second, count_cien_s); // count_cien_s is used only for simulation purposes
    reg rst_s, clk_s;
    wire cien_m_second_s;
    wire [6:0] count_cien_s; // remove count_cien after simulations are done
    
    // cien_ms startCountingCienMs(rst_s, clk_s, cien_m_second_s, count_cien_s); simulation
    cien_ms startCountingCienMs(rst_s, clk_s, cien_m_second_s, count_cien_s);
    
    always begin
        clk_s = 1'b1; #10;
        clk_s = 1'b0; #10;
    end
    
    initial begin
        rst_s = 1'b1; // reset floats
        @(posedge clk_s);
        #5; rst_s = 1'b0; #20; //rst button is pressed
        rst_s = 1'b1; // rst button is released
        
    end // end initial
endmodule
