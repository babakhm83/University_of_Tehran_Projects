module datapath(clk,rst,RegWriteD,ResultSrcD,MemWriteD,JumpD,BranchD,ALUControlD,
ALUSrcD,ImmSrcD,InstrF,InstrD,ReadDataM,StallF,StallD,FlushD,FlushE,ForwardAE,ForwardBE, 
ZeroE,LessThanE,PCF,ALUResultM,WriteDataM,Rs1D,Rs2D,Rs1E,Rs2E,RdE,ResultSrcE,RdM,
RegWriteM,RdW,RegWriteW,PCSrcE,MemWriteM);
  input clk,rst,RegWriteD,MemWriteD,JumpD,BranchD,ALUSrcD,StallF,StallD,FlushD,FlushE;
  input [2:0] ALUControlD,ImmSrcD;
  input [1:0] ResultSrcD,ForwardAE,ForwardBE;
  input [31:0] InstrF,InstrD,ReadDataM;
  output ZeroE,LessThanE,RegWriteM,RegWriteW,MemWriteM;
  output [31:0] ALUResultM,PCF,WriteDataM;
  output [1:0] ResultSrcE,PCSrcE;
  output [4:0] Rs1D,Rs2D,Rs1E,Rs2E,RdE,RdM,RdW;
  wire RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE;
  wire [1:0] ResultSrcM,ResultSrcW;
  wire [2:0] ALUControlE,ImmSrcE;
  wire [4:0] RdD;
  wire [31:0] PCNextF,PCD,RD1D,RD2D,RD1E,RD2E,PCPlus4E,
    PcTargetE,ExtImmD,PCPlus4F,ResultW,PCPlus4D,ExtImmE,
    SrcAE,SrcBE,ALUResultE,WriteDataE,PCE,PCPlus4M,
    ALUResultW,ReadDataW,PCPlus4W;
  mux_four_input mux_pcF(PCPlus4F,PcTargetE,ALUResultE,32'd0,PCSrcE, PCNextF);
  pc_register pcF(clk,rst,~StallF,PCNextF, PCF);
  full_adder fa_pc_4F(PCF,32'd4,PCPlus4F);
  registerFD FD(clk,rst,~StallD,FlushD,InstrF,PCF,PCPlus4F, InstrD,PCD,PCPlus4D);
  register_file rfD(clk,rst,InstrD[19:15],InstrD[24:20],
    RdW,ResultW,RegWriteW, RD1D,RD2D);
  extend extD(InstrD[31:7],ImmSrcD, ExtImmD);
  assign Rs1D=InstrD[19:15];
  assign Rs2D=InstrD[24:20];
  assign RdD=InstrD[11:7];
  registerDE DE(clk,rst,FlushE,RD1D,RD2D,PCD,Rs1D,Rs2D,RdD,ExtImmD,PCPlus4D,RegWriteD,ResultSrcD,MemWriteD,
    JumpD,BranchD,ALUControlD,ALUSrcD,ImmSrcD, 
    RD1E,RD2E,PCE,Rs1E,Rs2E,RdE,ExtImmE,PCPlus4E,RegWriteE,ResultSrcE,MemWriteE,
    JumpE,BranchE,ALUControlE,ALUSrcE,ImmSrcE);
  mux_four_input mux_srcaE(RD1E,ResultW,ALUResultM,32'd0,ForwardAE, SrcAE);
  mux_four_input mux_srcb0E(RD2E,ResultW,ALUResultM,32'd0,ForwardBE, WriteDataE);
  mux_two_input mux_srcb1E(WriteDataE,ExtImmE,ALUSrcE, SrcBE);
  ALU aluE(SrcAE,SrcBE,ALUControlE, ALUResultE,ZeroE,LessThanE);
  full_adder fa_pc_immE(PCE,ExtImmE,PcTargetE);
  assign PCSrcE=(JumpE||(BranchE&&ZeroE)) ? ((ImmSrcE) ? 2'b01 : 2'b10) : 2'b00;
  registerEM EM(clk,rst,ALUResultE,WriteDataE,RdE,PCPlus4E,RegWriteE,ResultSrcE,MemWriteE, 
    ALUResultM,WriteDataM,RdM,PCPlus4M,RegWriteM,ResultSrcM,MemWriteM);
  registerMW MW(clk,rst,ALUResultM,ReadDataM,RdM,PCPlus4M,RegWriteM,ResultSrcM, 
    ALUResultW,ReadDataW,RdW,PCPlus4W,RegWriteW,ResultSrcW);
  mux_four_input mux_ResultW(ALUResultW,ReadDataW,PCPlus4W,
    32'd0,ResultSrcW, ResultW);
  endmodule