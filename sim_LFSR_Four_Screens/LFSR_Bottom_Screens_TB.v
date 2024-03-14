`timescale 10ns/100ps
module LFSR_Bottom_Screens_TB();
reg Clk, Rst, Button;
wire [1:0] First_Screen,Second_Screen,Third_Screen,Fourth_Screen;

LFSR_Bottom_Screens DUT_LFSR_Bottom_Screens(Clk,Rst,Button,First_Screen,Second_Screen,Third_Screen,Fourth_Screen);

always begin
Clk = 0;
#10;
Clk = 1;
#10;
end

initial begin
Rst = 1;
Button = 0;
@(posedge Clk);
#5 Rst = 0;
#20;
@(posedge Clk);
#5 Rst = 1;
#100;
@(posedge Clk);
#5 Button = 1;
@(posedge Clk);
#100;
@(posedge Clk);
#5 Button = 0;
@(posedge Clk);
#500;
@(posedge Clk);
#5 Button = 1;
@(posedge Clk);
#100;
@(posedge Clk);
#5 Button = 0;
@(posedge Clk);
#500;
@(posedge Clk);
#5 Button = 1;
@(posedge Clk);
#100;
@(posedge Clk);
#5 Button = 0;

end
endmodule

