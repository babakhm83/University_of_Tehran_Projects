module output_ram_tb();
    reg clk=0,rst=1;
    reg [4:0] i=4'b0;
    reg [31:0] pi=32'b0;
    output_ram #(.r(8),.n(32))ram(.clk(clk),.rst(rst),.i(i), .pi(pi));
    always begin #19;clk=~clk; end
    initial begin
        #38;
        #10; rst=1'b0;
        #38;
        #38; i=3'd1;pi=32'd10;
        #38; i=3'd2;pi=32'd2;
        #38; i=3'd3;pi=32'd4;
        #38;
        $stop;
    end
endmodule