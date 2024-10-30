module controller(op,funct3,funct7, ZeroE,LessThanE,ResultSrcD,MemWriteD,
        ALUControlD,ALUSrcD,ImmSrcD,RegWriteD,JumpD,BranchD);
    input ZeroE,LessThanE;
    input [6:0] op,funct7;
    input [2:0] funct3;
    output MemWriteD,ALUSrcD,RegWriteD,JumpD,BranchD;
    output [2:0] ALUControlD,ImmSrcD;
    output [1:0] ResultSrcD;
    reg MemWriteD,ALUSrcD,RegWriteD;
    reg [2:0] ALUControlD,ImmSrcD;
    reg [1:0] ResultSrcD;
    // opcode
    // R_Type_0: add, sub, and, or, slt, sltu
    // I_Type_0: lw
    // I_Type_1: addi, xori, ori, slti, sltiu
    // I_Type_2: jalr
    // S_Type_0: sw
    // J_Type_0: jal
    // B_Type_0: beq, bne, blt, bge
    // U_Type_0: lui
    parameter [6:0] R_Type_0 = 7'b0110011,I_Type_0 = 7'b0000011,
        I_Type_1 = 7'b0010011,I_Type_2 = 7'b1100111,
        S_Type_0 = 7'b0100011,J_Type_0 = 7'b1101111,
        B_Type_0 = 7'b1100011,U_Type_0 = 7'b0110111;
    // funct3
    // immediates have same opcode as not immediates
    parameter [2:0] _add_sub_jalr_beq = 3'b000, _and = 3'b111,
        _or = 3'b110, _slt_lw_sw = 3'b010, _sltu = 3'b011, 
        _xori_blt = 3'b100, _bne = 3'b001, _bge = 3'b101;
    // funct7
    parameter [6:0] _sub_ = 7'b0100000, _other_ = 7'b0000000;
    assign JumpD=(op==J_Type_0) ? 1 : (op==I_Type_2) ? 1 : 0;
    assign BranchD=(op==B_Type_0) ? 1 : 0;
    always@(op,funct3,funct7,ZeroE) begin
        {MemWriteD,ALUSrcD,RegWriteD,ALUControlD,ImmSrcD,ResultSrcD} = 11'd0;
        case (op)
            R_Type_0: begin
                ALUControlD = (funct7 == _sub_) ? 3'b001 :
                    (funct3 == _add_sub_jalr_beq) ? 3'b000 : 
                    (funct3 == _and) ? 3'b010 : (funct3 == _or) ? 
                    3'b011 : (funct3 == _slt_lw_sw) ? 3'b101 : 
                    (funct3 == _sltu) ? 3'b100 : 3'b000;
                {MemWriteD,ALUSrcD,RegWriteD,ImmSrcD,ResultSrcD} = 8'b00100000;
            end
            I_Type_0:
                {MemWriteD,ALUSrcD,RegWriteD,ALUControlD,ImmSrcD,ResultSrcD} = 11'b01100000001;
            I_Type_1: begin
                ALUControlD = (funct3 == _add_sub_jalr_beq) ? 3'b000 : 
                    (funct3 == _xori_blt) ? 3'b110 : (funct3 == _or) ? 
                    3'b011 : (funct3 == _slt_lw_sw) ? 3'b101 : 
                    (funct3 == _sltu) ? 3'b100 : 3'b000;
                {MemWriteD,ALUSrcD,RegWriteD,ImmSrcD,ResultSrcD} = 8'b01100000;
            end
            I_Type_2:
                {MemWriteD,ALUSrcD,RegWriteD,ALUControlD,ImmSrcD,ResultSrcD} = 11'b01100000010;
            S_Type_0:
                {MemWriteD,ALUSrcD,RegWriteD,ALUControlD,ImmSrcD,ResultSrcD} = 11'b11000000100;
            J_Type_0:
                {MemWriteD,ALUSrcD,RegWriteD,ALUControlD,ImmSrcD,ResultSrcD} = 11'b01100010010;
            B_Type_0:
                {MemWriteD,ALUSrcD,RegWriteD,ALUControlD,ImmSrcD,ResultSrcD} = 11'b00000001000;
            U_Type_0:
                {MemWriteD,ALUSrcD,RegWriteD,ALUControlD,ImmSrcD,ResultSrcD} = 11'b01100001100;
            default: {MemWriteD,ALUSrcD,RegWriteD,ALUControlD,ImmSrcD,ResultSrcD} = 11'd0;
        endcase
    end
endmodule