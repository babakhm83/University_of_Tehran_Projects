module instruction_memory(A,pre_ld,pre_data,pre_A, RD);
    parameter N = 1024;
    input [31:0] A,pre_A;
    input pre_ld;
    input [31:0] pre_data;
    output [31:0] RD;
    reg [7:0] x [0:N-1] = '{default:0};
    always @(pre_ld,A,pre_data) begin
        if(pre_ld) begin
            x[pre_A] = pre_data[7:0];
            x[pre_A+1] = pre_data[15:8];
            x[pre_A+2] = pre_data[23:16];
            x[pre_A+3] = pre_data[31:24];
        end
    end
    assign RD = {x[A+3],x[A+2],x[A+1],x[A]};
endmodule