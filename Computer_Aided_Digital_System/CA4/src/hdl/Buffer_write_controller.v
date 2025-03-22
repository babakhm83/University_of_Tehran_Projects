module buffer_write_controller(done,ready,clk,rst, wen,stall);
    input done,ready,clk,rst;
    output reg wen,stall;
    parameter IDLE=0,WRITE=1;
    reg ns=IDLE,ps=IDLE;
    always@(posedge clk) begin
        if(rst)
            ps<=IDLE;
        else
            ps<=ns;
    end
    always@(*) begin
        ns=IDLE;
        case (ps)
            IDLE: begin ns = (done) ? WRITE : IDLE; end
            WRITE: begin ns = (!ready) ? WRITE : IDLE; end
            default: ns= IDLE;
        endcase
    end
    always@(*) begin
        {wen,stall} = 2'd0;
        case (ps)
            IDLE:;
            WRITE: {wen,stall} = {ready,!ready};
            default: {wen,stall} = 2'd0;
        endcase
    end
endmodule