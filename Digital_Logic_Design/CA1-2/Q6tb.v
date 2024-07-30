module my_counter_tb_6();
    reg [0:6] aa=7'b0;
    wire ww00,ww01,ww02,ww10,ww11,ww12;
    my_counter_7_input test0(aa,ww00,ww01,ww02);
    assign_my_counter_7_input test1(aa,ww10,ww11,ww12);
    initial begin
        #150
        aa[2]=~aa[2];
        aa[3]=~aa[3];
        aa[4]=~aa[4];
        aa[5]=~aa[5];
        #150
        aa[0]=~aa[0];
        aa[1]=~aa[1];
        aa[4]=~aa[4];
        aa[6]=~aa[6];
        #150
        aa[3]=~aa[3];
        aa[5]=~aa[5];
        aa[6]=~aa[6];
        #150
        aa[0]=~aa[0];
        aa[4]=~aa[4];
        #150
        aa[0]=~aa[0];
        aa[5]=~aa[5];
        #150
        aa[0]=~aa[0];
        aa[2]=~aa[2];
        aa[3]=~aa[3];
        aa[5]=~aa[5];
        #150
        aa[1]=~aa[1];
        aa[2]=~aa[2];
        aa[3]=~aa[3];
        aa[5]=~aa[5];
        #150
        aa[0]=~aa[0];
        aa[1]=~aa[1];
        aa[2]=~aa[2];
        aa[3]=~aa[3];
        #150
        aa[0]=~aa[0];
        aa[3]=~aa[3];
        aa[4]=~aa[4];
        aa[5]=~aa[5];
        aa[6]=~aa[6];
        #150
        aa[1]=~aa[1];
        #150
        aa[0]=1;
        aa[1]=1;
        aa[2]=1;
        aa[3]=1;
        aa[4]=1;
        aa[5]=1;
        #150
        $stop;
    end
endmodule