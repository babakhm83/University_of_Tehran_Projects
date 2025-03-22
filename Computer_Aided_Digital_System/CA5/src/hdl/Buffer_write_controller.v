module buffer_write_controller(done,ready,valid,co_psum,clk,rst, ren,wen,stall);
    input done,ready,valid,co_psum,clk,rst;
    output reg ren,wen,stall;
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
            WRITE: begin ns = (!ready) ? WRITE : co_psum ? IDLE : WRITE; end
            default: ns= IDLE;
        endcase
    end
    always@(*) begin
        {ren,wen,stall} = 3'd0;
        case (ps)
            IDLE:;
            WRITE: {ren,wen,stall} = {valid,ready,!ready | !valid};
            default: {ren,wen,stall} = 3'd0;
        endcase
    end
endmodule