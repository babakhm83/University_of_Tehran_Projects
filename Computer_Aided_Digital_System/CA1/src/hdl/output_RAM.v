module output_ram #(parameter r=8, parameter n = 32) (i,pi,wr,clk,rst);
    input clk,rst,wr;
    input [$clog2(r)-1:0] i;
    input [n-1:0] pi;
    reg [n-1:0] x [0:r-1];
    integer j;
    initial begin
        for (j=0; j<r; j=j+1) begin
            x[j]={n{'b0}};
        end
    end
    always @(posedge clk) begin
        if(rst) begin
            x[i]<={n{'b0}};
        end
        else begin
            if(wr) begin
                x[i]<=pi;
                $writememh("data_output.txt",x);
            end
        end
    end
endmodule