module divider_tb();
    reg start=0,sclr=1,clk=0;
    reg [9:0] a_in=10'b1000100010,b_in=10'b0000000010;
    wire dvz,ovf,busy,valid;
    wire [9:0] q_out;
    divider divide(a_in,b_in,start,sclr,clk, q_out,dvz,ovf,busy,valid);
    always begin #19;clk=~clk;end
    initial begin
        #38;
        #10; sclr=1'b0;
        #38; start=1;
        #38; start=0;
        repeat(100)
        #38;
        a_in=10'b0000011000; b_in=10'b1100000011;
        #38; start=1;
        #38; start=0;
        repeat(100)
        #38;
        a_in=10'd256; b_in=10'd2;
        #38; start=1;
        #38; start=0;
        repeat(100)
        #38;
        a_in=10'd75; b_in=10'd11;
        #38; start=1;
        #38; start=0;
        repeat(100)
            #38;
        a_in=10'd25; b_in=10'd5;
        #38; start=1;
        #38; start=0;
        repeat(100)
            #38;
        a_in=10'd57; b_in=10'd0;
        #38; start=1;
        #38; start=0;
        repeat(100)
            #38;
        $stop;
    end
endmodule