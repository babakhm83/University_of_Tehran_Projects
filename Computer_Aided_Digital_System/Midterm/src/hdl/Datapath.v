module datapath #(parameter BITS_X=8,BITS_N=3) (N,X,selX,sel_decode,ldN,shl,clk,rst, Nlt,out,of,error);
    parameter N_PIPE=4;
    parameter [31:0] K1={1'b0,{31{1'b1}}},K2={2'b11,{30{1'b0}}},K3={2'b00,{15{2'b10}}},K4={3'b111,{29{1'b0}}},
    K5={4'b0001,{7{4'b1001}}},K6={2'b11,{15{2'b10}}},K7={2'b00,{10{3'b010}}},K8={4'b1111,{28{1'b0}}};
    parameter BITS_Y = 4*BITS_X;
    input selX,sel_decode,ldN,shl,clk,rst;
    input [BITS_N-1:0] N;
    input [BITS_X-1:0] X;
    output Nlt,of,error;
    output signed [BITS_Y-1:0] out;
    wire [BITS_N-1:0] savedN;
    wire [N_PIPE-1:0] sel_cte,out_decode,out_sel;
    wire of0,of1,of2,of3;
    wire signed [BITS_Y-1:0] outX0,X0,powerX0,outX1,X1,powerX1,outX2,X2,powerX2,outX3,X3,powerX3,X_o,powerX;

    multiplexer #(.BITS(BITS_Y))mux_X(.pin0(X_o),.pin1({X,{3*BITS_X{1'b0}}}),.sel(selX), .pout(X0));
    multiplexer #(.BITS(BITS_Y))mux_outX(.pin0(out),.pin1({BITS_Y{1'b0}}),.sel(selX), .pout(outX0));
    multiplexer #(.BITS(BITS_Y))mux_powerX(.pin0(powerX),.pin1({1'b0,{(BITS_Y-1){1'b1}}}),.sel(selX), .pout(powerX0));
    multiplexer #(.BITS(1))mux_of(.pin0(of),.pin1(1'b0),.sel(selX), .pout(of0));
    multiplexer #(.BITS(N_PIPE))mux_dcd(.pin0({N_PIPE{1'b0}}),.pin1(out_decode),.sel(sel_decode), .pout(out_sel));

    register #(.BITS(BITS_N))regN(.pin(N),.ld(ldN),.clk(clk),.rst(rst), .pout(savedN));
    comparator #(.BITS(BITS_N))cmp(.pin0(savedN),.pin1({{(BITS_N-3){1'b0}},3'b100}),.lt(Nlt));
    johnson_counter #(.BITS(N_PIPE))sel_reg(.shl(shl),.clk(clk),.rst(rst), .pout(sel_cte));
    decoder #(.BITS(BITS_N),.N_PIPE(N_PIPE))dcd(.N(savedN),.pout(out_decode));

    pipeline #(.BITS(BITS_Y))p1(.outX_in(outX0),.X_in(X0),.powerX_in(powerX0),.of_in(of0),.cte0(K1),.cte1(K5),.sel_cte(sel_cte[0]),
    .out_sel(out_sel[0]),.clk(clk),.rst(rst),.outX_o(outX1),.X_o(X1),.powerX_o(powerX1),.of_o(of1));

    pipeline #(.BITS(BITS_Y))p2(.outX_in(outX1),.X_in(X1),.powerX_in(powerX1),.of_in(of1),.cte0(K2),.cte1(K6),.sel_cte(sel_cte[1]),
    .out_sel(out_sel[1]),.clk(clk),.rst(rst),.outX_o(outX2),.X_o(X2),.powerX_o(powerX2),.of_o(of2));

    pipeline #(.BITS(BITS_Y))p3(.outX_in(outX2),.X_in(X2),.powerX_in(powerX2),.of_in(of2),.cte0(K3),.cte1(K7),.sel_cte(sel_cte[2]),
    .out_sel(out_sel[2]),.clk(clk),.rst(rst),.outX_o(outX3),.X_o(X3),.powerX_o(powerX3),.of_o(of3));

    pipeline #(.BITS(BITS_Y))p4(.outX_in(outX3),.X_in(X3),.powerX_in(powerX3),.of_in(of3),.cte0(K4),.cte1(K8),.sel_cte(sel_cte[3]),
    .out_sel(out_sel[3]),.clk(clk),.rst(rst),.outX_o(out),.X_o(X_o),.powerX_o(powerX),.of_o(of));
    assign error=(X == {1'b1,{(BITS_X-1){1'b0}}}) ? 1'b1 : 1'b0;
endmodule