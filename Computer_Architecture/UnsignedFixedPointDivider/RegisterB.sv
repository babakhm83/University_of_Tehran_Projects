module registerB(pin,sload,clk,rst, pout);
    input sload,clk,rst;
    input [9:0] pin;
    output [9:0] pout;
    reg [9:0] po=10'd0;
    always @(posedge clk) begin
        if(rst)
            po <= 10'd0;
        else begin
            if(sload)
                po <= pin;
        end
    end
    assign pout = po;
endmodule