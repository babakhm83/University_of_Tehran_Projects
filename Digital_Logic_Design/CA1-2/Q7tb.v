module my_counter_tb_7();
    reg [0:14] aa=15'b0;
    wire ww00,ww01,ww02,ww03;
    my_counter_15_input test0(aa,ww00,ww01,ww02,ww03);
    initial begin
	#200
        aa[0]=1;
	#200
	aa[1]=1;
	#200
        aa[2]=1;
	#200
	aa[3]=1;
	#200
        aa[4]=1;
	#200
	aa[5]=1;
	#200
        aa[6]=1;
	#200
	aa[7]=1;
        #200
        aa[8]=1;
	#200
	aa[9]=1;
	#200
        aa[10]=1;
	#200
	aa[11]=1;
	#200
        aa[12]=1;
	#200
	aa[13]=1;
	#200
        aa[14]=1;
        #200
        $stop;
    end
endmodule