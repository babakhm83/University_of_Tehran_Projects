module Processing_element_tb1_2();
    parameter STRIDE_WIDTH=2,FILTER_SIZE_WIDTH=3,IFMAP_ADDR_WIDTH=5,IFMAP_DEPTH=10,FILTER_ADDR_WIDTH=4,
    FILTER_DEPTH=10,DATA_WIDTH=16,IFMAP_BUF_DEPTH=60,PSUM_BUF_DEPTH=60,FILTER_BUF_DEPTH=60,PSUM_ADDR_WIDTH=5,PSUM_DEPTH=20,INPUT_PSUM_BUF_DEPTH=60;
    reg clk=0,rst=1,Start=0,wen_IFMap=0,wen_Filter=0,wen_input_Psum=0,ren_Psum=0,wr_psum=0;
    reg [1:0] mode=1;
    reg [STRIDE_WIDTH-1:0] stride=1;
    reg [FILTER_SIZE_WIDTH-1:0] filter_size=5;
    reg [DATA_WIDTH+1:0] IFMap_in={DATA_WIDTH{1'b0}};
    wire [DATA_WIDTH+1:0] IFMap_out;
    wire ren_IFMap,ren_input_Psum,ready_IFMap,valid_IFMap,ready_psum;
    reg [DATA_WIDTH-1:0] Filter_in={DATA_WIDTH{1'b0}},input_Psum_in={DATA_WIDTH{1'b0}};
    wire [DATA_WIDTH-1:0] Filter_out,Psum,input_Psum;
    wire ren_Filter,ready_Filter,valid_Filter,valid_input_Psum,ready_input_Psum,wen_Psum,ready,done;

    circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(IFMAP_BUF_DEPTH),.BITS(DATA_WIDTH+2))fifo_IFMap
    (.clk(clk),.rst(rst),.read_en(ren_IFMap),.write_en(wen_IFMap),.din(IFMap_in), .valid(valid_IFMap),.ready(ready_IFMap),.dout(IFMap_out));

    circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(FILTER_BUF_DEPTH),.BITS(DATA_WIDTH))fifo_Filter
    (.clk(clk),.rst(rst),.read_en(ren_Filter),.write_en(wen_Filter),.din(Filter_in), .valid(valid_Filter),.ready(ready_Filter),.dout(Filter_out));

    circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(INPUT_PSUM_BUF_DEPTH),.BITS(DATA_WIDTH))input_Psum_buf
    (.clk(clk),.rst(rst),.read_en(ren_input_Psum),.write_en(wen_input_Psum),.din(input_Psum_in), .valid(valid_input_Psum),.ready(ready_input_Psum),.dout(input_Psum));

    Processing_element#(.STRIDE_WIDTH(STRIDE_WIDTH),.FILTER_SIZE_WIDTH(FILTER_SIZE_WIDTH),.IFMAP_ADDR_WIDTH(IFMAP_ADDR_WIDTH),.IFMAP_DEPTH(IFMAP_DEPTH),
    .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH),.FILTER_DEPTH(FILTER_DEPTH),.DATA_WIDTH(DATA_WIDTH),.PSUM_ADDR_WIDTH(PSUM_ADDR_WIDTH),.PSUM_DEPTH(PSUM_DEPTH))pe
    (.clk(clk),.rst(rst),.Start(Start),.IFMap(IFMap_out),.ready(ready),.done(done),.valid_IFMap(valid_IFMap),.Filter(Filter_out),.valid_Filter(valid_Filter),.stride_in(stride),.mode_in(mode),.input_Psum(input_Psum),.valid_input_Psum(valid_input_Psum),
    .wr_psum_in(wr_psum),.filter_size_in(filter_size),.ready_Psum(ready_psum), .Psum(Psum),.ren_buf_Filter(ren_Filter),.ren_buf_IFMap(ren_IFMap),.ren_buf_input_Psum(ren_input_Psum),.wen_buf_Psum(wen_Psum));

    circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(PSUM_BUF_DEPTH),.BITS(DATA_WIDTH))fifo_Psum
    (.clk(clk),.rst(rst),.read_en(ren_Psum),.write_en(wen_Psum),.din(Psum), .valid(),.ready(ready_psum),.dout());

    always begin #19;clk=~clk;end
    initial begin
        #38;
        #38; rst=1'b0;
        #38; IFMap_in = {2'b10,-16'd191};Filter_in = {-16'd72};input_Psum_in = {16'd0};wen_IFMap = 1'b1;wen_Filter = 1'b1;wen_input_Psum = 1'b0;
        #38; IFMap_in = {2'b00,-16'd145};Filter_in = {16'd167};input_Psum_in = {16'd0};
        #38; IFMap_in = {2'b00,16'd12};Filter_in = {-16'd124};input_Psum_in = {16'd0};
        #38; IFMap_in = {2'b00,-16'd98};Filter_in = {16'd99};input_Psum_in = {16'd0};
        #38; IFMap_in = {2'b00,16'd190};Filter_in = {-16'd166};input_Psum_in = {16'd0};
        #38; IFMap_in = {2'b01,16'd163};Filter_in = {-16'd80};input_Psum_in = {16'd0};wen_Filter = 1'b0;
        #38; IFMap_in = {2'b10,16'd170};Filter_in = {16'd122};input_Psum_in = {16'd0};
        #38; IFMap_in = {2'b00,-16'd74};Filter_in = {16'd9};input_Psum_in = {16'd0};
        #38; IFMap_in = {2'b00,-16'd97};Filter_in = {16'd155};input_Psum_in = {16'd0};
        #38; IFMap_in = {2'b00,-16'd89};Filter_in = {-16'd51};input_Psum_in = {16'd0};
        #38; IFMap_in = {2'b00,-16'd33};Filter_in = {-16'd26};input_Psum_in = {16'd0};
        #38; IFMap_in = {2'b01,-16'd77};Filter_in = {16'd147};input_Psum_in = {16'd0};
        #38; wen_IFMap = 1'b0;wen_Filter = 1'b0;wen_input_Psum = 1'b0;
        #38; Start = 1'b1;
        #38; Start = 1'b0;
        #3800;
        $stop;
    end
endmodule