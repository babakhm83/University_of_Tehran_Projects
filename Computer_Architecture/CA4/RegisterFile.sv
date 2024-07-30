module register_file(clk,rst,A1,A2,A3,WD3,WE3, RD1,RD2);
    input clk,rst,WE3;
    input [4:0] A1,A2,A3;
    input signed [31:0] WD3;
    output signed [31:0] RD1,RD2;
    reg signed [31:0] x [0:31] = '{default:0};
    always @(negedge clk) begin
        if(~rst) begin
            if(WE3 && A3 != 5'd0)
                x[A3] <= WD3;
        end
    end
    assign RD1 = rst ? 32'd0 : x[A1];
    assign RD2 = rst ? 32'd0 : x[A2];
endmodule