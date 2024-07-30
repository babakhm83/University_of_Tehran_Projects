module registerDE(clk,rst,CLR,RD1D,RD2D,PCD,Rs1D,Rs2D,RdD,ExtImmD,PCPlus4D,RegWriteD,ResultSrcD,MemWriteD,
JumpD,BranchD,ALUControlD,ALUSrcD,ImmSrcD, 
RD1E,RD2E,PCE,Rs1E,Rs2E,RdE,ExtImmE,PCPlus4E,RegWriteE,ResultSrcE,MemWriteE,
JumpE,BranchE,ALUControlE,ALUSrcE,ImmSrcE);
    input clk,rst,CLR,RegWriteD,MemWriteD,JumpD,BranchD,ALUSrcD;
    input [31:0] RD1D,RD2D,PCD,ExtImmD,PCPlus4D;
    input [4:0] Rs1D,Rs2D,RdD;
    input [2:0] ALUControlD,ImmSrcD;
    input [1:0] ResultSrcD;
    output [31:0] RD1E,RD2E,PCE,ExtImmE,PCPlus4E;
    output [4:0] Rs1E,Rs2E,RdE;
    output [2:0] ALUControlE,ImmSrcE;
    output [1:0] ResultSrcE;
    output RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE;
    reg [31:0] RD1E = 32'd0, RD2E = 32'd0, PCE = 32'd0, ExtImmE = 32'd0, PCPlus4E = 32'd0;
    reg [4:0] Rs1E = 32'd0, Rs2E = 32'd0, RdE = 32'd0;
    reg [2:0] ALUControlE= 3'd0,ImmSrcE=3'd0;
    reg [1:0] ResultSrcE= 2'd0;
    reg RegWriteE=1'b0,MemWriteE=1'b0,JumpE=1'b0,BranchE=1'b0,ALUSrcE=1'b0;
    always @(posedge clk) begin
        if(rst) begin
            RD1E <= 32'd0;
            RD2E <= 32'd0;
            PCE <= 32'd0;
            ExtImmE <= 32'd0;
            PCPlus4E <= 32'd0;
            Rs1E <= 5'd0;
            Rs2E <= 5'd0;
            RdE <= 5'd0;
            RegWriteE <= 1'b0;
            ResultSrcE <= 2'b0;
            MemWriteE <= 1'b0;
            JumpE <= 1'b0;
            BranchE <= 1'b0;
            ALUControlE <= 3'b0;
            ALUSrcE <= 1'b0;
            ImmSrcE <= 3'b0;
        end
        else
            if(CLR) begin
                RD1E <= 32'd0;
                RD2E <= 32'd0;
                PCE <= 32'd0;
                ExtImmE <= 32'd0;
                PCPlus4E <= 32'd0;
                Rs1E <= 5'd0;
                Rs2E <= 5'd0;
                RdE <= 5'd0;
                RegWriteE <= 1'b0;
                ResultSrcE <= 2'b0;
                MemWriteE <= 1'b0;
                JumpE <= 1'b0;
                BranchE <= 1'b0;
                ALUControlE <= 3'b0;
                ALUSrcE <= 1'b0;
                ALUSrcE <= 1'b0;
                ImmSrcE <= 3'b0;
            end
            else begin
                RD1E <= RD1D;
                RD2E <= RD2D;
                PCE <= PCD;
                ExtImmE <= ExtImmD;
                PCPlus4E <= PCPlus4D;
                Rs1E <= Rs1D;
                Rs2E <= Rs2D;
                RdE <= RdD;
                RegWriteE <= RegWriteD;
                ResultSrcE <= ResultSrcD;
                MemWriteE <= MemWriteD;
                JumpE <= JumpD;
                BranchE <= BranchD;
                ALUControlE <= ALUControlD;
                ALUSrcE <= ALUSrcD;
                ImmSrcE <= ImmSrcD;
            end
    end
endmodule