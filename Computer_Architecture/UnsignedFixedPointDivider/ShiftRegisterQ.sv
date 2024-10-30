module shift_registerQ(pin,sload,serin,sshl,clk,rst, lout,pout);
    input sload,serin,sshl,clk,rst;
    input [9:0] pin;
    output lout;
    output [9:0] pout;
    reg lout;
    reg [9:0] po=10'b0000000000;
    always @(posedge clk) begin
        if(rst)
            {po,lout} <= 11'd0;
        else begin
            if(sload) begin
                po<=pin;
                lout<=1'd0;
            end
            else if(sshl) begin
                lout <= po[9];
                po <= {po[8:0],serin};
            end
        end
    end
    assign pout=po;
endmodule