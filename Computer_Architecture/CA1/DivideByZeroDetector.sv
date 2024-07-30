module dividebyzerodetector(B, dvz);
    input [9:0] B;
    output dvz;
    reg dvz;
    always @(B) begin
        dvz=~|B;
    end
endmodule