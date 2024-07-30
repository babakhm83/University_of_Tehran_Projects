module registerMW(clk,rst,ALUResultM,ReadDataM,RdM,PCPlus4M,RegWriteM,ResultSrcM, 
ALUResultW,ReadDataW,RdW,PCPlus4W,RegWriteW,ResultSrcW);
    input clk,rst,RegWriteM;
    input [31:0] ReadDataM,ALUResultM,PCPlus4M;
    input [4:0] RdM;
    input [1:0] ResultSrcM;
    output [31:0] ReadDataW,ALUResultW,PCPlus4W;
    output [4:0] RdW;
    output [1:0] ResultSrcW;
    output RegWriteW;
    reg [31:0] ReadDataW=32'd0,ALUResultW = 32'd0, WriteDataW = 32'd0, PCPlus4W = 32'd0;
    reg [4:0] RdW = 5'd0;
    reg [1:0] ResultSrcW = 2'd0;
    reg RegWriteW = 1'd0;
    always @(posedge clk) begin
        if(rst) begin
            ALUResultW <= 32'd0;
            ReadDataW <= 32'd0;
            RdW <= 5'd0;
            PCPlus4W <= 32'd0;
            RegWriteW <= 1'd0;
            ResultSrcW <= 2'd0;
        end
        else
            ALUResultW <= ALUResultM;
            ReadDataW <= ReadDataM;
            RdW <= RdM;
            PCPlus4W <= PCPlus4M;
            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;
    end
endmodule