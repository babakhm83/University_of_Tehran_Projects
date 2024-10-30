module datapath(clk,rst,PCWrite,AdrSrc,IRWrite,ResultSrc,ALUControl,
    ALUSrcB,ALUSrcA,ImmSrc,RegWrite,ReadData, Zero,LessThan,Instr,Adr,WriteData);
  input clk,rst,RegWrite,AdrSrc,IRWrite,PCWrite;
  input [2:0] ALUControl,ImmSrc;
  input [1:0] ResultSrc,ALUSrcB,ALUSrcA;
  input [31:0] ReadData;
  output Zero,LessThan;
  output [31:0] WriteData,Instr,Adr;
  wire [31:0] A,SrcA,SrcB,OldPC,Instr,RD1,RD2,PC,
    ImmExt,Result,ALUResult,ALUOut,Data;
  register_with_en pc(clk,rst,Result,PCWrite, PC);
  mux_two_input mux_pc(PC,Result,AdrSrc, Adr);
  register_with_en old_pc(clk,rst,PC,IRWrite, OldPC);
  register_with_en instr(clk,rst,ReadData,IRWrite, Instr);
  register_file rf(clk,rst,Instr[19:15],Instr[24:20],
    Instr[11:7],Result,RegWrite, RD1,RD2);
  register a(clk,rst,RD1,A);
  register b(clk,rst,RD2,WriteData);
  mux_four_input mux_a(PC,OldPC,A,32'd0,ALUSrcA, SrcA);
  mux_four_input mux_b(WriteData,ImmExt,32'd4,32'd0,ALUSrcB, SrcB);
  ALU alu(SrcA,SrcB,ALUControl, ALUResult,Zero,LessThan);
  register ALU_result_reg(clk,rst,ALUResult,ALUOut);
  mux_four_input mux_result(ALUOut,Data,ALUResult,
    ImmExt,ResultSrc, Result);
  extend ext(Instr[31:7],ImmSrc, ImmExt);
  register MDR(clk,rst,ReadData, Data);
endmodule