module buffer#(parameter PAR_WRITE=1,PAR_READ=1,DEPTH=8,BITS=16,INDEX=3)(clk,wen,din,waddr,raddr, dout);
    input clk,wen;
    input [INDEX-1:0] waddr,raddr;
    input [BITS*PAR_WRITE-1:0] din;
    output reg [BITS*PAR_READ-1:0] dout;
    reg [BITS-1:0] x [0:DEPTH-1];
    integer i=0,j=0,k=0;
    initial begin
        for (i=0; i<DEPTH; i=i+1) begin
            x[i]<=0;
        end
    end
    always @(*) begin
        for (j = 0; j < PAR_READ; j = j + 1) begin
            if((raddr + j)>=DEPTH)
                dout[j*BITS +: BITS] <= x[(raddr + j) - (DEPTH)];
            else
                dout[j*BITS +: BITS] <= x[(raddr + j)];
        end
    end
    always @(posedge clk) begin
        if (wen) begin
            for (k = 0; k < PAR_WRITE; k = k + 1) begin
                if((waddr + PAR_WRITE-k-1)>=DEPTH)
                    x[(waddr + PAR_WRITE-k-1) - (DEPTH)] <= din[k*BITS +: BITS];
                else
                    x[(waddr + PAR_WRITE-k-1)] <= din[k*BITS +: BITS];
            end
        end
    end
endmodule