module read_address_generator_tb();
    parameter FILTER_SIZE_WIDTH = 3, STRIDE_WIDTH = 2,IFMAP_ADDR_WIDTH = 4,IFMAP_DEPTH = 16,FILTER_ADDR_WIDTH=5;
    reg clk=0,rst=1,read_data=0,clr=1'b1;
    reg [FILTER_SIZE_WIDTH-1:0] filter_size=4;
    reg [STRIDE_WIDTH-1:0] stride=3;
    reg [IFMAP_ADDR_WIDTH-1:0] start_data=2,end_data=14;
    reg [FILTER_ADDR_WIDTH-1:0] end_filters=23;
    wire [FILTER_ADDR_WIDTH-1:0] raddr_Filter;
    wire [IFMAP_ADDR_WIDTH-1:0] raddr_IFMap;
    wire at_end_data;
    read_address_generator#(.FILTER_SIZE_WIDTH(FILTER_SIZE_WIDTH),.STRIDE_WIDTH(STRIDE_WIDTH),.IFMAP_ADDR_WIDTH(IFMAP_ADDR_WIDTH),.IFMAP_DEPTH(IFMAP_DEPTH)
    ,.FILTER_ADDR_WIDTH(FILTER_ADDR_WIDTH))rag(.stall(1'b0),.clr_addr(1'b0),.read_data(read_data),.filter_size(filter_size),.stride(stride),
    .raddr_Filter(raddr_Filter),.raddr_IFMap(raddr_IFMap),.at_end_data(at_end_data),.co_pipe(),.start_data(start_data),.end_data(end_data),.end_filters(end_filters),.valid_end(1'b1),
    .clk(clk),.rst(rst));
    always begin #19;clk=~clk;end
    initial begin
        #19;
        #38;rst=1'b0;clr=1'b0;
        #38;
        #38;read_data=1;
        #3800;
        $stop;
    end
endmodule