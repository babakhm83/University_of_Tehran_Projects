module S1 (input D00,D01,D10,D11,A0,A1,B1,clr,clk, output reg out);
initial begin 
    $system("s2-s1.exe ");
end
    wire mux_out;
    wire [1:0] sel;

    assign sel[0] = A0 & clr;
    assign sel[1] = A1 | B1;

    assign mux_out = (sel == 2'b00) ? D00 :
                     (sel == 2'b01) ? D01 :
                     (sel == 2'b10) ? D10 :
                     (sel == 2'b11) ? D11 : 1'b0;

    always @(posedge clk or posedge clr) begin
        if (clr)
            out <= 0;
        else
            out <= mux_out;
    end
endmodule