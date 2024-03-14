// TEAM: Shasta GuideBot Model S
// Module: uno_ms 
// Description: 
// This module computes one [ms]. 
`timescale 10ns/100ps

module uno_ms(rst, clk, enable, uno_m_second);
    input rst, clk, enable;
    output uno_m_second;
    reg uno_m_second;
    reg [15:0] count_wave; // counts up to 50,0000 = 1100 0011 0101 0000
      
    always@(posedge clk) begin
        if (rst == 1'b0) begin
            uno_m_second <= 1'b0; // intializing ms count to 0
            count_wave <= 16'b0000_0000_0000_0000;
        end
        else begin
            count_wave <= count_wave + 1;
            if(enable == 1'b1 && count_wave == 16'b1100_0011_0101_0000) begin
            // if(enable == 1'b1 && count_wave == 16'b0000_0000_0000_0001) begin //			TO TEST UNCOMMENT THIS LINE
                count_wave <= 16'b0000_0000_0000_0000;
                // 1,000,000[ns] = 1[ms]
                uno_m_second <= 1'b1;
            end 
            else begin
                uno_m_second <= 1'b0;
            end
        end // end else
    end // end always
endmodule
