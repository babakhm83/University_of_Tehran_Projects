module read_address_generator#(parameter FILTER_SIZE_WIDTH,STRIDE_WIDTH,IFMAP_ADDR_WIDTH,FILTER_ADDR_WIDTH,IFMAP_DEPTH)
(stall,clr_addr,read_data,filter_size,stride,start_data,end_data,end_filters,valid_end,clk,rst, 
raddr_Filter,raddr_IFMap,at_end_data,co_pipe);
    input stall,clr_addr,read_data,valid_end,clk,rst;
    input [STRIDE_WIDTH-1:0] stride;
    input [FILTER_SIZE_WIDTH-1:0] filter_size;
    input [IFMAP_ADDR_WIDTH-1:0] start_data,end_data;
    input [FILTER_ADDR_WIDTH-1:0] end_filters;
    output at_end_data,co_pipe;
    output [IFMAP_ADDR_WIDTH-1:0] raddr_IFMap;
    output [FILTER_ADDR_WIDTH-1:0] raddr_Filter;
    wire co_IFMap,co_Filter;
    wire [FILTER_SIZE_WIDTH-1:0] r_pipe;
    wire [IFMAP_ADDR_WIDTH-1:0] r_IFMap,addr_next_window;
    wire [FILTER_ADDR_WIDTH-1:0] r_Filter;
    counter #(.WIDTH(FILTER_SIZE_WIDTH),.WIDTH_INC(1))counter_pipe(.max_count(filter_size),.inc(1'b1),
        .stall(stall),.cnt(read_data),.clr(clr_addr),.clk(clk),.rst(rst), .pout(r_pipe),.co(co_pipe));
    counter_with_load #(.WIDTH(IFMAP_ADDR_WIDTH),.WIDTH_INC(STRIDE_WIDTH))counter_IFMap(.max_count(end_data),.inc(stride),
        .stall(stall),.pin(start_data),.cnt(co_pipe),.clr(clr_addr),.ld(co_IFMap | clr_addr),.clk(clk),.rst(rst), .pout(r_IFMap));
    counter #(.WIDTH(FILTER_ADDR_WIDTH),.WIDTH_INC(FILTER_SIZE_WIDTH))counter_Filter(.max_count(end_filters),.inc(filter_size),
        .stall(stall),.cnt(co_IFMap),.clr(clr_addr | at_end_data),.clk(clk),.rst(rst), .pout(r_Filter),.co());
    adder #(.WIDTH_NUM1(FILTER_ADDR_WIDTH),.WIDTH_NUM2(FILTER_SIZE_WIDTH),.WIDTH_SUM(FILTER_ADDR_WIDTH))add_Filter
        (.num1(r_Filter),.num2(r_pipe), .sum(raddr_Filter));
    add_and_mod#(.WIDTH_NUM1(IFMAP_ADDR_WIDTH),.WIDTH_NUM2(FILTER_SIZE_WIDTH),.WIDTH_SUM(IFMAP_ADDR_WIDTH),
        .MOD(IFMAP_DEPTH[IFMAP_ADDR_WIDTH-1:0]))add_IFMap(.num1(r_IFMap),.num2(r_pipe), .sum(raddr_IFMap));
    assign co_Filter = (raddr_Filter==end_filters);
    assign at_end_data = co_Filter & co_IFMap;
    add_and_mod#(.WIDTH_NUM1(IFMAP_ADDR_WIDTH),.WIDTH_NUM2(STRIDE_WIDTH),.WIDTH_SUM(IFMAP_ADDR_WIDTH),
        .MOD(IFMAP_DEPTH[IFMAP_ADDR_WIDTH-1:0]))add_end_window(.num1(raddr_IFMap),.num2(stride), .sum(addr_next_window));
    assign co_IFMap = co_pipe & (addr_next_window > end_data || raddr_IFMap==end_data) & valid_end;
endmodule