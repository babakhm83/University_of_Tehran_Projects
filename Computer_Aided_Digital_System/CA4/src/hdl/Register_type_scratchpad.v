module register_type_scratchpad#(parameter DATA_WIDTH,ADDR_WIDTH,DEPTH)(raddr,waddr,wen,din,clk,rst, dout);
input wen,clk,rst;
input [ADDR_WIDTH-1:0] raddr,waddr;
    input [DATA_WIDTH-1:0] din;
    output [DATA_WIDTH-1:0] dout;
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    assign dout = mem[raddr];
    integer i=0;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {DATA_WIDTH{1'b0}};
            end
        end
        else if (wen) begin
            mem[waddr] <= din;
        end
    end
endmodule