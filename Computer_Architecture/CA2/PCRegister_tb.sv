module pc_register_tb();
    reg clk=0,rst=1;
    reg [31:0] pin=31'd0;
    wire [31:0] pout;
    PC_register pc(clk,rst,pin, pout);
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; pin=10;
        #38; pin=20;
        #38; pin=554;
        #38; pin=53;
        #38;
        $stop;
    end
endmodule