module my_mealy_ssd(input serIn,detect,clk,rst, output collectvalid);
    reg [2:0] ns,ps=3'b000;
    always@(ps,serIn) begin
        case (ps)
            3'b000: ns=serIn ? 3'b000 : 3'b001;
            3'b001: ns= serIn ? 3'b010 : 3'b001;
            3'b010: ns= serIn ? 3'b011 : 3'b001;
            3'b011: ns= serIn ? 3'b100 : 3'b001;
            3'b100: ns= serIn ? 3'b101 : 3'b001;
            3'b101: ns= serIn ? 3'b110 : 3'b001;
            3'b110: ns= serIn ? 3'b000 : 3'b111;
				3'b111: ns= detect ? 3'b000 : 3'b111;
            default: ns= 3'b000;
        endcase
    end
    assign collectvalid=(ps==3'b110 ? ~serIn : 1'b0);
    always@(posedge clk, posedge rst) begin
        if(rst)
            ps<=3'b000;
        else
            ps<=ns;
    end
endmodule