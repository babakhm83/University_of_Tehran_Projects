module Approximate_multiplier_tb();
    reg clk=0,rst=1,Start=0;
    reg [15:0] pin1={16'b1101010101010001},pin2={16'b1111111111111111};
    wire [15:0] pout;
    wire Done;
    approximate_multiplier #(.n_input(16), .n_effective(8),.n_multiplications(8)) am(.Start(Start),.pin1(pin1),.pin2(pin2),.clk(clk),.rst(rst), 
    .Done(Done),.pout(pout));
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; Start=1;
        #38; Start=0;
        #1500;
        #38; Start=1; pin1={16'b0000000100000000};pin2={16'b0000000100000000};
        #38; Start=0;
        #1500;
        #38; Start=1; pin1={16'b0000000100000000};pin2={16'b0000001000000000};
        #38; Start=0;
        #1500;
        #38; Start=1; pin1={16'b0000001000000000};pin2={16'b0000001000000000};
        #38; Start=0;
        #1500;
        #38; Start=1; pin1={16'b0000010000000000};pin2={16'b0000001000000000};
        #38; Start=0;
        #1500;
        #38; Start=1; pin1={16'b0000010000000000};pin2={16'b0000010000000000};
        #38; Start=0;
        #1500;
        #38; Start=1; pin1={16'b0000100000000000};pin2={16'b0000010000000000};
        #38; Start=0;
        #1500;
        #38; Start=1; pin1={16'b0000100000000000};pin2={16'b0000100000000000};
        #38; Start=0;
        #1500;
        #38; Start=1; pin1={16'b0000100000000000};pin2={16'b0001000000000000};
        #38; Start=0;
        #1500;
        #38; Start=1; pin1={16'b0001000000000000};pin2={16'b0001000000000000};
        #38; Start=0;
        #1500;
        #38; Start=1; pin1={16'b1000000000000000};pin2={16'b1000000000000000};
        #38; Start=0;
        #1500;
        #38; Start=1; pin1={16'b1101010101010001};pin2={16'b1111111111111111};
        #38; Start=0;
        #1500;
        $stop;
    end
endmodule