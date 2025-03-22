module input_ram_tb();
    reg [2:0] i=3'b0;
    wire [15:0] po1,po2;
    input_ram #(.r(16),.n(16))ram(.i(i), .po1(po1),.po2(po2));
    initial begin
        #38;
        #10;
        #38;
        #38; i=3'd1;
        #38; i=3'd2;
        #38;
        #38;
        $stop;
    end
endmodule