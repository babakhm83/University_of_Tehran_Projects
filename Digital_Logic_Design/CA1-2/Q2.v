module my_counter(input a,b,c, output y0,y1);
    supply1 vdd;
    supply0 gnd;
    wire w000,w001,w002;
    wire w010,w011,w012;
    wire w020,w021;
    wire w030;

    nmos #(3,4,5) n020(w021,gnd,b)
    ,n021(w020,gnd,a)
    ,n022(w020,gnd,~c)
    ,n023(w021,w020,~a)
    ,n024(w021,w020,c);

    nmos #(3,4,5) n030(y0,w021,~b)
    ,n031(w030,w021,a)
    ,n032(w030,w021,c)
    ,n033(y0,w030,~a)
    ,n034(y0,w030,~c);

    pmos #(5,6,7) n000(w000,vdd,~a)
    ,n001(w002,w000,~c)
    ,n002(w001,vdd,a)
    ,n003(w002,w001,c)
    ,n004(y0,w002,~b);

    pmos #(5,6,7) n010(w010,vdd,a)
    ,n011(w012,w010,~c)
    ,n012(w011,vdd,~a)
    ,n013(w012,w011,c)
    ,n014(y0,w012,b);

    wire w100,w101;
    wire w110,w111;

    nmos #(3,4,5) n102(w10,gnd,~c),
    n103(w101,gnd,~a),
    n104(w10,w101,~b),
    n100(y1,w10,~a),
    n101(y1,w10,~b);

    pmos #(5,6,7) n110(w110,vdd,~a),
    n111(y1,w110,~b),
    n112(w111,vdd,~c),
    n113(y1,w111,~a),
    n114(y1,w111,~b);
endmodule