module instruction_memory_tb();
    reg [31:0] A=32'd0,pin=32'd0;
    reg ld=1;
    wire [31:0] RD;
    instruction_memory inst_mem(A,ld,pin, RD);
    initial begin
        #10;
        #38; A=32'd0; pin = 10;
        #38; A=32'd0; pin = -10; ld=0;
        #38; A=32'd4; pin = 20; ld=1;
        #38; A=32'd0; ld=0;
        #38; A=32'd4;
        #38 $stop;
    end
endmodule