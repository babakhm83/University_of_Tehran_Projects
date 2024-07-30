module data_memory_tb();
    reg clk=0,rst=1,WE=0;
    reg signed [31:0] A=32'b0,WD=32'b0;
    wire signed [31:0] RD;
    data_memory dm(clk,rst,A,WD,WE, RD);
    always begin #19;clk=~clk; end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; A=8;
        #38; A=4; WE=1; WD=10;
        #38; WD=20; A=8;
        #38; WE=0; WD=30;
        #38; WD=40;
        #38; A=0;
        #38; A=4;
        #38; A=8;
        $stop;
    end
endmodule