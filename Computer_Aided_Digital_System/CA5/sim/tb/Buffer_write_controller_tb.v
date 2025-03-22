module buffer_write_controller_tb();
    parameter SPAD_ADDR_WIDTH = 2, SPAD_DEPTH = 4,DATA_WIDTH = 3,BUFFER_DEPTH=2;
    reg done=0,ren_buf=0,clk=0,rst=1;
    wire wen_buf,stall,ready,valid;
    circular_buffer#(.PAR_WRITE(1),.PAR_READ(1),.DEPTH(BUFFER_DEPTH),.BITS(DATA_WIDTH))fifo
    (.clk(clk),.rst(rst),.read_en(ren_buf),.write_en(wen_buf),.din({DATA_WIDTH{1'b0}}), .valid(valid),.ready(ready),.dout());
    buffer_write_controller controller(.done(done),.ready(ready),.clk(clk),.rst(rst), .wen(wen_buf),.stall(stall));
    always begin #19;clk=~clk;end
    initial begin
        #19;
        #38; rst=1'b0;
        #38; 
        #38; 
        #38; 
        #38; done=1'b1;
        #38; done=1'b0;
        #38; 
        #38; 
        #38; 
        #38; 
        #38; done=1'b1;
        #38; done=1'b0;
        #38; 
        #38; 
        #38; 
        #38; 
        #38; done=1'b1;
        #38; done=1'b0;
        #38; 
        #38; 
        #38; 
        #38; ren_buf=1;
        #38; ren_buf=0;
        #38; 
        #38; 
        #38; done=1'b1;
        #38; done=1'b0;
        #38; 
        #38; 
        #38; 
        #38; done=1'b1;
        #38; done=1'b0;
        #38; 
        $stop;
    end
endmodule