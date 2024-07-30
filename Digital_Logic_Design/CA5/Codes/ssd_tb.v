`timescale 1ns/1ns
module ssd_tb();
    reg serin=0,detect=1,clk=0,rst=0;
    wire m_collectvalid,q_collectvalid;
    my_mealy_ssd my_ssd(serin,detect,clk,rst,m_collectvalid);
    q_mealy_ssd q_ssd(serin,detect,clk,rst,q_collectvalid);
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
        #82; serin=0;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=0;
        #82; serin=0;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=0;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=1; rst=1;
        #82; serin=1;
        #82; serin=1;
        #82; serin=0;
        #200
        $stop;
    end
endmodule