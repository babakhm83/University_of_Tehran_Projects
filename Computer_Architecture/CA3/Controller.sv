module controller(clk,rst,op,funct3,funct7,Zero,LessThan, 
PCWrite,AdrSrc,MemWrite,IRWrite,ResultSrc,ALUControl,
ALUSrcB,ALUSrcA,ImmSrc,RegWrite);
    input clk,rst,Zero,LessThan;
    input [6:0] op,funct7;
    input [2:0] funct3;
    output PCWrite,AdrSrc,MemWrite,IRWrite,RegWrite;
    output [2:0] ALUControl,ImmSrc;
    output [1:0] ResultSrc,ALUSrcB,ALUSrcA;
    reg PCUpdate,AdrSrc,MemWrite,IRWrite,RegWrite;
    reg [2:0] ALUControl,ImmSrc;
    reg [1:0] ResultSrc,ALUSrcB,ALUSrcA;
    wire PCOnCond;
    // opcode
    // R_Type_0: add, sub, and, or, slt, sltu
    // I_Type_0: lw
    // I_Type_1: addi, xori, ori, slti, sltiu
    // I_Type_2: jalr
    // S_Type_0: sw
    // J_Type_0: jal
    // B_Type_0: BT, bne, blt, bge
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
    parameter [3:0] IF=4'd0,ID=4'd1,BT=4'd2,UT=4'd3,RT=4'd4,
    IT=4'd5,JT=4'd6,RTW=4'd7,MREF=4'd8,SW=4'd9,LWA=4'd10,LWD=4'd11;
    reg [3:0] ns,ps;
    always@(posedge clk) begin
        if(rst)
            ns<=IF;
        else
            ps<=ns;
    end
    always@(ps,op) begin
        ns=IF;
        case (ps)
            IF : begin ns = ID; end
            ID: begin 
                ns = (op==B_Type_0) ? BT : 
                (op==U_Type_0) ? UT :
                (op==R_Type_0) ? RT : 
                (op==I_Type_1) ? IT :
                (op==J_Type_0) ? JT : MREF; end
            BT: begin ns = IF; end
            UT: begin ns = IF; end
            RT: begin ns = RTW; end
            IT: begin ns = RTW; end
            JT: begin ns = RTW; end
            RTW: begin ns = IF; end
            MREF: begin ns = (op==S_Type_0) ? SW :
                 (op==I_Type_2) ? JT : LWA; end
            SW: begin ns = IF; end
            LWA: begin ns = LWD; end
            LWD: begin ns = IF; end
            default: ns= IF;
        endcase
    end
    always@(ps) begin
        {PCUpdate,AdrSrc,MemWrite,IRWrite,ResultSrc,ALUControl,
        ALUSrcB,ALUSrcA,ImmSrc,RegWrite} = 17'd0;
        case (ps)
            IF : begin PCUpdate=1'b1;AdrSrc=1'b0;MemWrite=1'b0;
                IRWrite=1'b1;ResultSrc=2'b10;ALUControl=3'b000;
                ALUSrcB=2'b10;ALUSrcA=2'b00;RegWrite=1'b0; end
            ID: begin PCUpdate=1'b0;AdrSrc=1'b0;MemWrite=1'b0;
                IRWrite=1'b0;ALUControl=3'b000;
                ImmSrc= (op==B_Type_0) ? 3'b010 : (op==U_Type_0) ? 3'b011 : 
                (op==J_Type_0) ? 3'b100 : 3'b000;
                ALUSrcB=2'b01;ALUSrcA=2'b01;RegWrite=1'b0; end
            BT: begin PCUpdate=1'b0;AdrSrc=1'b0;MemWrite=1'b0;
                IRWrite=1'b0;ResultSrc=2'b00;ALUControl=3'b001;
                ALUSrcB=2'b00;ALUSrcA=2'b10;RegWrite=1'b0; end
            UT: begin PCUpdate=1'b0;AdrSrc=1'b0;MemWrite=1'b0;
                IRWrite=1'b0;ResultSrc=2'b10;ALUControl=3'b000;
                ALUSrcB=2'b01;ALUSrcA=2'b11;RegWrite=1'b1;ImmSrc=3'b011; end
            RT: begin PCUpdate=1'b0;AdrSrc=1'b0;MemWrite=1'b0;
                IRWrite=1'b0;ALUSrcB=2'b00;ALUSrcA=2'b10;RegWrite=1'b0;
                ALUControl = (funct7 == _sub_) ? 3'b001 :
                (funct3 == _add_sub_jalr_beq) ? 3'b000 : 
                (funct3 == _and) ? 3'b010 : (funct3 == _or) ? 
                3'b011 : (funct3 == _slt_lw_sw) ? 3'b101 : 
                (funct3 == _sltu) ? 3'b100 : 3'b000; end
            IT: begin PCUpdate=1'b0;AdrSrc=1'b0;MemWrite=1'b0;ImmSrc=3'b000;
                IRWrite=1'b0;ALUSrcB=2'b01;ALUSrcA=2'b10;RegWrite=1'b0;
                ALUControl = (funct3 == _add_sub_jalr_beq) ? 3'b000 : 
                (funct3 == _xori_blt) ? 3'b110 : (funct3 == _or) ? 
                3'b011 : (funct3 == _slt_lw_sw) ? 3'b101 : 
                (funct3 == _sltu) ? 3'b100 : 3'b000; end
            JT: begin PCUpdate=1'b1;AdrSrc=1'b0;MemWrite=1'b0;ImmSrc=3'b100;
                IRWrite=1'b0;ResultSrc=2'b00;ALUSrcB=2'b10;
                ALUSrcA=2'b01;RegWrite=1'b0;ALUControl=3'b000; end
            RTW: begin PCUpdate=1'b0;AdrSrc=1'b0;MemWrite=1'b0;
                IRWrite=1'b0;ResultSrc=2'b00;RegWrite=1'b1; end
            MREF: begin PCUpdate=1'b0;AdrSrc=1'b0;MemWrite=1'b0;
                IRWrite=1'b0;ALUControl=3'b000;
                ImmSrc= (op==S_Type_0) ? 3'b001 : 3'b000;
                ALUSrcB=2'b01;ALUSrcA=2'b10;end
            SW: begin PCUpdate=1'b0;AdrSrc=1'b1;MemWrite=1'b1;
                IRWrite=1'b0;ResultSrc=2'b00;RegWrite=1'b0; end
            LWA: begin PCUpdate=1'b0;AdrSrc=1'b1;MemWrite=1'b0;
                IRWrite=1'b0;ResultSrc=2'b00;RegWrite=1'b0; end
            LWD: begin PCUpdate=1'b0;AdrSrc=1'b0;MemWrite=1'b0;
                IRWrite=1'b0;ResultSrc=2'b01;RegWrite=1'b1; end
            default: {PCUpdate,AdrSrc,MemWrite,IRWrite,ResultSrc,ALUControl,
            ALUSrcB,ALUSrcA,ImmSrc,RegWrite} = 17'd0;
        endcase
    end
    assign PCOnCond=(ps==BT) ? ((funct3 == _add_sub_jalr_beq && Zero) ? 1'b1 : 
    (funct3 == _bne && ~Zero) ? 1'b1 : 
    (funct3 == _xori_blt && LessThan) ? 1'b1 : 
    (funct3 == _bge && (~LessThan || Zero)) ? 1'b1 : 1'b0) : 1'b0;
    assign PCWrite=PCUpdate | PCOnCond;
endmodule