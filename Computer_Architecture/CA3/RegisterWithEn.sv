module register_with_en(clk,rst,pin,en, pout);
    input clk,rst,en;
    input [31:0] pin;
    output [31:0] pout;
    reg [31:0] pout = 32'd0;
    always @(posedge clk) begin
        if(rst)
            pout <= 32'd0;
        else
            if(en)
                pout <= pin;
    end
endmodule