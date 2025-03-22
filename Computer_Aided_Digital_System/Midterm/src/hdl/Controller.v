module controller(Start,Nlt,of,error,clk,rst, Valid,Ready,selX,sel_decode,ldN,shl,Error);
    input Start,Nlt,of,error,clk,rst;
    output reg Valid,Ready,selX,sel_decode,ldN,shl,Error;
    parameter [3:0] IDLE=0,WAIT=1,LDN=2,LDX=3,NL4=4,NG4=5,LOOP=6,ERROR=7;
    reg [3:0] ns=IDLE,ps=IDLE;
    reg cnten = 1'b0;
    wire co;
    counter #(.BITS(2))cnt(.cnt(cnten),.clk(clk),.rst(rst), .co(co));
    always@(posedge clk) begin
        if(rst)
            ps<=IDLE;
        else
            ps<=ns;
    end
    always@(*) begin
        ns=IDLE;
        case (ps)
            IDLE: begin ns = Start ? WAIT : IDLE; end
            WAIT: begin ns = Start ? WAIT : LDN; end
            LDN: begin ns = LDX; end
            LDX: begin ns = error ? ERROR : co ? Nlt ? NL4 : NG4 : LDX; end
            NL4: begin ns = error ? ERROR : NL4; end
            NG4: begin ns = error ? ERROR : co ? LOOP : NG4; end
            LOOP: begin ns = error ? ERROR : co ? NG4 : LOOP; end
            ERROR: begin ns = ERROR; end
            default: ns= IDLE;
        endcase
    end
    always@(*) begin
        {Valid,Ready,selX,sel_decode,ldN,shl,Error,cnten} = 8'd0;
        case (ps)
            IDLE: begin end
            WAIT: begin end
            LDN: begin {ldN}=1'b1; end
            LDX: begin {Ready,cnten,selX,shl,sel_decode} ={2'b11,(co & Nlt) | (!co),co & !Nlt,Nlt}; end
            NL4: begin {selX,Ready,sel_decode,Valid} ={3'b111,!of}; end
            NG4: begin {cnten,shl,sel_decode,selX} ={3'b111,co}; end
            LOOP: begin {Ready,cnten,shl,Valid,selX} ={3'b111,!of,!co}; end
            ERROR: begin {Error} = 1'b1; end
            default: {Valid,Ready,selX,sel_decode,ldN,shl,Error,cnten} = 8'd0;
        endcase
    end
endmodule