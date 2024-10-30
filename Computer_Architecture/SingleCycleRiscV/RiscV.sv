module risc_v(clk,rst,IMLD,IMWD,IMA,DMLD,DMWD,DMA);
  input clk,rst,IMLD,DMLD;
  input [31:0] IMWD,IMA,DMWD,DMA;
  wire MemWrite,ALUSrc,RegWrite,Zero,LessThan;
  wire [2:0] ALUControl,ImmSrc;
  wire [1:0] ResultSrc,PCSrc;
  wire [31:0] Instr,ReadData,ALUResult,PC,WriteData;
  datapath dp(clk,rst,PCSrc,ResultSrc,MemWrite,ALUControl,
  ALUSrc,ImmSrc,RegWrite,Instr,ReadData, Zero,LessThan,PC,ALUResult,WriteData);
  controller cntrl(Instr[6:0],Instr[14:12],Instr[31:25]
    ,Zero,LessThan, PCSrc,ResultSrc,MemWrite,
    ALUControl,ALUSrc,ImmSrc,RegWrite);
  instruction_memory inst_mem(PC,IMLD,IMWD,IMA, Instr);
  data_memory data_mem(clk,rst,ALUResult,WriteData,MemWrite,DMLD,DMWD,DMA, ReadData);
endmodule