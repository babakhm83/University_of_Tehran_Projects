`timescale 1ns/1ns
module bcounter_tb();
    reg serin=0,collect=0,clk=0,rst=0;
    wire transmitvalid;
    wire [7:0] nt;
    bit_counter_controller q_counter(transmitvalid,rst,clk,collect,nt,serin);
    initial forever begin #41;clk=~clk; end
    initial begin
        #82;
        #82;
        #20; serin=0;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=0; collect=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1; collect=0;
        #82; serin=1;
        #82; serin=0;
        #82; serin=0;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=0; collect=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=0;
        #82; serin=0;
        #82; serin=0;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #200
        $stop;
    end
endmodule