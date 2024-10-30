module counter14(clk,rst,sclr,cnt_en,co,pout);
    input clk,rst,sclr,cnt_en;
    output co;
    output [3:0] pout;
    reg [3:0] po=4'b0000;
    always @(posedge clk) begin
        if(rst)
            po <= 4'd4;
        else begin
            if(sclr)
                po <= 4'd4;
            else if(cnt_en)
                po <= po+1;
        end
    end
    assign co = cnt_en ? (~|po) : 1'b0;
    assign pout =po;
endmodule