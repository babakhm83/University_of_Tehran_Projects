module registerEM(clk,rst,ALUResultE,WriteDataE,RdE,PCPlus4E,RegWriteE,ResultSrcE,MemWriteE, 
ALUResultM,WriteDataM,RdM,PCPlus4M,RegWriteM,ResultSrcM,MemWriteM);
    input clk,rst,RegWriteE,MemWriteE;
    input [31:0] ALUResultE,WriteDataE,PCPlus4E;
    input [4:0] RdE;
    input [1:0] ResultSrcE;
    output [31:0] ALUResultM,WriteDataM,PCPlus4M;
    output [4:0] RdM;
    output [1:0] ResultSrcM;
    output RegWriteM,MemWriteM;
    reg [31:0] ALUResultM = 32'd0, WriteDataM = 32'd0, PCPlus4M = 32'd0;
    reg [4:0] RdM = 5'd0;
    reg [1:0] ResultSrcM = 2'd0;
    reg RegWriteM = 1'd0,MemWriteM = 1'd0;
    always @(posedge clk) begin
        if(rst) begin
            ALUResultM <= 32'd0;
            WriteDataM <= 32'd0;
            PCPlus4M <= 32'd0;
            RdM <= 5'd0;
            ResultSrcM <= 2'd0;
            RegWriteM <= 1'd0;
            MemWriteM <= 1'd0;
        end
        else
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            PCPlus4M <= PCPlus4E;
            RdM <= RdE;
            ResultSrcM <= ResultSrcE;
            RegWriteM <= RegWriteE;
            MemWriteM <= MemWriteE;
    end
endmodule