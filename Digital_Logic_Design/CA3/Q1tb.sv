`timescale 1ns/1ns
module ALU_TB ();
    reg signed [15:0] a=15'd0;
    reg signed [15:0] b=15'd0;
    reg c=1'd0;
    reg [2:0] opc3=3'd0;
    wire signed [15:0] w0;
    wire zer_f0;
    wire neg_f0;
    my_behavioral_ALU mine(a,b,c,opc3,w0,zer_f0,neg_f0);
    wire signed [15:0] w1;
    wire zer_f1;
    wire neg_f1;
    yosys_behavioral_ALU yosys(a,b,c,opc3,w1,zer_f1,neg_f1);
    initial begin
        repeat(100000) begin
            #200;
            a=$random;
            b=$random;
            c=$random;
            opc3=$random;
        end
        #200;
    end
endmodule