module my_counter_tb_3 ();
    reg aa=0,bb=0,cc=0;
    wire ww00,ww01;
    my_counter test0(aa,bb,cc,ww00,ww01);
    initial begin
        #100
        aa=0;
        bb=0;
        cc=1;
        #100
        aa=0;
        bb=1;
        cc=0;
        #100
        aa=0;
        bb=1;
        cc=1;
        #100
        aa=1;
        bb=0;
        cc=0;
        #100
        aa=1;
        bb=0;
        cc=1;
        #100
        aa=1;
        bb=1;
        cc=0;
        #100
        aa=1;
        bb=1;
        cc=1;
        #100
        aa=0;
        bb=0;
        cc=0;
    end
endmodule