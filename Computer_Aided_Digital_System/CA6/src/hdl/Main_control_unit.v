module main_control_unit(Start,wait_data,at_end_data,co_pipe,valid_start_addr,mode,wr_psum_in,clk,rst, 
co_psum,run_pipe,read_data,clr_pipe,done_psum,done_data,clr_addr,wen_Psum,clr_psum_addr,ld_psum_addr,r_next_IF,
r_next_Filter,ld_params,second_filter,read_filter,double_count_psum,sel_psum_addr,ready,done);
    input Start,co_psum,wait_data,at_end_data,co_pipe,valid_start_addr,wr_psum_in,clk,rst;
    input [1:0] mode;
    output reg run_pipe,read_data,clr_pipe,done_psum,done_data,clr_addr,wen_Psum,clr_psum_addr,ld_psum_addr,r_next_IF,r_next_Filter,
    ld_params,second_filter,read_filter,double_count_psum,sel_psum_addr,ready,done;
    parameter [3:0] IDLE=0,WAIT=1,INIT=2,READ_NEW_DATA=3,RUN1=4,RUN2_1=5,RUN2_2=6,RUN3=7,WAIT_WR=8,WAIT_PIPE=9,WRITE=10,DONE=11;
    reg [3:0] ns=IDLE,ps=IDLE;
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
            WAIT: begin ns = Start ? WAIT : INIT; end
            INIT: begin ns = wr_psum_in ? INIT : READ_NEW_DATA; end
            READ_NEW_DATA: begin ns = wait_data ? READ_NEW_DATA : 
                (mode == 2'd1) ? RUN1 : (mode == 2'd2) ? RUN2_1 : (mode == 2'd3) ? RUN3 : READ_NEW_DATA; end
            RUN1: begin ns = at_end_data ? RUN3 : 
                (!valid_start_addr & wait_data) ? READ_NEW_DATA : RUN1; end
            RUN2_1: begin ns = at_end_data ? WAIT_PIPE : wait_data ? RUN2_1 :
                (!valid_start_addr & wait_data) ? READ_NEW_DATA : RUN2_2; end
            RUN2_2: begin ns = at_end_data ? WAIT_PIPE : wait_data ? RUN2_2 :
                (!valid_start_addr & wait_data) ? READ_NEW_DATA : RUN2_1; end
            RUN3: begin ns = at_end_data ? WAIT_PIPE : 
                (!valid_start_addr & wait_data) ? READ_NEW_DATA : RUN3; end
            WAIT_PIPE: begin ns = WAIT_WR; end
            WAIT_WR: begin ns = wr_psum_in ? WRITE : WAIT_WR; end
            WRITE: begin ns = co_psum ? DONE : WRITE; end
            DONE: begin ns = IDLE; end
            default: ns= IDLE;
        endcase
    end
    always@(*) begin
        {run_pipe,read_data,clr_pipe,done_psum,done_data,clr_addr,wen_Psum,clr_psum_addr,ld_psum_addr,r_next_IF,
        r_next_Filter,ld_params,second_filter,read_filter,double_count_psum,sel_psum_addr,ready,done} = 18'd0;
        case (ps)
            IDLE:;
            WAIT:;
            INIT: {ld_params,ready,r_next_IF,r_next_Filter,ld_psum_addr,sel_psum_addr}={2'b11,{2{!wr_psum_in}},{2{(mode==2'd2) && !wr_psum_in}}};
            READ_NEW_DATA:;
            RUN1: {wen_Psum,run_pipe,read_data,read_filter,done_data,clr_addr,r_next_IF,clr_pipe} = 
                {{4{!wait_data}},{3{at_end_data}},co_pipe & !wait_data};
            RUN2_1: {wen_Psum,run_pipe,read_data,read_filter,done_data,clr_addr,clr_pipe,double_count_psum} = 
                {{4{!wait_data}},{2{at_end_data}},co_pipe & !wait_data,1'b1};
            RUN2_2: {wen_Psum,run_pipe,read_filter,done_data,clr_addr,clr_pipe,second_filter,double_count_psum} = 
                {{3{!wait_data}},{2{at_end_data}},co_pipe & !wait_data,2'b11};
            RUN3: {wen_Psum,run_pipe,read_data,read_filter,done_data,clr_addr,clr_pipe} = 
                {{4{!wait_data}},{2{at_end_data}},co_pipe & !wait_data};
            WAIT_PIPE:;
            WAIT_WR: clr_psum_addr = wr_psum_in;
            WRITE: {done_psum,ld_psum_addr} = {1'b1,co_psum};
            DONE: done = 1'b1;
            default: {run_pipe,read_data,clr_pipe,done_psum,done_data,clr_addr,wen_Psum,clr_psum_addr,ld_psum_addr,
            r_next_IF,r_next_Filter,ld_params,second_filter,read_filter,double_count_psum,sel_psum_addr,ready,done} = 18'd0;
        endcase
    end
endmodule