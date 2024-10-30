module extend_tb();
    reg [24:0] inst=25'b0000001100100010001001001;
    reg [2:0] src=3'b000;
    wire [31:0] extended;
    extend ext(inst,src, extended);
    initial begin
        #10;
        #38; src=0;
        #38; src=1;
        #38; src=2;
        #38; src=3;
        #38; $stop;
    end
endmodule