`timescale 1ns/1ns
module transmitter_tb();
    reg serin=1, clk=0, rst=1,transmit=0,ld=1;
    wire detectvalid,serout;
    reg [7:0] nt=8'b00000110;
    \transmitter-controller q_transmit(serout,serin,transmit,detectvalid,ld,clk,rst,nt);
    initial forever begin #50;clk=~clk; end
    initial begin
        #150; transmit=1; ld=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=1;
        #82; serin=0;
        #82; serin=1;
        #34; transmit=0;
        #100
        $stop;
    end
endmodule
