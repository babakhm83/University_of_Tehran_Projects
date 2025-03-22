module register_pin_tb();
    reg clk=0,rst=1,ld=0,shl=0;
    reg [3:0] pin=4'b0101;
    wire [3:0] po;
    register_pin  #(.n(4)) r (.pin(pin),.ld(ld),.shl(shl),.clk(clk),.rst(rst),.pout(po));
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; ld=1;
        #38; ld=0;
        #38; shl=1;
        #38; 
        #38; 
        #38; shl=0;
        #38;
        $stop;
    end
endmodule