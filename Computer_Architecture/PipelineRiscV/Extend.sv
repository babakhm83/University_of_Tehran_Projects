module extend(inst,src, extended);
    input [24:0] inst;
    input [2:0] src;
    output [31:0] extended;
    reg [31:0] extended;
    parameter [2:0] I=3'd0,S=3'd1,SB=3'd2,
        U=3'd3,UJ=3'd4;
    always @(inst,src) begin
        extended = {{20{inst[24]}},inst[24:13]};
        case (src)
            I: extended = {{20{inst[24]}},inst[24:13]};
            S: extended = {{20{inst[24]}},inst[24:18],inst[4:0]};
            SB: extended = {{20{inst[24]}},inst[0],inst[23:18],inst[4:1],1'b0};
            U: extended = {inst[24:5],12'd0};
            UJ: extended ={{11{inst[24]}},inst[24],inst[12:5],inst[13],inst[23:14],1'b0};
            default: extended = {{20{inst[24]}},inst[24:13]};
        endcase
    end
endmodule