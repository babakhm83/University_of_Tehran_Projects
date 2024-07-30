module gate_level_my_counter(input a,b,c, output y0,y1);
    supply1 vdd;
    supply0 gnd;
    wire gw00,gw01,gw02,gw03;
    nand #(10,8) g00(gw00,~a,~c),
    g01(gw01,a,c),g02(gw02,gw00,gw01),(gw03,gw02,b);

    wire gw10,gw11,gw12,gw13;
    nand #(10,8) g10(gw10,a,~c),
    g11(gw11,~a,c),g12(gw12,gw10,gw11),(gw13,gw12,~b);

    nand #(10,8) g2(y0,gw03,gw13);

    wire gw20,gw21,gw22;
    nand #(10,8) g20(gw20,~a,~b),
    g21(gw21,gw20,c),g22(gw22,a,b),gw23(y1,gw22,gw21);
endmodule