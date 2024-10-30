module controller(op,funct3,funct7,Zero,LessThan, PCSrc,ResultSrc,MemWrite,
        ALUControl,ALUSrc,ImmSrc,RegWrite);
    input Zero,LessThan;
    input [6:0] op,funct7;
    input [2:0] funct3;
    output MemWrite,ALUSrc,RegWrite;
    output [2:0] ALUControl,ImmSrc;
    output [1:0] ResultSrc,PCSrc;
    reg MemWrite,ALUSrc,RegWrite;
    reg [2:0] ALUControl,ImmSrc;
    reg [1:0] ResultSrc,PCSrc;
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
    always@(op,funct3,funct7,Zero) begin
        {PCSrc,ResultSrc,MemWrite,
        ALUControl,ALUSrc,ImmSrc,RegWrite} = 13'd0;
        case (op)
            R_Type_0: begin PCSrc=2'b00;ResultSrc=2'b00;MemWrite=0;
            ALUControl = (funct7 == _sub_) ? 3'b001 :
                (funct3 == _add_sub_jalr_beq) ? 3'b000 : 
                (funct3 == _and) ? 3'b010 : (funct3 == _or) ? 
                3'b011 : (funct3 == _slt_lw_sw) ? 3'b101 : 
                (funct3 == _sltu) ? 3'b100 : 3'b000;
            ALUSrc=0;RegWrite=1;
            end
            I_Type_0: begin PCSrc=2'b00;ResultSrc=2'b01;MemWrite=0;
            ALUControl = 3'b000;
            ALUSrc=1;ImmSrc=3'b000;RegWrite=1;
            end
            I_Type_1: begin PCSrc=2'b00;ResultSrc=2'b00;MemWrite=0;
            ALUControl = (funct3 == _add_sub_jalr_beq) ? 3'b000 : 
                (funct3 == _xori_blt) ? 3'b110 : (funct3 == _or) ? 
                3'b011 : (funct3 == _slt_lw_sw) ? 3'b101 : 
                (funct3 == _sltu) ? 3'b100 : 3'b000;
            ALUSrc=1;ImmSrc=3'b000;RegWrite=1;
            end
            I_Type_2: begin PCSrc=2'b10;ResultSrc=2'b10;MemWrite=0;
                ALUControl = 3'b000;
                ALUSrc=1;ImmSrc=3'b000;RegWrite=1;
            end
            S_Type_0: begin PCSrc=2'b00;ResultSrc=2'b01;MemWrite=1;
                ALUControl = 3'b000;
                ALUSrc=1;ImmSrc=3'b001;RegWrite=0;
            end
            J_Type_0: begin PCSrc=2'b01;ResultSrc=2'b10;MemWrite=0;
                ALUControl=3'b000;
                ALUSrc=1;ImmSrc=3'b100;RegWrite=1;
            end
            B_Type_0: begin PCSrc= 
                (funct3 == _add_sub_jalr_beq && Zero) ? 2'b01 : 
                (funct3 == _bne && ~Zero) ? 2'b01 : 
                (funct3 == _xori_blt && LessThan) ? 2'b01 : 
                (funct3 == _bge && (~LessThan || Zero)) ? 
                2'b01 : 2'b00;
                MemWrite=0;ALUSrc=0;ImmSrc=3'b010;RegWrite=0;
            end
            U_Type_0: begin PCSrc=2'b00;ResultSrc=2'b11;MemWrite=0;
                ImmSrc=3'b011;RegWrite=1;
            end
            default: {PCSrc,ResultSrc,MemWrite,
            ALUControl,ALUSrc,ImmSrc,RegWrite} = 13'd0;
        endcase
    end
endmodule