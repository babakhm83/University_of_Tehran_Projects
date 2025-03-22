module circular_buffer#(parameter PAR_WRITE=1,parameter PAR_READ=1,parameter DEPTH=8,parameter BITS=16)(clk,rst,read_en,write_en,din, 
valid,ready,dout);
    input clk,rst,read_en,write_en;
    input [BITS*PAR_WRITE-1:0] din;
    output valid,ready;
    output [BITS*PAR_READ-1:0] dout;
    wire cnt_w,cnt_r,wen,full,empty;
    datapath_circular_buffer#(PAR_WRITE,PAR_READ,DEPTH,BITS)dp(clk,rst,din,cnt_w,cnt_r,wen, dout,full,empty);
    controller_circular_buffer c(read_en,write_en,full,empty, valid,ready,cnt_w,cnt_r,wen);
endmodule