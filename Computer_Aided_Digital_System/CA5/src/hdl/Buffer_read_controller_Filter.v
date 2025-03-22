module buffer_read_controller_Filter#(parameter SPAD_ADDR_WIDTH = 3, SPAD_DEPTH = 7,FILTER_SIZE_WIDTH)(mode,valid,filter_size,stall,r_next_Filter,clr_addr,clk,rst, valid_end,ren_buf,wen_spad,spad_waddr);
    input valid,clr_addr,stall,r_next_Filter,clk,rst;
    input [1:0] mode;
    input [FILTER_SIZE_WIDTH-1:0] filter_size;
    output reg valid_end,ren_buf,wen_spad;
    output [SPAD_ADDR_WIDTH-1:0] spad_waddr;
    reg cnten;
    wire co;
    wire [FILTER_SIZE_WIDTH:0] mode_filter_size;
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
            IDLE: begin ns = r_next_Filter ? READ : IDLE; end
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
    assign mode_filter_size = (mode==2) ? {filter_size[FILTER_SIZE_WIDTH-1:0],1'b0} : {1'b0,filter_size};
    counter#(.WIDTH(SPAD_ADDR_WIDTH),.WIDTH_INC(1))cnter(.max_count(mode_filter_size[SPAD_ADDR_WIDTH-1:0]),.inc(1'b1),
        .stall(stall),.cnt(cnten),.clr(clr_addr),.clk(clk),.rst(rst), .pout(spad_waddr),.co(co));
endmodule