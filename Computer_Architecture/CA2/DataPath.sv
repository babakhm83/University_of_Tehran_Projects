module datapath(clk,rst,PCSrc,ResultSrc,MemWrite,ALUControl,
    ALUSrc,ImmSrc,RegWrite,Instr,ReadData, Zero,LessThan,PC,ALUResult,WriteData);
  input clk,rst,MemWrite,ALUSrc,RegWrite;
  input [2:0] ALUControl,ImmSrc;
  input [1:0] ResultSrc,PCSrc;
  input [31:0] Instr,ReadData;
  output Zero,LessThan;
  output [31:0] ALUResult,PC,WriteData;
  wire [31:0] PCNext,SrcA,SrcB,
    PcTarget,ImmExt,PCPlus4,Result;
  mux_four_input mux_pc(PCPlus4,PcTarget,ALUResult,32'd0,PCSrc, PCNext);
  pc_register pc(clk,rst,PCNext, PC);
  register_file rf(clk,rst,Instr[19:15],Instr[24:20],
    Instr[11:7],Result,RegWrite, SrcA,WriteData);
  mux_two_input mux_srcb(WriteData,ImmExt,ALUSrc, SrcB);
  ALU alu(SrcA,SrcB,ALUControl, ALUResult,Zero,LessThan);
  full_adder fa_pc_4(PC,32'd4,PCPlus4);
  full_adder fa_pc_imm(PC,ImmExt,PcTarget);
  mux_four_input mux_result(ALUResult,ReadData,PCPlus4,
    ImmExt,ResultSrc, Result);
  extend ext(Instr[31:7],ImmSrc, ImmExt);
endmodule