module assign_my_counter(input a,b,c, output y0,y1);
    assign #(40,38) y0 = b&((~a&~c)|(a&c))|(~b&((a&~c)|(~a&c)));
    assign #(30,28) y1 = (a&b)|(c&(a|b));
endmodule