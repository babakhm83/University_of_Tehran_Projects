module multiplier_tb();
    reg [3:0] pin1=4'b0,pin2=4'b0;
    wire [3:0] out;
    multiplier  #(.n(4)) m (.pin1(pin1),.pin2(pin2), .pout(out));
    initial begin
        #38;
        #38; pin1=4'b0010;pin2=4'b0110;
        #38;
        $stop;
    end
endmodule