module comparator_tb();
    reg [9:0] A=5'd0,B=5'd0;
    wire gt;
    comparator comp(A,B, gt);
    initial begin
        #10; A=4; B=6;
        #10; A=5'b11100; B=2;
        #10; A=3; B=3;
        #10; A=0; B=5'b101010;
        #10;
        $stop;
    end
endmodule