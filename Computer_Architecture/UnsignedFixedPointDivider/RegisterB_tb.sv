module registerB_tb();
    reg clk=0,rst=1,sload=0;
    reg [4:0] pin=10'd3;
    wire [4:0] pout;
    registerB regB(pin,sload,clk,rst, pout);
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; sload=1;
        #38; sload=0;
        #38; pin=10'b1100110000; sload=1;
        #38; sload=0;
        #38;
        $stop;
    end
endmodule