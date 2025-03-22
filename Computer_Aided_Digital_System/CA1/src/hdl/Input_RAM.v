module input_ram #(parameter r=16, parameter n = 16) (i,clk,rst, po1,po2);
    input clk,rst;
    input [$clog2(r)-2:0] i;
    output reg [n-1:0] po1={n{'b0}},po2={n{'b0}};
    reg [n-1:0] x [0:r-1];
    initial
    $readmemb("input.txt",x);
    always @(posedge clk) begin
        if(rst) begin
            $readmemb("data_input.txt",x);
        end
        else begin
            po1<=x[2*i];
            po2<=x[2*i+1];
        end
    end
endmodule