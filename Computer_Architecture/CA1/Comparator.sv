module comparator(A,B,gt);
    input [9:0] A,B;
    output gt;
    reg gt;
    always @(A,B) begin
        gt=(A>=B)?1'b1:1'b0;
    end
endmodule