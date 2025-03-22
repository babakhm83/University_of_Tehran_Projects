module Processing_element#(parameter STRIDE_WIDTH,FILTER_SIZE_WIDTH,IFMAP_ADDR_WIDTH,IFMAP_DEPTH,FILTER_ADDR_WIDTH,FILTER_DEPTH,DATA_WIDTH)
(clk,rst,Start,IFMap,valid_IFMap,Filter,valid_Filter,stride_in,filter_size_in,ready_Psum, Psum,ren_buf_Filter,ren_buf_IFMap,wen_buf_Psum);

    input clk,rst,Start,valid_IFMap,valid_Filter,ready_Psum;
    input [DATA_WIDTH+1:0] IFMap;
    input [DATA_WIDTH-1:0] Filter;
    input [STRIDE_WIDTH-1:0]stride_in;
    input [FILTER_SIZE_WIDTH-1:0]filter_size_in;
    output ren_buf_Filter,ren_buf_IFMap,wen_buf_Psum;
    output [DATA_WIDTH-1:0] Psum;

    wire wen_Filter,wen_IFMap,init,done_psum_ctrl,done_psum,done_data,stall,at_end_data,co_pipe,run_pipe,
    read_spad,wait_data,valid_start_data,valid_end_data,valid_end_filter,clr_pipe,clr_addr;
    wire [STRIDE_WIDTH-1:0]stride;
    wire [FILTER_SIZE_WIDTH-1:0]filter_size;
    wire [DATA_WIDTH-1:0] Filter_pipe,IFMap_to_reg,IFMap_pipe;
    wire [IFMAP_ADDR_WIDTH-1:0] raddr_IFMap,waddr_IFMap,start_data_addr,end_data_addr;
    wire [FILTER_ADDR_WIDTH-1:0] raddr_Filter,waddr_Filter,end_filters;
    assign end_filters = (FILTER_DEPTH / filter_size) * filter_size - 1;

    register #(.WIDTH(STRIDE_WIDTH))stride_reg(.pin(stride_in),.ld(init),.stall(stall),.clk(clk),.rst(rst), .pout(stride));
    register #(.WIDTH(FILTER_SIZE_WIDTH))filter_size_reg(.pin(filter_size_in),.ld(init),.stall(stall),.clk(clk),.rst(rst), .pout(filter_size));

    buffer_read_controller_IFMap#(.SPAD_ADDR_WIDTH(IFMAP_ADDR_WIDTH), .SPAD_DEPTH(IFMAP_DEPTH))read_controller_IFMap
        (.valid(valid_IFMap),.start_row(IFMap[DATA_WIDTH+1]),.end_row(IFMap[DATA_WIDTH]),.done(done_data),.spad_raddr(raddr_IFMap),
        .clr_addr(clr_addr),.init(init),.stall(stall),.clk(clk),.rst(rst), .valid_start(valid_start_data),.valid_end(valid_end_data),
        .ren_buf(ren_buf_IFMap),.wen_spad(wen_IFMap),.spad_waddr(waddr_IFMap),.end_data(end_data_addr),.start_data(start_data_addr));    
    register_type_scratchpad #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(IFMAP_ADDR_WIDTH),.DEPTH(IFMAP_DEPTH))IFMapScratchPad
        (.raddr(raddr_IFMap),.waddr(waddr_IFMap),.wen(wen_IFMap),.din(IFMap[DATA_WIDTH-1:0]),.clk(clk),.rst(rst), .dout(IFMap_to_reg));
    register #(.WIDTH(DATA_WIDTH))reg_IFMap(.pin(IFMap_to_reg),.ld(read_spad),.stall(stall),.clk(clk),.rst(rst), .pout(IFMap_pipe));

    buffer_read_controller_Filter#(.SPAD_ADDR_WIDTH(FILTER_ADDR_WIDTH), .SPAD_DEPTH(FILTER_DEPTH))read_controller_Filter
        (.stall(stall),.valid(valid_Filter),.init(init),.clk(clk),.rst(rst), .valid_end(valid_end_filter),.ren_buf(ren_buf_Filter),.wen_spad(wen_Filter),.spad_waddr(waddr_Filter));
    SRAM_type_scratchpad #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(FILTER_ADDR_WIDTH),.DEPTH(FILTER_DEPTH))FilterScratchPad
        (.chip_en(1'b1),.raddr(raddr_Filter),.waddr(waddr_Filter),.wen(wen_Filter),.ren(!stall),.din(Filter),.clk(clk),.rst(rst), .dout(Filter_pipe));

    buffer_write_controller write_controller(.done(done_psum),.ready(ready_Psum),.clk(clk),.rst(rst), .wen(wen_buf_Psum),.stall(stall));

    read_address_generator#(.FILTER_SIZE_WIDTH(FILTER_SIZE_WIDTH),.STRIDE_WIDTH(STRIDE_WIDTH),.IFMAP_ADDR_WIDTH(IFMAP_ADDR_WIDTH),.IFMAP_DEPTH(IFMAP_DEPTH),
        .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH))r_addr_gen(.stall(stall),.clr_addr(clr_addr),.read_data(read_spad),.filter_size(filter_size),.stride(stride),
        .raddr_Filter(raddr_Filter),.raddr_IFMap(raddr_IFMap),.start_data(start_data_addr),.end_data(end_data_addr),.end_filters(end_filters),
        .clk(clk),.rst(rst), .at_end_data(at_end_data),.co_pipe(co_pipe),.valid_end(valid_end_data));

    pipeline#(.WIDTH(DATA_WIDTH))pipe(.Filter(Filter_pipe),.IFMap(IFMap_pipe),.run(run_pipe),.done_psum_in(done_psum_ctrl),.stall(stall),
        .clr_pipe_in(clr_pipe),.clk(clk),.rst(rst), .Psum(Psum),.done_psum(done_psum));

    main_control_unit m_c_u(.Start(Start),.wait_data(wait_data),.at_end_data(at_end_data),.valid_start_addr(valid_start_data),.clr_addr(clr_addr),
        .co_pipe(co_pipe),.clk(clk),.rst(rst), .init(init),.run_pipe(run_pipe),.read_spad(read_spad),.clr_pipe(clr_pipe),.done_psum(done_psum_ctrl),.done_data(done_data));
    assign wait_data = ((!valid_end_filter & raddr_Filter == waddr_Filter) | (!valid_end_data & raddr_IFMap == waddr_IFMap)) | !valid_start_data;
endmodule