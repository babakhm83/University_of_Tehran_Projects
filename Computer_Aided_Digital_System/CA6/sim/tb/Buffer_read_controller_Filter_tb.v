module buffer_read_controller_Filter_tb();
    parameter SPAD_ADDR_WIDTH = 2, SPAD_DEPTH = 4,DATA_WIDTH = 3,BUFFER_DEPTH=4;
    reg clk=0,rst=1,start=0,wen_buf=0,clr=1'b1;
    reg [DATA_WIDTH-1:0] buf_in;
    wire [DATA_WIDTH-1:0] buf_out;
    wire ren_buf,wen_spad,ready,valid;
    wire [SPAD_ADDR_WIDTH-1:0] spad_waddr;
    circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(BUFFER_DEPTH),.BITS(DATA_WIDTH))fifo
    (.clk(clk),.rst(rst),.read_en(ren_buf),.write_en(wen_buf),.din(buf_in), .valid(valid),.ready(ready),.dout(buf_out));
    buffer_read_controller_Filter#(.SPAD_ADDR_WIDTH(SPAD_ADDR_WIDTH), .SPAD_DEPTH(SPAD_DEPTH))controller
    (.valid(valid),.stall(1'b0),.init(start),.valid_end(),.clk(clk),.rst(rst), .ren_buf(ren_buf),.wen_spad(wen_spad),.spad_waddr(spad_waddr));
    SRAM_type_scratchpad#(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(SPAD_ADDR_WIDTH),.DEPTH(SPAD_DEPTH))spad
    (.chip_en(1'b1),.raddr(),.waddr(spad_waddr),.wen(wen_spad),.ren(1'b0),.din(buf_out[DATA_WIDTH-1:0]),.clk(clk),.rst(rst), .dout());
    always begin #19;clk=~clk;end
    initial begin
        #19;
        #38; rst=1'b0; clr=1'b0;
        #38; start = 1'b1;
        #38; start = 1'b0;
        #38; wen_buf = 1'b1; buf_in = 3'd1;
        #38; buf_in = 3'd2;
        #38; buf_in = 3'd3;
        #38; buf_in = 3'd4;
        #38; wen_buf = 1'b0;
        #380; 
        $stop;
    end
endmodule
