`timescale 1ns/1ns
module datapath_tb();
    reg init=1,clk=0,select=0,add_sub=0,cnt_en=0,ldt=0,ldr=0;
    reg [7:0] y=8'b11111111;
    reg [15:0] x=16'b00000000100000000;
    wire Co,Compare;
    wire [15:0] Result;
    cosx dp(Co,init,clk,cnt_en,Compare,y,ldt,select,x,Result,ldr,add_sub);
    always begin #41;clk=~clk;select=~select;end
    always begin #82;add_sub=~add_sub;end
    initial begin
        #82;
	    #82;
        $stop;
    end
endmodule