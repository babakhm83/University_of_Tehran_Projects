module shift_registerA(pin,sload,sclr,serin,sshl,clk,rst, pout);
    input sload,sclr,serin,sshl,clk,rst;
    input [9:0] pin;
    output [9:0] pout;
    reg [9:0] po=10'd0;
    always @(posedge clk) begin
        if(rst)
            po <= 10'd0;
        else begin
            if(sclr)
                po<=10'd0;
            else if(sload)
                po<=pin;
            else if(sshl)
                po <= {po[8:0],serin};
        end
    end
    assign pout=po;
endmodule