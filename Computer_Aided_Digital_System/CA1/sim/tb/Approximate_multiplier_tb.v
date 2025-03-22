module Approximate_multiplier_tb();
    reg clk=0,rst=1,Start=0;
    wire Done;
    approximate_multiplier #(.n_input(16), .n_effective(8),.n_multiplications(8)) am(.Start(Start),.clk(clk),.rst(rst), .Done(Done));
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; Start=1;
        #38; Start=0;
        #38000;
        $stop;
    end
endmodule