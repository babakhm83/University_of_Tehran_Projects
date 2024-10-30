module register_with_en_tb();
    reg clk=0,rst=1,en=0;
    reg [31:0] pin=31'd0;
    wire [31:0] pout;
    register_with_en register(clk,rst,pin,en, pout);
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; pin=10;
        #38; pin=20;en=1;
        #38; pin=554;
        #38; pin=53;en=0;
        #38;
        $stop;
    end
endmodule