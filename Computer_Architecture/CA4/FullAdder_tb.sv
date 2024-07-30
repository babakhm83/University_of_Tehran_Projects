module full_adder_tb();
    reg signed [31:0] A=31,B=5;
    wire [31:0] out;
    full_adder fa(A,B,out);
    initial begin
        #38;
        #10;
        #38; A=4; B=6;
        #38; A=429; B=27;
        #38; A=1; B=2;
        #38; A=3; B=3;
        #38; A=-37; B=-225;
        #38; $stop;
    end
endmodule