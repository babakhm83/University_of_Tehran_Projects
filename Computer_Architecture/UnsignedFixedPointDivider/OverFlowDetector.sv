module overflowdetector(cnt,Q,ovf);
    input [3:0] cnt;
    input [9:0] Q;
    output ovf;
    reg ovf;
    always @(cnt,Q) begin
        if(cnt==4'd13 & (|Q[9:4])==1)
            ovf=1'b1;
        else
            ovf=1'b0;
    end
endmodule