module main_control_unit(Start,wait_data,at_end_data,co_pipe,valid_start_addr,clk,rst, 
init,run_pipe,read_spad,clr_pipe,done_psum,done_data,clr_addr);
    input Start,wait_data,at_end_data,co_pipe,valid_start_addr,clk,rst;
    output reg init,run_pipe,read_spad,clr_pipe,done_psum,done_data,clr_addr;
    parameter [2:0] IDLE=0,WAIT=1,INIT=2,READ_NEW_DATA=3,RUN=4;
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
            IDLE: begin ns = Start ? WAIT : IDLE; end
            WAIT: begin ns = Start ? WAIT : INIT; end
            INIT: begin ns = READ_NEW_DATA; end
            READ_NEW_DATA: begin ns = wait_data ? READ_NEW_DATA : RUN; end
            RUN: begin ns = (!valid_start_addr & wait_data) ? READ_NEW_DATA : RUN; end
            default: ns= IDLE;
        endcase
    end
    always@(*) begin
        {init,run_pipe,read_spad,clr_pipe,done_psum,done_data,clr_addr} = 7'd0;
        case (ps)
            IDLE:;
            WAIT:;
            INIT: {clr_addr,init} = 2'b11;
            READ_NEW_DATA:;
            RUN: {run_pipe,read_spad,done_data,done_psum,clr_pipe,clr_addr} = 
                {!wait_data,!wait_data,at_end_data,co_pipe & !wait_data,
                co_pipe & !wait_data,(!valid_start_addr & wait_data)};
            default: {init,run_pipe,read_spad,clr_pipe,done_psum,done_data,clr_addr} = 7'd0;
        endcase
    end
endmodule