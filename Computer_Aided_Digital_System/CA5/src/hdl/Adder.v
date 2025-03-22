module adder#(parameter WIDTH_NUM1,WIDTH_NUM2,WIDTH_SUM)(num1,num2,sum);
    input [WIDTH_NUM1-1:0] num1;
    input [WIDTH_NUM2-1:0] num2;
    output [WIDTH_SUM-1:0] sum;
    wire co;
    assign {co,sum} = num1+num2;
endmodule