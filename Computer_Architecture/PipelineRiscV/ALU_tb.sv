module ALU_tb();
    reg signed [31:0] A=31,B=5;
    reg [2:0] control=0;
    wire [31:0] out;
    wire Zero,LessThan;
    ALU alu(A,B,control,out, Zero,LessThan);
    initial begin
        #10;
        #38; A=4; B=6; control=1;
        #38; A=27; B=27; control=2;
        #38; A=1; B=2; control=3;
        #38; A=37; B=-225; control=4;
        #38; A=37; B=-225; control=5;
        #38; A=0; B=1; control=6;
        #38; $stop;
    end
endmodule