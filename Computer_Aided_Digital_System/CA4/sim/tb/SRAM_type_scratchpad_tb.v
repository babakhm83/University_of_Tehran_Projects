module sram_type_scratchpad_tb();
    parameter DATA_WIDTH=3,ADDR_WIDTH=4,DEPTH=10;
    reg clk=0,rst=1,wen=0,ren=0,chip_en=1;
    reg [ADDR_WIDTH-1:0] waddr=0,raddr=0;
    reg [DATA_WIDTH-1:0] din=0;
    wire [DATA_WIDTH-1:0] dout;
    SRAM_type_scratchpad #(DATA_WIDTH,ADDR_WIDTH,DEPTH)sram(chip_en,raddr,waddr,wen,ren,din,clk,rst, dout);
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; rst=1'b0;
        #38; din={10'd3}; waddr=5;raddr=5; ren =1;
        #38; 
        #38; wen=1'b1;
        #38; 
        #38; din={10'd4}; waddr=7;raddr=5;ren=0;
        #38; raddr=7;
        #38; din={10'd5}; waddr=8;raddr=5; ren=1;
        #38;
        #38;
        $stop;
    end
endmodule