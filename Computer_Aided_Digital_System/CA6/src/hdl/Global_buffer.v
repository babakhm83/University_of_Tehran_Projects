module global_buffer#(parameter DATA_WIDTH,ADDR_WIDTH,DEPTH)(raddr,waddr,wen,din,clk,rst, dout);
    input [ADDR_WIDTH-1:0] raddr,waddr;
    input wen,clk,rst;
    input [DATA_WIDTH-1:0] din;
    output [DATA_WIDTH-1:0] dout;
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    integer file, i, value;

    assign dout = mem[raddr];
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] = 0;
            $readmemh("mode3.txt", mem);
        end
        else begin
            if (wen)
                mem[waddr] <= din;
        end
    end
endmodule