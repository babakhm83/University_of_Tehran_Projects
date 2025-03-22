module C2 (input D00 , D01 ,D10 , D11 , A1 , B1 , A0 , B0 , output reg out);
initial begin 
    $system("c2.exe ");
end
    integer fd ;
    wire s0 , s1; 
    assign s1 = A1 | B1 ;
    assign s0 = A0 & B0 ;
    always @(*)
    begin 
      if (s1 == 1 && s0 == 1)
      begin
        out = D11;
      end
      if (s1 == 1 && s0 == 0)
      begin
        out = D10;
      end
      if (s1 == 0 && s0 == 1)
      begin
        out = D01;
      end
      if (s1 == 0 && s0 == 0)
      begin
        out = D00;
      end
    end
endmodule