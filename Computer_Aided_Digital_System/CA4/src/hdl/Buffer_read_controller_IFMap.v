module buffer_read_controller_IFMap#(parameter SPAD_ADDR_WIDTH = 3, SPAD_DEPTH = 7)(stall,clr_addr,valid,start_row,end_row,done,spad_raddr,init,clk,rst, 
valid_start,valid_end,ren_buf,wen_spad,spad_waddr,start_data,end_data);
    input stall,clr_addr,valid,init,done,start_row,end_row,clk,rst;
    input [SPAD_ADDR_WIDTH-1:0] spad_raddr;
    output reg ren_buf,wen_spad,valid_end,valid_start;
    output [SPAD_ADDR_WIDTH-1:0] spad_waddr,start_data,end_data;
    wire safe_to_overwrite;
    wire [SPAD_ADDR_WIDTH-1:0] start_data_reg,end_data_reg,next_start_data,next_end_data,start_in,end_in;
    reg ld_s=0,sel_s=0,sel_e=0,ld_e=0,cnten=0;
    parameter [2:0] IDLE=0,READ=1,READ_S=2,READ_SE=3,READ_SENS=4,READ_SENSNE=5;
    reg [2:0] ns=IDLE,ps=IDLE;
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
            READ: begin ns = valid ? READ_S : READ; end
            READ_S: begin ns = (end_row && valid) ? READ_SE : READ_S; end
            READ_SE: begin ns = done ? READ : (valid && safe_to_overwrite) ? READ_SENS : READ_SE; end
            READ_SENS: begin ns = done ? READ_S : end_row ? READ_SENSNE : READ_SENS; end
            READ_SENSNE: begin ns = done ? READ_SE : READ_SENSNE; end
            default: ns= IDLE;
        endcase
    end
    always@(*) begin
        {ren_buf,wen_spad,cnten,ld_s,sel_s,ld_e,sel_e,valid_end,valid_start} = 9'd1;
        case (ps)
            IDLE: valid_start=1'b0;
            READ: {ren_buf,wen_spad,cnten,ld_s,valid_start,sel_s,ld_e,sel_e,valid_end} = {{5{valid}},4'b0000};
            READ_S: {ren_buf,wen_spad,cnten,ld_s,sel_s,ld_e,sel_e,valid_end} = 
                {{3{valid && safe_to_overwrite}},2'b00,(valid && end_row),1'b0,(valid && end_row)};
            READ_SE: {ren_buf,wen_spad,cnten,ld_s,sel_s,ld_e,sel_e,valid_end} = {{3{valid && !done && safe_to_overwrite}},4'b0000,1'b1};
            READ_SENS: {ren_buf,wen_spad,cnten,ld_s,sel_s,ld_e,sel_e,valid_end} = {{3{valid && !done && safe_to_overwrite}},{2{done}},2'b00,1'b1};
            READ_SENSNE: {ren_buf,wen_spad,cnten,ld_s,sel_s,ld_e,sel_e,valid_end} = {3'b000,{4{done}},1'b1};
            default: {ren_buf,wen_spad,cnten,ld_s,sel_s,ld_e,sel_e,valid_end,valid_start} = 9'd1;
        endcase
    end
    assign start_data = (ld_s) ? start_in : start_data_reg;
    assign end_data = (ld_e) ? end_in : end_data_reg;
    assign safe_to_overwrite = (spad_waddr != start_data);
    assign start_in = sel_s ? next_start_data : spad_waddr;
    assign end_in = sel_e ? next_end_data : spad_waddr;
    counter #(.WIDTH(SPAD_ADDR_WIDTH),.WIDTH_INC(1))cnter(.max_count(SPAD_DEPTH[SPAD_ADDR_WIDTH-1:0]),.inc(1'b1),.cnt(cnten),
        .stall(stall),.clr(clr_addr),.clk(clk),.rst(rst), .pout(spad_waddr),.co());
    register #(.WIDTH(SPAD_ADDR_WIDTH))start_reg(.pin(start_in),.ld(ld_s),.stall(stall),.clk(clk),.rst(rst), .pout(start_data_reg));
    register #(.WIDTH(SPAD_ADDR_WIDTH))next_start_reg(.pin(spad_waddr),.stall(stall),.ld(start_row),.clk(clk),.rst(rst), .pout(next_start_data));
    register #(.WIDTH(SPAD_ADDR_WIDTH))end_reg(.pin(end_in),.ld(ld_e),.stall(stall),.clk(clk),.rst(rst), .pout(end_data_reg));
    register #(.WIDTH(SPAD_ADDR_WIDTH))next_end_reg(.pin(spad_waddr),.ld(end_row),.stall(stall),.clk(clk),.rst(rst), .pout(next_end_data));
endmodule