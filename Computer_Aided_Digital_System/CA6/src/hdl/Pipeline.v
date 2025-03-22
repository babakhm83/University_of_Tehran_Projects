module pipeline#(parameter WIDTH)(Filter,IFMap,second_filter_in,second_filter,is_zero_in,is_zero,run,mode,clr_pipe_in,done_psum_in,stall,Psum_in,input_Psum,wen_Psum_in,wen_Psum,clk,rst, Psum,done_psum,reg_clr_pipe);
    input run,clr_pipe_in,second_filter_in,is_zero_in,done_psum_in,wen_Psum_in,stall,clk,rst;
    input [1:0] mode;
    input [WIDTH-1:0] Filter, IFMap,Psum_in,input_Psum;
    output done_psum,wen_Psum,reg_clr_pipe,second_filter,is_zero;
    output [WIDTH-1:0] Psum;
    wire clr_pipe1,clr_pipe2,clr_pipe3,second_filter_reg,is_zero_reg;
    wire run1,done_psum_reg,wen_Psum_reg;
    wire [WIDTH-1:0] mult_to_reg,num1_to_add,num2_to_add,mult_to_add;
    assign num1_to_add = done_psum_reg ? input_Psum : mult_to_add;

    register #(.WIDTH(1))run_reg0(.pin(run),.ld(1'b1),.stall(stall),.clk(clk),.rst(rst), .pout(run1));

    assign num2_to_add = (mode==2 & clr_pipe3 | clr_pipe2) ? {WIDTH{1'b0}} : Psum_in;
    multiplier #(.WIDTH(WIDTH))mult(.pin1(Filter),.pin2(IFMap), .pout(mult_to_reg));
    register #(.WIDTH(WIDTH))mult_reg(.pin(mult_to_reg),.ld(run1),.stall(stall),.clk(clk),.rst(rst), .pout(mult_to_add));

    register #(.WIDTH(1))reg_clr_pipe0(.pin(clr_pipe_in),.ld(run),.stall(stall),.clk(clk),.rst(rst), .pout(clr_pipe1));
    register #(.WIDTH(1))reg_clr_pipe1(.pin(clr_pipe1),.ld(run),.stall(stall),.clk(clk),.rst(rst), .pout(reg_clr_pipe));
    register #(.WIDTH(1))reg_clr_pipe2(.pin(reg_clr_pipe),.ld(run),.stall(stall),.clk(clk),.rst(rst), .pout(clr_pipe2));
    register #(.WIDTH(1))reg_clr_pipe3(.pin(clr_pipe2),.ld(run),.stall(stall),.clk(clk),.rst(rst), .pout(clr_pipe3));
    
    register#(.WIDTH(4))done_psum_reg0(.pin({done_psum_in,wen_Psum_in,second_filter_in,is_zero_in}),.ld(1'b1),.stall(stall),.clk(clk),.rst(rst), 
    .pout({done_psum_reg,wen_Psum_reg,second_filter_reg,is_zero_reg}));
    register#(.WIDTH(4))done_psum_reg1(.pin({done_psum_reg,wen_Psum_reg,second_filter_reg,is_zero_reg}),.ld(1'b1),.stall(stall),.clk(clk),.rst(rst), 
    .pout({done_psum,wen_Psum,second_filter,is_zero}));

    adder #(.WIDTH_NUM1(WIDTH),.WIDTH_NUM2(WIDTH),.WIDTH_SUM(WIDTH))add
        (.num1(num1_to_add),.num2(num2_to_add), .sum(Psum));
endmodule