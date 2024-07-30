module my_counter_7_input(input [0:6] a, output y0,y1,y2);
    wire [0:3] ww0;
    wire ww1;
    my_counter oc00(a[0],a[1],a[2],ww0[0],ww0[1]);
    my_counter oc01(a[3],a[4],a[5],ww0[2],ww0[3]);
    my_counter oc10(ww0[0],ww0[2],a[6],y0,ww1);
    my_counter oc14(ww0[1],ww0[3],ww1, y1, y2);
endmodule