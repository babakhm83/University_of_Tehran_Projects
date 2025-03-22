module SRAM_type_scratchpad#(parameter DATA_WIDTH,ADDR_WIDTH,DEPTH)(chip_en,raddr,waddr,wen,ren,din,clk,rst, dout);
    input [ADDR_WIDTH-1:0] raddr,waddr;
    input chip_en,wen,ren,clk,rst;
    input [DATA_WIDTH-1:0] din;
    output reg [DATA_WIDTH-1:0] dout;
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    integer i=0;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {DATA_WIDTH{1'b0}};
            end
        end
        else if (chip_en) begin
            if (wen)
                mem[waddr] <= din;
            if (ren)
                dout <= mem[raddr];
        end
    end
endmodule