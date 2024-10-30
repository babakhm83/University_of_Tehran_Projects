module devidebyzerodetector_tb();
    reg [9:0] B=10'd1;
    wire dvz;
    devidebyzerodetector dvzd(B, dvz);
    initial begin
        #10;
        #10; B=0;
        #10; B=3;
        #10;
        $stop;
    end
endmodule