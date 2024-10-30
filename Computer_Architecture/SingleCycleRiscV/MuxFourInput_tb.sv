module mux_four_input_tb();
    reg [31:0] A=10,B=20,C=30,D=40;
    reg [1:0] sel=2'b00;
    wire [31:0] out;
    mux_four_input mux(A,B,C,D,sel, out);
    initial begin
        #10; sel = 0;
        #10; sel = 1;
        #10; sel = 2;
        #10; sel = 3;
        #10; D = -40;
        #10; $stop;
    end
endmodule