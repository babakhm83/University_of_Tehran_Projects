module my_counter_15_input(input [0:14]a, output y0,y1,y2,y3);
    wire [0:5] ww0;
    wire ww1[0:1];
    my_counter_7_input oc00(a[0:6],ww0[0],ww0[1],ww0[2]);
    my_counter_7_input oc01(a[7:13],ww0[3],ww0[4],ww0[5]);
    my_counter oc10(ww0[0],ww0[3],a[14],y0,ww1[0]);
    my_counter oc11(ww0[1],ww0[4],ww1[0],y1,ww1[1]);
    my_counter oc12(ww0[2],ww0[5],ww1[1],y2,y3);
endmodule