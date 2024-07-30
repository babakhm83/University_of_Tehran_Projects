module mux_two_input_tb();
    reg [31:0] A=31,B=0;
    reg sel=0;
    wire [31:0] out;
    mux_two_input mux(A,B,sel, out);
    initial begin
        #10; A=4; B=6;
        #10; A=429; B=27;
        #10; A=-186; B=2;
        #10; A=3; B=3;
        #10; A=0; B=-25; sel=1;
        #10; A=-37; B=-225;
        #10; $stop;
    end
endmodule