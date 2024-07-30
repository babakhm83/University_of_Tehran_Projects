`timescale 1ns/1ns
module serial_transmitter_tb();
    reg serin=0, clk=0, rst=1;
    wire serout;
    serial_transmitter st(serout,serin,clk,rst);
    initial forever begin #41;clk=~clk; end
    initial begin
        #82; rst=0;
	    #82;
        #20;
        #82; serin=0;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=0;       
        #82; serin=1;
        #82; serin=1;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=1;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=0;
        #82; serin=1;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #100
        $stop;
    end
endmodule
