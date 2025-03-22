module Processing_element#(parameter STRIDE_WIDTH,FILTER_SIZE_WIDTH,IFMAP_SIZE_WIDTH,IFMAP_ADDR_WIDTH,IFMAP_DEPTH,PSUM_ADDR_WIDTH,PSUM_DEPTH,FILTER_ADDR_WIDTH,FILTER_DEPTH,DATA_WIDTH)
(clk,rst,Start,input_Psum,ifmap_size_in,mode_in,ready,done,wr_psum_in,IFMap,valid_IFMap,Filter,valid_Filter,valid_input_Psum,stride_in,filter_size_in,ready_Psum, Psum,ren_buf_Filter,ren_buf_IFMap,ren_buf_input_Psum,wen_buf_Psum);

    input clk,rst,Start,valid_IFMap,valid_Filter,valid_input_Psum,ready_Psum,wr_psum_in;
    input [1:0] mode_in;
    input [DATA_WIDTH-1:0] IFMap,Filter,input_Psum;
    input [STRIDE_WIDTH-1:0]stride_in;
    input [FILTER_SIZE_WIDTH-1:0] filter_size_in;
    input [IFMAP_SIZE_WIDTH-1:0] ifmap_size_in;
    output ren_buf_Filter,ren_buf_IFMap,ren_buf_input_Psum,wen_buf_Psum,ready,done;
    output [DATA_WIDTH-1:0] Psum;

    wire wen_Filter,wen_IFMap,done_psum_ctrl,done_psum,done_data,stall,at_end_data,co_pipe,run_pipe,co_psum,clr_psum_addr,r_next_IF,r_next_Filter,
    second_filter_ctrl,second_filter,double_count_psum,wen_Psum,wen_Psum_ctrl,read_data,read_filter,wait_data,valid_start_data,valid_end_data,
    valid_end_filter,clr_pipe,reg_clr_pipe,clr_addr,ld_psum_addr,ld_params,sel_psum_addr,is_zero,reg_is_zero,start_row,end_row;
    wire [1:0] mode,psum_addr_inc;
    wire [STRIDE_WIDTH-1:0]stride;
    wire [FILTER_SIZE_WIDTH-1:0] filter_size;
    wire [IFMAP_SIZE_WIDTH-1:0] ifmap_size;
    wire [DATA_WIDTH-1:0] Filter_pipe,IFMap_to_reg,IFMap_pipe,reg_Psum;
    wire [IFMAP_ADDR_WIDTH-1:0] raddr_IFMap,waddr_IFMap,start_data_addr,end_data_addr;
    wire [FILTER_ADDR_WIDTH-1:0] raddr_Filter,waddr_Filter,end_filters;
    wire [PSUM_ADDR_WIDTH-1:0] raddr_PSUM,mode_raddr_PSUM,waddr_PSUM,mode_waddr_PSUM,psum_addr_pin;
    assign end_filters = (FILTER_DEPTH / filter_size) * filter_size - 1;

    register #(.WIDTH(STRIDE_WIDTH))stride_reg(.pin(stride_in),.ld(ld_params),.stall(stall),.clk(clk),.rst(rst), .pout(stride));
    register #(.WIDTH(FILTER_SIZE_WIDTH))filter_size_reg(.pin(filter_size_in),.ld(ld_params),.stall(stall),.clk(clk),.rst(rst), .pout(filter_size));
    register #(.WIDTH(IFMAP_SIZE_WIDTH))ifmap_size_reg(.pin(ifmap_size_in),.ld(ld_params),.stall(stall),.clk(clk),.rst(rst), .pout(ifmap_size));
    register #(.WIDTH(2))mode_reg(.pin(mode_in),.ld(ld_params),.stall(stall),.clk(clk),.rst(rst), .pout(mode));

    assign {start_row,end_row} = (waddr_IFMap==0) ? 2'b10 : (waddr_IFMap==ifmap_size-1) ? 2'b01 : 
    (mode==1) ? ((waddr_IFMap==ifmap_size/2-1) ? 2'b01 : (waddr_IFMap==ifmap_size/2) ? 2'b10 : 2'b00) : 2'b00;

    buffer_read_controller_IFMap#(.SPAD_ADDR_WIDTH(IFMAP_ADDR_WIDTH), .SPAD_DEPTH(IFMAP_DEPTH))read_controller_IFMap
        (.r_next_IF(r_next_IF),.valid(valid_IFMap),.start_row(start_row),.end_row(end_row),.done(done_data),.spad_raddr(raddr_IFMap),
        .clr_addr(clr_addr),.stall(stall),.clk(clk),.rst(rst), .valid_start(valid_start_data),.valid_end(valid_end_data),
        .ren_buf(ren_buf_IFMap),.wen_spad(wen_IFMap),.spad_waddr(waddr_IFMap),.end_data(end_data_addr),.start_data(start_data_addr));    
    register_type_scratchpad #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(IFMAP_ADDR_WIDTH),.DEPTH(IFMAP_DEPTH))IFMapScratchPad
        (.raddr(raddr_IFMap),.waddr(waddr_IFMap),.wen(wen_IFMap),.din(IFMap[DATA_WIDTH-1:0]),.clk(clk),.rst(rst), .dout(IFMap_to_reg));
    register #(.WIDTH(DATA_WIDTH))reg_IFMap(.pin(IFMap_to_reg),.ld(read_data & !is_zero),.stall(stall),.clk(clk),.rst(rst), .pout(IFMap_pipe));
        
    assign mode_raddr_PSUM = (mode==2 && !done_psum_ctrl) ? second_filter ? raddr_PSUM : raddr_PSUM-1 : raddr_PSUM;
    assign psum_addr_inc = (double_count_psum) ? 2'd2 : 2'd1;
    assign psum_addr_pin = sel_psum_addr ? {{(PSUM_ADDR_WIDTH-1){1'b0}},1'b1} : {PSUM_ADDR_WIDTH{1'b1}};
    counter_with_load#(.WIDTH(PSUM_ADDR_WIDTH),.WIDTH_INC(2))Psum_r(.cnt(wen_buf_Psum | reg_clr_pipe),.clr(clr_psum_addr),.inc(psum_addr_inc),.max_count(PSUM_DEPTH[PSUM_ADDR_WIDTH-1:0]),
    .pin(psum_addr_pin),.ld(ld_psum_addr),.stall(stall),.clk(clk),.rst(rst), .pout(raddr_PSUM));
    counter_with_load#(.WIDTH(PSUM_ADDR_WIDTH),.WIDTH_INC(2))Psum_w(.cnt(reg_clr_pipe),.clr(1'b0),.inc(psum_addr_inc),.max_count(PSUM_DEPTH[PSUM_ADDR_WIDTH-1:0]),.stall(stall),
        .pin(psum_addr_pin),.ld(ld_psum_addr),.clk(clk),.rst(rst), .pout(waddr_PSUM));
    assign co_psum = (raddr_PSUM==waddr_PSUM && wen_buf_Psum);
    assign mode_waddr_PSUM = (mode==2) ? second_filter ? waddr_PSUM : waddr_PSUM-1 : waddr_PSUM;

    assign is_zero = (IFMap_to_reg==0);
    register_type_scratchpad #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(PSUM_ADDR_WIDTH),.DEPTH(PSUM_DEPTH))PsumScratchPad
        (.raddr(mode_raddr_PSUM),.waddr(mode_waddr_PSUM),.wen(wen_Psum & !reg_is_zero),.din(Psum),.clk(clk),.rst(rst), .dout(reg_Psum));
    buffer_read_controller_Filter#(.SPAD_ADDR_WIDTH(FILTER_ADDR_WIDTH), .SPAD_DEPTH(FILTER_DEPTH),.FILTER_SIZE_WIDTH(FILTER_SIZE_WIDTH))read_controller_Filter
        (.mode(mode_in),.filter_size(filter_size),.stall(stall),.valid(valid_Filter),.clr_addr(clr_addr),.r_next_Filter(r_next_Filter),.clk(clk),.rst(rst), .valid_end(valid_end_filter),.ren_buf(ren_buf_Filter),.wen_spad(wen_Filter),.spad_waddr(waddr_Filter));
    SRAM_type_scratchpad #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(FILTER_ADDR_WIDTH),.DEPTH(FILTER_DEPTH))FilterScratchPad
        (.chip_en(1'b1),.raddr(raddr_Filter),.waddr(waddr_Filter),.wen(wen_Filter),.ren(!stall),.din(Filter),.clk(clk),.rst(rst), .dout(Filter_pipe));
    
    buffer_write_controller write_controller(.done(done_psum_ctrl),.ready(ready_Psum),.valid(valid_input_Psum),.co_psum(co_psum),.clk(clk),.rst(rst), .ren(ren_buf_input_Psum),.wen(wen_buf_Psum),.stall(stall));

    read_address_generator#(.FILTER_SIZE_WIDTH(FILTER_SIZE_WIDTH),.STRIDE_WIDTH(STRIDE_WIDTH),.IFMAP_ADDR_WIDTH(IFMAP_ADDR_WIDTH),.IFMAP_DEPTH(IFMAP_DEPTH),
        .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH))r_addr_gen(.mode(mode),.stall(stall),.clr_addr(clr_addr),.read_data(read_data),.read_filter(read_filter),.filter_size(filter_size),.stride(stride),
        .raddr_Filter(raddr_Filter),.raddr_IFMap(raddr_IFMap),.start_data(start_data_addr),.end_data(end_data_addr),.end_filters(end_filters),
        .clk(clk),.rst(rst), .at_end_data(at_end_data),.co_pipe(co_pipe),.valid_end(valid_end_data));

    pipeline#(.WIDTH(DATA_WIDTH))pipe(.mode(mode),.Filter(Filter_pipe),.IFMap(IFMap_pipe),.run(run_pipe),.done_psum_in(done_psum_ctrl),.stall(stall),.Psum_in(reg_Psum),.input_Psum(input_Psum),.second_filter_in(second_filter_ctrl),
        .clr_pipe_in(clr_pipe),.clk(clk),.rst(rst), .Psum(Psum),.reg_clr_pipe(reg_clr_pipe),.done_psum(done_psum),.wen_Psum_in(wen_Psum_ctrl),.wen_Psum(wen_Psum),.second_filter(second_filter),.is_zero_in(is_zero),.is_zero(reg_is_zero));

    main_control_unit m_c_u(.Start(Start),.wait_data(wait_data),.at_end_data(at_end_data),.valid_start_addr(valid_start_data),.clr_addr(clr_addr),.mode(mode_in),.wr_psum_in(wr_psum_in),.co_psum(co_psum),.clr_psum_addr(clr_psum_addr),
        .co_pipe(co_pipe),.clk(clk),.rst(rst), .r_next_IF(r_next_IF),.r_next_Filter(r_next_Filter),.run_pipe(run_pipe),.read_data(read_data),.read_filter(read_filter),.clr_pipe(clr_pipe),.done_psum(done_psum_ctrl),.ready(ready),.done(done),
        .done_data(done_data),.wen_Psum(wen_Psum_ctrl),.ld_psum_addr(ld_psum_addr),.ld_params(ld_params),.second_filter(second_filter_ctrl),.double_count_psum(double_count_psum),.sel_psum_addr(sel_psum_addr));
    assign wait_data = ((!valid_end_filter & raddr_Filter == waddr_Filter) | (!valid_end_data & raddr_IFMap == waddr_IFMap)) | !valid_start_data;
endmodule