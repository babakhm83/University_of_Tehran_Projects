module risc_v_tb();
reg clk=0,rst=1,LD=0;
reg [31:0] WD=32'd0,A=32'd0;
risc_v risc(clk,rst,LD,WD,A);
always begin #19;clk=~clk;end
// Assembly:
// s0: addr of first element of array
// s1: i
// s2: max
// t0: sltiu
// t1: addr of current data in dm
// t2: current data
/*
MAIN: addi s0,zero,100
    add s1,zero,zero
    add s2,zero,zero
    For: sltiu t0,s1,40
        beq t0,zero,32
        add t1,s1,s0
        lw t2,0(t1)
        IF: sltu t0,s2,t2
            beq t0,zero,8
            add s2,zero,t2
        END_IF: addi s1,s1,4
        jal zero,-32
    END_FOR: sw s2,140(s0)
*/
initial begin
    // Data Memory Initialization
    #1; LD=1;
    #1; A=32'd100; WD=32'd2;
    #1; A=32'd104; WD=32'd3;
    #1; A=32'd108; WD=32'd1;
    #1; A=32'd112; WD=32'd7;
    #1; A=32'd116; WD=32'd4;
    #1; A=32'd120; WD=32'd8;
    #1; A=32'd124; WD=32'd9;
    #1; A=32'd128; WD=32'd4;
    #1; A=32'd132; WD=32'd125;
    #1; A=32'd136;WD=32'd2;
    // Instruction Memory Initialization
    #1; A=32'd0; WD=32'b00000110010000000000010000010011;
    #1; A=32'd4; WD=32'b00000000000000000000010010110011;
    #1; A=32'd8; WD=32'b00000000000000000000100100110011;
    #1; A=32'd12; WD=32'b00000010100001001011001010010011;
    #1; A=32'd16; WD=32'b00000010000000101000000001100011;
    #1; A=32'd20; WD=32'b00000000100001001000001100110011;
    #1; A=32'd24; WD=32'b00000000000000110010001110000011;
    #1; A=32'd28; WD=32'b00000000011110010011001010110011;
    #1; A=32'd32; WD=32'b00000000000000101000010001100011;
    #1; A=32'd36; WD=32'b00000000011100000000100100110011;
    #1; A=32'd40; WD=32'b00000000010001001000010010010011;
    #1; A=32'd44; WD=32'b11111110000111111111000001101111;
    #1; A=32'd48; WD=32'b00000011001001000010010000100011;
    #38; rst = 0; LD = 0;
    #132000;
    #38 $stop;
end
endmodule