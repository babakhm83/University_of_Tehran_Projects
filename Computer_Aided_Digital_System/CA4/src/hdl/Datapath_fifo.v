module datapath_circular_buffer#(parameter PAR_WRITE=1,parameter PAR_READ=1,parameter DEPTH=8,parameter BITS=16)(clk,rst,din,cnt_w,cnt_r,wen, 
dout,full,empty);
    input clk,rst,cnt_w,cnt_r,wen;
    input [BITS*PAR_WRITE-1:0] din;
    output full,empty;
    output [BITS*PAR_READ-1:0] dout;
    parameter INDEX = $clog2(DEPTH);
    wire [INDEX:0]wr_ptr,r_ptr,wptr_plus_1,par_read,par_write,depth;
    assign par_read=PAR_READ;
    assign par_write=PAR_WRITE;
    assign depth=DEPTH;
    assign wptr_plus_1=wr_ptr+1;
    assign full  = (wr_ptr+1)%(DEPTH+1)==r_ptr;
    assign empty = (wr_ptr == r_ptr);
    buffer #(.PAR_WRITE(PAR_WRITE),.PAR_READ(PAR_READ),.DEPTH(DEPTH+1),.BITS(BITS),.INDEX(INDEX+1)) b 
    (.clk(clk),.wen(wen),.din(din),.waddr(wr_ptr),.raddr(r_ptr), .dout(dout));
    counter_circular_buffer #(.BITS(INDEX),.PAR(PAR_WRITE)) c_w (.cnt(cnt_w),.clk(clk),.rst(rst), .pout(wr_ptr));
    counter_circular_buffer #(.BITS(INDEX),.PAR(PAR_READ)) c_r (.cnt(cnt_r),.clk(clk),.rst(rst), .pout(r_ptr));
endmodule