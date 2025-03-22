module PE_generator#(parameter N_WIDTH,N,GLOBAL_BUFFER_ADDR_WIDTH,GLOBAL_BUFFER_DEPTH,STRIDE_WIDTH,FILTER_SIZE_WIDTH,IFMAP_SIZE_WIDTH,IFMAP_ADDR_WIDTH,IFMAP_DEPTH,PSUM_ADDR_WIDTH
,PSUM_DEPTH,FILTER_ADDR_WIDTH,FILTER_DEPTH,DATA_WIDTH,PSUM_BUF_DEPTH,FILTER_BUF_DEPTH,IFMAP_BUF_DEPTH)(clk,rst,Start,mode,Done,stride,filter_size,ifmap_size);
    input clk,rst,Start;
    input [1:0] mode;
    input [STRIDE_WIDTH-1:0] stride;
    input [FILTER_SIZE_WIDTH-1:0] filter_size;
    input [IFMAP_SIZE_WIDTH-1:0] ifmap_size;
    output Done;

    wire Start_pe,wr_psum_pe;
    wire [N-1:0] ren_Psum,wen_IFMap,wen_Filter,ren_IFMap,valid_IFMap,ready_psum,ren_Filter,valid_Filter,valid_buffer_Psum,wen_Psum,ready,done;
    wire [DATA_WIDTH-1:0] global_buffer_out;
    wire [DATA_WIDTH-1:0] IFMap_out [0:N-1];
    wire [DATA_WIDTH-1:0] Filter_out [0:N-1];
    wire [DATA_WIDTH-1:0] PE_Psum [0:N-1];
    wire [DATA_WIDTH-1:0] buffer_Psum [0:N-1];

    wire wen_global_buffer;
    wire [GLOBAL_BUFFER_ADDR_WIDTH-1:0] raddr_global_buffer,waddr_global_buffer;

    global_buffer#(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(GLOBAL_BUFFER_ADDR_WIDTH),.DEPTH(GLOBAL_BUFFER_DEPTH))gb(
    .raddr(raddr_global_buffer),.waddr(waddr_global_buffer),.wen(wen_global_buffer),.din(buffer_Psum[N-1]),.clk(clk),.rst(rst), .dout(global_buffer_out));

    controller_PE_generator#(.N_WIDTH(N_WIDTH),.N(N),.GLOBAL_BUFFER_ADDR_WIDTH(GLOBAL_BUFFER_ADDR_WIDTH),.GLOBAL_BUFFER_DEPTH(GLOBAL_BUFFER_DEPTH),
    .IFMAP_SIZE_WIDTH(IFMAP_SIZE_WIDTH),.FILTER_SIZE_WIDTH(FILTER_SIZE_WIDTH))ctrl_pe_gen(.Start(Start),.done_in(done[N-1]),.filter_size(filter_size),.mode(mode),
    .ifmap_size(ifmap_size),.valid_psum(valid_buffer_Psum[N-1]),.clk(clk),.rst(rst),.raddr_global_buffer(raddr_global_buffer),
    .waddr_global_buffer(waddr_global_buffer),.Start_pe(Start_pe),.wen_filter(wen_Filter),.wen_global_buffer(wen_global_buffer),.ren_psum(ren_Psum[N-1]),
    .wen_ifmap(wen_IFMap),.done_out(Done),.wr_psum_pe(wr_psum_pe));

    circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(IFMAP_BUF_DEPTH),.BITS(DATA_WIDTH))fifo_IFMap0
    (.clk(clk),.rst(rst),.read_en(ren_IFMap[0]),.write_en(wen_IFMap[0]),.din(global_buffer_out), .valid(valid_IFMap[0]),.ready(),.dout(IFMap_out[0]));

    circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(FILTER_BUF_DEPTH),.BITS(DATA_WIDTH))fifo_Filter0
    (.clk(clk),.rst(rst),.read_en(ren_Filter[0]),.write_en(wen_Filter[0]),.din(global_buffer_out[DATA_WIDTH-1:0]), .valid(valid_Filter[0]),.ready(),.dout(Filter_out[0]));

    Processing_element#(.IFMAP_SIZE_WIDTH(IFMAP_SIZE_WIDTH),.STRIDE_WIDTH(STRIDE_WIDTH),.FILTER_SIZE_WIDTH(FILTER_SIZE_WIDTH),.IFMAP_ADDR_WIDTH(IFMAP_ADDR_WIDTH),.IFMAP_DEPTH(IFMAP_DEPTH),
    .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH),.FILTER_DEPTH(FILTER_DEPTH),.DATA_WIDTH(DATA_WIDTH),.PSUM_ADDR_WIDTH(PSUM_ADDR_WIDTH),.PSUM_DEPTH(PSUM_DEPTH))pe0
    (.clk(clk),.rst(rst),.Start(Start_pe),.IFMap(IFMap_out[0]),.ready(ready[0]),.done(done[0]),.valid_IFMap(valid_IFMap[0]),.Filter(Filter_out[0]),.valid_Filter(valid_Filter[0]),
    .stride_in(stride),.mode_in(mode),.input_Psum({(DATA_WIDTH){1'b0}}),.valid_input_Psum(1'b1),.wr_psum_in(wr_psum_pe),.filter_size_in(filter_size),.ifmap_size_in(ifmap_size),
    .ready_Psum(ready_psum[0]),.Psum(PE_Psum[0]),.ren_buf_Filter(ren_Filter[0]),.ren_buf_IFMap(ren_IFMap[0]),.ren_buf_input_Psum(),.wen_buf_Psum(wen_Psum[0]));

    circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(PSUM_BUF_DEPTH),.BITS(DATA_WIDTH))fifo_Psum0
    (.clk(clk),.rst(rst),.read_en(ren_Psum[0]),.write_en(wen_Psum[0]),.din(PE_Psum[0]), .valid(valid_buffer_Psum[0]),.ready(ready_psum[0]),.dout(buffer_Psum[0]));   

    genvar i;
    generate
        for (i=1; i<N; i=i+1) begin
            circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(IFMAP_BUF_DEPTH),.BITS(DATA_WIDTH))fifo_IFMap
            (.clk(clk),.rst(rst),.read_en(ren_IFMap[i]),.write_en(wen_IFMap[i]),.din(global_buffer_out), .valid(valid_IFMap[i]),.ready(),.dout(IFMap_out[i]));

            circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(FILTER_BUF_DEPTH),.BITS(DATA_WIDTH))fifo_Filter
            (.clk(clk),.rst(rst),.read_en(ren_Filter[i]),.write_en(wen_Filter[i]),.din(global_buffer_out[DATA_WIDTH-1:0]), .valid(valid_Filter[i]),.ready(),.dout(Filter_out[i]));

            Processing_element#(.IFMAP_SIZE_WIDTH(IFMAP_SIZE_WIDTH),.STRIDE_WIDTH(STRIDE_WIDTH),.FILTER_SIZE_WIDTH(FILTER_SIZE_WIDTH),.IFMAP_ADDR_WIDTH(IFMAP_ADDR_WIDTH),.IFMAP_DEPTH(IFMAP_DEPTH),
            .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH),.FILTER_DEPTH(FILTER_DEPTH),.DATA_WIDTH(DATA_WIDTH),.PSUM_ADDR_WIDTH(PSUM_ADDR_WIDTH),.PSUM_DEPTH(PSUM_DEPTH))pe
            (.clk(clk),.rst(rst),.Start(Start_pe),.IFMap(IFMap_out[i]),.ready(ready[i]),.done(done[i]),.valid_IFMap(valid_IFMap[i]),.Filter(Filter_out[i]),.valid_Filter(valid_Filter[i]),
            .stride_in(stride),.mode_in(mode),.input_Psum(buffer_Psum[i-1]),.valid_input_Psum(valid_buffer_Psum[i-1]),.wr_psum_in(wr_psum_pe),.filter_size_in(filter_size),.ifmap_size_in(ifmap_size),
            .ready_Psum(ready_psum[i]),.Psum(PE_Psum[i]),.ren_buf_Filter(ren_Filter[i]),.ren_buf_IFMap(ren_IFMap[i]),.ren_buf_input_Psum(ren_Psum[i-1]),.wen_buf_Psum(wen_Psum[i]));

            circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(PSUM_BUF_DEPTH),.BITS(DATA_WIDTH))fifo_Psum
            (.clk(clk),.rst(rst),.read_en(ren_Psum[i]),.write_en(wen_Psum[i]),.din(PE_Psum[i]), .valid(valid_buffer_Psum[i]),.ready(ready_psum[i]),.dout(buffer_Psum[i]));        
        end
    endgenerate
endmodule