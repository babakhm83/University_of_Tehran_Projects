`timescale 1ns/1ns
module cosx_tb();
    reg Start=0,clk=0,rst=0;
    wire init,select,add_sub,Co,Compare,ldt,ldr,cnt_en,ready,ready1;
    reg [7:0] y=8'b0;
    reg [15:0] x=16'b0000000010011110;//0.6171875 -> cos -> 0.81550939694 -> 00000000.11010000
    wire [15:0] Result;
    wire [15:0] Result1;
    controller ctrl(Start,Co,Compare,clk,rst,init,select,add_sub,ldt,ldr,cnt_en,ready);
    cosx dp(Co,init,clk,cnt_en,Compare,y,ldt,select,x,Result,ldr,add_sub);
    cosx_with_controller t(ready1,Start,clk,x,y,rst,Result1);
    always begin #41;clk=~clk;end
    initial begin
        #82;
        #82;
        #82;
        #20; Start = 1;
	    #82; Start=0;
	    #1640;
        #82;
        #82;
        #82;
        #82; y=8'b00011110;
        #82; Start = 1;
	    #82; Start=0;
	    #1640;
        #82;
        #82;
        #82;#82; y=8'b0; x=16'b0000000111100010;//1.8828125 -> cos -> -0.30697808454 -> 11111111.10110010
        #82; Start = 1;
	    #82; Start=0;
	    #1640;
        #82;
        #82;
        #82;
        #82;
        $stop;
    end
endmodule