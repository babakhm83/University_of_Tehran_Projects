module add_and_mod#(parameter WIDTH_NUM1,WIDTH_NUM2,WIDTH_SUM, parameter [WIDTH_SUM-1:0] MOD)(num1,num2,sum);
    input [WIDTH_NUM1-1:0] num1;
    input [WIDTH_NUM2-1:0] num2;
    output [WIDTH_SUM-1:0] sum;
    wire co;
    wire [WIDTH_SUM-1:0] temp_sum;
    assign {co,temp_sum} = num1+num2;
    assign sum = (temp_sum >= MOD) ? (num1+num2-MOD) : (num1+num2);
endmodule