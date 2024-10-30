module register_file_tb();
    reg clk=0,rst=1,WE3=0;
    reg signed [31:0] A1=32'b0,A2=32'b0,A3=32'b0,WD3=32'b0;
    wire signed [31:0] RD1,RD2;
    register_file rf(clk,rst,A1,A2,A3,WD3,WE3, RD1,RD2);
    always begin #19;clk=~clk; end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; A1=1;
        #38; A2=1; WE3=1; WD3=10;
        #38; WD3=20; A3=1;
        #38; WE3=0; WD3=30;
        #38; WD3=40;
        #38; A1=0; A2=2;
        #38; A1=1; A3=0;
        #38;
        $stop;
    end
endmodule