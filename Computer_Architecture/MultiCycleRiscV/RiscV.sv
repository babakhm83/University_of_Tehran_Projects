module risc_v(clk,rst,LD,WD,A);
  input clk,rst,LD;
  input [31:0] WD,A;
  wire PCWrite,AdrSrc,IRWrite,RegWrite,MemWrite,Zero,LessThan;
  wire [2:0] ALUControl,ImmSrc;
  wire [1:0] ResultSrc,ALUSrcB,ALUSrcA;
  wire [31:0] Instr,ReadData,Adr,WriteData;
  datapath dp(clk,rst,PCWrite,AdrSrc,IRWrite,ResultSrc,ALUControl,
  ALUSrcB,ALUSrcA,ImmSrc,RegWrite,ReadData, Zero,LessThan,Instr,Adr,WriteData);
  controller cntrl(clk,rst,Instr[6:0],Instr[14:12],Instr[31:25]
    ,Zero,LessThan,PCWrite,AdrSrc,MemWrite,IRWrite,
    ResultSrc,ALUControl,ALUSrcB,ALUSrcA,ImmSrc,RegWrite);
  data_memory data_mem(clk,rst,Adr,WriteData,MemWrite,LD,WD,A, ReadData);
endmodule