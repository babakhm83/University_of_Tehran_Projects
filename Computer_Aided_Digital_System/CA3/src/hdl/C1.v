module C1(input SB,SA,S1,S0,A0,B0,A1,B1, output out) ;
initial begin 
    $system("c1.exe ");
end
wire f1 , f2 , s2; 
assign f1 = (SA)? A1:A0;
assign f2 = (SB)? B1:B0;
assign s2 = S0|S1;
assign out=(s2)?f2:f1;
endmodule