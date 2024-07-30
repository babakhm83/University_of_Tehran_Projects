module data_memory(clk,rst,A,WD,WE,pre_ld,pre_data,pre_A, RD);
    parameter N = 1024;
    input clk,rst,WE,pre_ld;
    input signed [31:0] A,WD,pre_data,pre_A;
    output signed [31:0] RD;
    reg signed [7:0] x [0:N-1] = '{default:0};
    assign RD = {x[A+3],x[A+2],x[A+1],x[A]};
    always @(posedge clk) begin
        if(~rst & WE) begin
            x[A] <= WD[7:0];
            x[A+1] <= WD[15:8];
            x[A+2] <= WD[23:16];
            x[A+3] <= WD[31:24];
        end
    end
    always @(pre_ld,pre_data,pre_A) begin
        if(pre_ld)begin
            x[pre_A] <= pre_data[7:0];
            x[pre_A+1] <= pre_data[15:8];
            x[pre_A+2] <= pre_data[23:16];
            x[pre_A+3] <= pre_data[31:24];
        end
    end
endmodule