module Processing_element_tb1();
    parameter STRIDE_WIDTH=3,FILTER_SIZE_WIDTH=3,IFMAP_ADDR_WIDTH=4,IFMAP_DEPTH=12,FILTER_ADDR_WIDTH=4,
    FILTER_DEPTH=16,DATA_WIDTH=16,IFMAP_BUF_DEPTH=30,PSUM_BUF_DEPTH=30,FILTER_BUF_DEPTH=30;
    
    reg clk=0,rst=1,Start=0,wen_IFMap=0,wen_Filter=0,ren_Psum=0;
    reg [STRIDE_WIDTH-1:0] stride=4;
    reg [FILTER_SIZE_WIDTH-1:0] filter_size=4;
    reg [DATA_WIDTH+1:0] IFMap_in={DATA_WIDTH{1'b0}};
    reg [DATA_WIDTH-1:0] Filter_in={DATA_WIDTH{1'b0}};

    wire [DATA_WIDTH+1:0] IFMap_out;
    wire ren_IFMap,ready_IFMap,valid_IFMap,ready_psum;
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
        #228; IFMap_in = {18'b101111111111011111};wen_IFMap = 1'b1;
        #38; IFMap_in = {18'b000000000000100000};
        #38;wen_IFMap = 1'b0;#1900;
        #38; IFMap_in = {18'b001111111111100111};wen_IFMap = 1'b1;
        #38; IFMap_in = {18'b001111111111011000};
        #38; IFMap_in = {18'b001111111111101001};
        #38; IFMap_in = {18'b000000000000111110};
        #38; IFMap_in = {18'b001111111111100000};
        #38; IFMap_in = {18'b010000000000100011};
        #38; IFMap_in = {18'b100000000000000101};
        #38;wen_IFMap = 1'b0;#1900;
        #38; IFMap_in = {18'b001111111111101110};wen_IFMap = 1'b1;
        #38; IFMap_in = {18'b000000000000100000};
        #38; IFMap_in = {18'b001111111111010000};
        #38; IFMap_in = {18'b001111111111001100};
        #38; IFMap_in = {18'b001111111111001111};
        #38; IFMap_in = {18'b001111111111101111};
        #38; IFMap_in = {18'b011111111111001111};
        #38;wen_IFMap = 1'b0;
    end
    initial begin
        #228; Filter_in = {18'b1111111111001001};wen_Filter = 1'b1;
        #38; Filter_in = {18'b0000000000001001};
        #38; Filter_in = {18'b1111111111100100};
        #38; Filter_in = {18'b0000000000110110};
        #38; Filter_in = {18'b0000000000011110};
        #38;wen_Filter = 1'b0;#1900;
        #38; Filter_in = {18'b1111111111011000};wen_Filter = 1'b1;
        #38; Filter_in = {18'b0000000000110100};
        #38;wen_Filter = 1'b0;#1900;
        #38; Filter_in = {18'b0000000000111111};wen_Filter = 1'b1;
        #38; Filter_in = {18'b1111111111000100};
        #38; Filter_in = {18'b0000000000101110};
        #38; Filter_in = {18'b0000000000011111};
        #38; Filter_in = {18'b0000000000101111};
        #38; Filter_in = {18'b0000000000100100};
        #38; Filter_in = {18'b1111111111101101};
        #38; Filter_in = {18'b1111111111001110};
        #38; Filter_in = {18'b1111111111011011};
        #38;wen_Filter = 1'b0;
    end
    initial begin
        #38;
        #38; rst=1'b0;
        #38; Start = 1'b1;
        #38; Start = 1'b0;
        #380000;
        $stop;
    end
endmodule