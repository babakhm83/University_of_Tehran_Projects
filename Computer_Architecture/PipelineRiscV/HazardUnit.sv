module hazard_unit(Rs1D,Rs2D,PCSrcE,Rs1E,Rs2E,RdE,ResultSrcE,RdM,RegWriteM,RdW,RegWriteW, 
StallF,StallD,FlushD,FlushE,ForwardAE,ForwardBE);
    input RegWriteM,RegWriteW;
    input [1:0] ResultSrcE,PCSrcE;
    input [4:0] Rs1D,Rs2D,Rs1E,Rs2E,RdE,RdM,RdW;
    output StallF,StallD,FlushD,FlushE;
    output [1:0] ForwardAE,ForwardBE;
    assign ForwardAE=((Rs1E==RdM) && (RegWriteM) && (Rs1E)) ? 2'b10 : 
        ((Rs1E==RdW) && (RegWriteW) && (Rs1E)) ? 2'b01 : 2'b00;
    assign ForwardBE=((Rs2E==RdM) && (RegWriteM) && (Rs2E)) ? 2'b10 : 
        ((Rs2E==RdW) && (RegWriteW) && (Rs2E)) ? 2'b01 : 2'b00;
    wire lwStall;
    assign lwStall = (((Rs1D == RdE) || (Rs2D == RdE)) && (ResultSrcE==2'b01) && (RdE)) ? 1'b1 : 1'b0;
    assign StallF = lwStall ? 1'b1 : 1'b0;
    assign StallD = lwStall ? 1'b1 : 1'b0;
    assign FlushD = PCSrcE ? 1'b1 : 1'b0;
    assign FlushE = (lwStall || PCSrcE) ? 1'b1 : 1'b0;
endmodule