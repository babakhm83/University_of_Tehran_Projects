module Processing_element_tb_mine();
    parameter STRIDE_WIDTH=2,FILTER_SIZE_WIDTH=3,IFMAP_ADDR_WIDTH=5,IFMAP_DEPTH=10,FILTER_ADDR_WIDTH=4,
    FILTER_DEPTH=10,DATA_WIDTH=10,IFMAP_BUF_DEPTH=30,PSUM_BUF_DEPTH=11,FILTER_BUF_DEPTH=30;
    reg clk=0,rst=1,Start=0,wen_IFMap=0,wen_Filter=0,ren_Psum=0;
    reg [STRIDE_WIDTH-1:0] stride=2;
    reg [FILTER_SIZE_WIDTH-1:0] filter_size=4;
    reg [DATA_WIDTH+1:0] IFMap_in={DATA_WIDTH{1'b0}};
    wire [DATA_WIDTH+1:0] IFMap_out;
    wire ren_IFMap,ready_IFMap,valid_IFMap,ready_psum;
    reg [DATA_WIDTH-1:0] Filter_in={DATA_WIDTH{1'b0}};
    wire [DATA_WIDTH-1:0] Filter_out,Psum;
    wire ren_Filter,ready_Filter,valid_Filter,wen_Psum;

    circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(IFMAP_BUF_DEPTH),.BITS(DATA_WIDTH+2))fifo_IFMap
    (.clk(clk),.rst(rst),.read_en(ren_IFMap),.write_en(wen_IFMap),.din(IFMap_in), .valid(valid_IFMap),.ready(ready_IFMap),.dout(IFMap_out));

    circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(FILTER_BUF_DEPTH),.BITS(DATA_WIDTH))fifo_Filter
    (.clk(clk),.rst(rst),.read_en(ren_Filter),.write_en(wen_Filter),.din(Filter_in), .valid(valid_Filter),.ready(ready_Filter),.dout(Filter_out));

    Processing_element#(.STRIDE_WIDTH(STRIDE_WIDTH),.FILTER_SIZE_WIDTH(FILTER_SIZE_WIDTH),.IFMAP_ADDR_WIDTH(IFMAP_ADDR_WIDTH),.IFMAP_DEPTH(IFMAP_DEPTH),
    .FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH),.FILTER_DEPTH(FILTER_DEPTH),.DATA_WIDTH(DATA_WIDTH))pe
    (.clk(clk),.rst(rst),.Start(Start),.IFMap(IFMap_out),.valid_IFMap(valid_IFMap),.Filter(Filter_out),.valid_Filter(valid_Filter),.stride_in(stride),
    .filter_size_in(filter_size),.ready_Psum(ready_psum), .Psum(Psum),.ren_buf_Filter(ren_Filter),.ren_buf_IFMap(ren_IFMap),.wen_buf_Psum(wen_Psum));

    circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(PSUM_BUF_DEPTH),.BITS(DATA_WIDTH))fifo_Psum
    (.clk(clk),.rst(rst),.read_en(ren_Psum),.write_en(wen_Psum),.din(Psum), .valid(),.ready(ready_psum),.dout());

    always begin #19;clk=~clk;end
    initial begin
        #38;
        #38; rst=1'b0;
        #38; IFMap_in = {2'b10,10'd1};Filter_in = {10'd0};wen_IFMap = 1'b1;wen_Filter = 1'b1;
        #38; IFMap_in = {2'b00,10'd2};Filter_in = {10'd7};
        #38; IFMap_in = {2'b00,10'd3};Filter_in = {10'd6};
        #38; IFMap_in = {2'b00,10'd4};Filter_in = {10'd5};
        #38; IFMap_in = {2'b00,10'd3};Filter_in = {10'd4};
        #38; IFMap_in = {2'b00,10'd2};Filter_in = {10'd3};
        #38; IFMap_in = {2'b00,10'd1};Filter_in = {10'd2};
        #38; IFMap_in = {2'b01,10'd0};Filter_in = {10'd2};
        #38; IFMap_in = {2'b10,10'd1};Filter_in = {10'd1};
        #38; IFMap_in = {2'b00,10'd2};Filter_in = {10'd2};
        #38; IFMap_in = {2'b00,10'd3};Filter_in = {10'd3};
        #38; wen_IFMap = 1'b0;wen_Filter = 1'b0;
        #38; Start = 1'b1;
        #38; Start = 1'b0;
        #3800;
        #38; IFMap_in = {2'b00,10'd4};Filter_in = {10'd5};wen_IFMap = 1'b1;wen_Filter = 1'b1;
        #38; IFMap_in = {2'b01,10'd6};Filter_in = {10'd6};
        #38; wen_IFMap = 1'b0;wen_Filter = 1'b0;
        #380;
        #38; IFMap_in = {2'b10,10'd1};wen_IFMap = 1'b1;
        #38; IFMap_in = {2'b00,10'd2};
        #38; IFMap_in = {2'b00,10'd2};
        #38; IFMap_in = {2'b01,10'd2};
        #38; wen_IFMap = 1'b0;
        #1140;
        #38; IFMap_in = {2'b10,10'd1};wen_IFMap = 1'b1;
        #38; IFMap_in = {2'b00,10'd2};
        #38; IFMap_in = {2'b00,10'd3};
        #38; IFMap_in = {2'b00,10'd4};
        #38; IFMap_in = {2'b00,10'd3};
        #38; IFMap_in = {2'b00,10'd2};
        #38; IFMap_in = {2'b00,10'd1};
        #38; IFMap_in = {2'b01,10'd0};
        #38; IFMap_in = {2'b10,10'd1};
        #38; IFMap_in = {2'b00,10'd2};
        #38; IFMap_in = {2'b00,10'd3};
        #38; wen_IFMap = 1'b0;
        #380; ren_Psum=1;
        #3800;
        $stop;
    end
endmodule