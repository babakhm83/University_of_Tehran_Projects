`timescale 1ns/1ns
module controller_tb();
    reg Start=0,clk=0,Co=0,Comp=1,rst=0;
    wire init,s,add_sub,ldt,ldr,cnt_en,ready;
    controller ctrl(Start,Co,Comp,clk,rst,init,s,add_sub,ldt,ldr,cnt_en,ready);
    always begin #41;clk=~clk;end
    initial begin
        #82;
        #82;
        #82;
        #20; Start = 1;
	    #82; Start=0;
	    #82;
	    #82;
	    #82;
	    #82;
	    #82;
	    #82;
	    #82;
	    #82; Co = 1;
        #82;
        #82;
        #20; Start = 1;
	    #82; Start=0;
	    #82;
	    #82;
	    #82;Comp=0;
        #820;
        $stop;
    end
endmodule