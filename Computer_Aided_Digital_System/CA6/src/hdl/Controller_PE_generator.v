module controller_PE_generator#(parameter N_WIDTH,N,GLOBAL_BUFFER_ADDR_WIDTH,GLOBAL_BUFFER_DEPTH,IFMAP_SIZE_WIDTH,FILTER_SIZE_WIDTH)
(Start,mode,filter_size,ifmap_size,done_in,valid_psum,clk,rst,raddr_global_buffer,waddr_global_buffer,Start_pe,wen_filter,
wen_global_buffer,ren_psum,wen_ifmap,done_out,wr_psum_pe);
    input Start,done_in,valid_psum,clk,rst;
    input [FILTER_SIZE_WIDTH-1:0] filter_size;
    input [IFMAP_SIZE_WIDTH-1:0] ifmap_size;
    input [1:0] mode;
    output reg Start_pe,wen_global_buffer,ren_psum,done_out,wr_psum_pe;
    output reg [N-1:0] wen_ifmap=0,wen_filter=0;
    output [GLOBAL_BUFFER_ADDR_WIDTH-1:0] raddr_global_buffer,waddr_global_buffer;
    
    wire [IFMAP_SIZE_WIDTH-1:0] ifmap_index;
    wire [FILTER_SIZE_WIDTH:0] filter_index;
    wire [GLOBAL_BUFFER_ADDR_WIDTH-1:0] filter_addr,ifmap_addr;
    wire [N_WIDTH-1:0] PE_index;
    wire co_N,co_filter,co_ifmap;
    wire [FILTER_SIZE_WIDTH:0] mode_filter_size;
    reg cnten_waddr=1'b0,clr_counters=1'b0,cnten_ifmap=1'b0,cnten_N=1'b0,cnten_filter=1'b0;
    
    assign mode_filter_size = (mode==2) ? {filter_size[FILTER_SIZE_WIDTH-1:0],1'b0} : {1'b0,filter_size};
    assign filter_addr = filter_index + (PE_index * mode_filter_size);
    assign ifmap_addr = ifmap_index + (PE_index * ifmap_size) + mode_filter_size * N;
    
    parameter [2:0] IDLE=0,WAIT=1,FILTER=2,START=3,IFMAP=4,RUN=5,WRITE_OUTPUT=6,DONE=7;
    reg [2:0] ns=IDLE,ps=IDLE;
    always@(posedge clk) begin
        if(rst)
        ps<=IDLE;
        else
            ps<=ns;
    end
    assign raddr_global_buffer = (ps==IFMAP || ps==START) ? ifmap_addr : filter_addr;
    always@(*) begin
        ns=IDLE;
        case (ps)
            IDLE: begin ns = Start ? WAIT : IDLE; end
            WAIT: begin ns = Start ? WAIT : FILTER; end
            FILTER: begin ns = (co_N & co_filter) ? START : FILTER; end
            START: begin ns = IFMAP; end
            IFMAP: begin ns = (co_N & co_ifmap) ? RUN : IFMAP; end
            RUN: begin ns = done_in ? WRITE_OUTPUT : RUN; end
            WRITE_OUTPUT: begin ns = valid_psum ? WRITE_OUTPUT : DONE; end
            DONE: begin ns = IDLE; end
            default: ns = IDLE;
        endcase
    end
    always@(*) begin
        {cnten_filter,cnten_N,Start_pe,ren_psum,cnten_ifmap,done_out,wr_psum_pe,wen_global_buffer,cnten_waddr,clr_counters} = 10'd0;
        case (ps)
            IDLE:;
            WAIT: {clr_counters} = {1'b1};
            FILTER: begin 
                {cnten_filter,cnten_N} = {1'b1,co_filter};
                wen_filter={N{1'b0}};
                wen_filter[PE_index]=1'b1;
            end
            START: {Start_pe,wen_filter} = {1'b1,{N{1'b0}}};
            IFMAP: begin 
                {cnten_N,cnten_ifmap} = {1'b1,co_N};
                wen_ifmap = {N{1'b0}};
                wen_ifmap[PE_index] = 1'b1;
            end
            RUN: {wr_psum_pe,wen_ifmap} = {1'b1,{N{1'b0}}};
            WRITE_OUTPUT: {wen_global_buffer,ren_psum,cnten_waddr} = {3'b111};
            DONE: {done_out} = {1'b1};
            default: {cnten_filter,cnten_N,Start_pe,ren_psum,cnten_ifmap,done_out,wr_psum_pe,wen_global_buffer,cnten_waddr,clr_counters} = 10'd0;
        endcase
    end
    counter#(.WIDTH(FILTER_SIZE_WIDTH+1),.WIDTH_INC(1))counter_filter(.max_count(mode_filter_size),.inc(1'b1),
    .stall(1'b0),.cnt(cnten_filter),.clr(clr_counters),.clk(clk),.rst(rst), .pout(filter_index),.co(co_filter));
    counter#(.WIDTH(IFMAP_SIZE_WIDTH),.WIDTH_INC(1))counter_ifmap(.max_count(ifmap_size),.inc(1'b1),
    .stall(1'b0),.cnt(cnten_ifmap),.clr(clr_counters),.clk(clk),.rst(rst), .pout(ifmap_index),.co(co_ifmap));
    counter#(.WIDTH(N_WIDTH),.WIDTH_INC(1))counter_PE(.max_count(N[N_WIDTH-1:0]),.inc(1'b1),.stall(1'b0),.cnt(cnten_N),
        .clr(clr_counters),.clk(clk),.rst(rst), .pout(PE_index),.co(co_N));
    wire [GLOBAL_BUFFER_ADDR_WIDTH-1:0] waddr;
    assign waddr = ((GLOBAL_BUFFER_DEPTH + 1) / 2);
    counter_with_load#(.WIDTH(GLOBAL_BUFFER_ADDR_WIDTH),.WIDTH_INC(1))counter_waddr(.pin(waddr),.ld(clr_counters),.cnt(cnten_waddr),.clr(1'b0),.inc(1'b1),
        .max_count(GLOBAL_BUFFER_DEPTH[GLOBAL_BUFFER_ADDR_WIDTH-1:0]),.stall(1'b0),.clk(clk),.rst(rst), .pout(waddr_global_buffer));
endmodule