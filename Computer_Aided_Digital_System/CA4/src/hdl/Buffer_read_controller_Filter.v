module buffer_read_controller_Filter#(parameter SPAD_ADDR_WIDTH = 3, SPAD_DEPTH = 7)(valid,stall,init,clk,rst, valid_end,ren_buf,wen_spad,spad_waddr);
    input valid,stall,init,clk,rst;
    output reg valid_end,ren_buf,wen_spad;
    output [SPAD_ADDR_WIDTH-1:0] spad_waddr;
    reg cnten;
    wire co;
    parameter IDLE=0,READ=1;
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
            IDLE: begin ns = init ? READ : IDLE; end
            READ: begin ns = co ? IDLE : READ; end
            default: ns= IDLE;
        endcase
    end
    always@(*) begin
        {cnten,wen_spad,ren_buf,valid_end} = 4'd0;
        case (ps)
            IDLE: valid_end = 1'b1;
            READ: {cnten,wen_spad,ren_buf} = {3{valid}};
            default: {cnten,wen_spad,ren_buf,valid_end} = 4'd0;
        endcase
    end
    counter#(.WIDTH(SPAD_ADDR_WIDTH),.WIDTH_INC(1))cnter(.max_count(SPAD_DEPTH[SPAD_ADDR_WIDTH-1:0]),.inc(1'b1),
        .stall(stall),.cnt(cnten),.clr(init),.clk(clk),.rst(rst), .pout(spad_waddr),.co(co));
endmodule