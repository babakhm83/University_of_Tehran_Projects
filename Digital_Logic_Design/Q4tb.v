module my_counter_tb_4 ();
    reg aa=0,bb=0,cc=0;
    wire ww00,ww01,ww10,ww11,ww20,ww21;
    my_counter test0(aa,bb,cc,ww00,ww01);
    gate_level_my_counter test1(aa,bb,cc,ww10,ww11);
    assign_my_counter test2(aa,bb,cc,ww20,ww21);
    initial begin
        #100
        aa=0;
        bb=0;
        cc=0;
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