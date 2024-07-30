module risc_v(clk,rst,IMLD,IMWD,IMA,DMLD,DMWD,DMA);
  input clk,rst,IMLD,DMLD;
  input [31:0] IMWD,IMA,DMWD,DMA;
  wire clk,rst,RegWriteD,MemWriteD,JumpD,BranchD,ALUSrcD,StallF,StallD,FlushD,FlushE,
    ZeroE,LessThanE,RegWriteM,RegWriteW,MemWriteM;
  wire [1:0] ResultSrcD,ResultSrcE,ForwardAE,ForwardBE,PCSrcE;
  wire [2:0] ALUControlD,ImmSrcD;
  wire [4:0] Rs1D,Rs2D,Rs1E,Rs2E,RdE,RdM,RdW;
  wire [31:0] InstrF,InstrD,ReadDataM,ALUResultM,PCF,WriteDataM;
  datapath dp(clk,rst,RegWriteD,ResultSrcD,MemWriteD,JumpD,BranchD,ALUControlD,
    ALUSrcD,ImmSrcD,InstrF,InstrD,ReadDataM,StallF,StallD,FlushD,FlushE,ForwardAE,ForwardBE, 
    ZeroE,LessThanE,PCF,ALUResultM,WriteDataM,Rs1D,Rs2D,Rs1E,Rs2E,RdE,ResultSrcE,RdM,
    RegWriteM,RdW,RegWriteW,PCSrcE,MemWriteM);
  controller cntrl(InstrD[6:0],InstrD[14:12],InstrD[31:25], ZeroE,LessThanE,ResultSrcD,MemWriteD,
    ALUControlD,ALUSrcD,ImmSrcD,RegWriteD,JumpD,BranchD);
  hazard_unit hu(Rs1D,Rs2D,PCSrcE,Rs1E,Rs2E,RdE,ResultSrcE,RdM,RegWriteM,RdW,RegWriteW, 
  StallF,StallD,FlushD,FlushE,ForwardAE,ForwardBE);
  instruction_memory inst_mem(PCF,IMLD,IMWD,IMA, InstrF);
  data_memory data_mem(clk,rst,ALUResultM,WriteDataM,MemWriteM,DMLD,DMWD,DMA, ReadDataM);
endmodule