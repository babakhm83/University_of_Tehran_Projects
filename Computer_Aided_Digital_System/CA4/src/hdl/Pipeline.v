module pipeline#(parameter WIDTH)(Filter,IFMap,run,clr_pipe_in,done_psum_in,stall,clk,rst, Psum,done_psum);
    input run,clr_pipe_in,done_psum_in,stall,clk,rst;
    input [WIDTH-1:0] Filter, IFMap;
    output done_psum;
    output [WIDTH-1:0] Psum;
    wire clr_pipe0,clr_pipe1,clr_pipe2;
    wire run1,run2,done_psum_reg;
    wire [WIDTH-1:0] mult_to_reg,num2_adder,mult_to_add,Psum,next_Psum;
    register #(.WIDTH(1))run_reg0(.pin(run),.ld(1'b1),.stall(stall),.clk(clk),.rst(rst), .pout(run1));
    register #(.WIDTH(1))run_reg1(.pin(run1),.ld(1'b1),.stall(stall),.clk(clk),.rst(rst), .pout(run2));

    assign num2_adder = clr_pipe2 ? {WIDTH{1'b0}} : Psum;
    multiplier #(.WIDTH(WIDTH))mult(.pin1(Filter),.pin2(IFMap), .pout(mult_to_reg));
    register #(.WIDTH(WIDTH))mult_reg(.pin(mult_to_reg),.ld(run1),.stall(stall),.clk(clk),.rst(rst), .pout(mult_to_add));

    register #(.WIDTH(1))reg_clr_pipe0(.pin(clr_pipe_in),.ld(run),.stall(stall),.clk(clk),.rst(rst), .pout(clr_pipe0));
    register #(.WIDTH(1))reg_clr_pipe1(.pin(clr_pipe0),.ld(run1),.stall(stall),.clk(clk),.rst(rst), .pout(clr_pipe1));
    register #(.WIDTH(1))reg_clr_pipe2(.pin(clr_pipe1),.ld(run2),.stall(stall),.clk(clk),.rst(rst), .pout(clr_pipe2));
    
    register#(.WIDTH(1))done_psum_reg0(.pin(done_psum_in),.ld(1'b1),.stall(stall),.clk(clk),.rst(rst), .pout(done_psum_reg));
    register#(.WIDTH(1))done_psum_reg1(.pin(done_psum_reg),.ld(1'b1),.stall(stall),.clk(clk),.rst(rst), .pout(done_psum));
    
    adder #(.WIDTH_NUM1(WIDTH),.WIDTH_NUM2(WIDTH),.WIDTH_SUM(WIDTH))add
        (.num1(mult_to_add),.num2(num2_adder), .sum(next_Psum));
    register #(.WIDTH(WIDTH))add_reg(.pin(next_Psum),.ld(run2),.stall(stall),.clk(clk),.rst(rst), .pout(Psum));
endmodule