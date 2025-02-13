module risc_v_tb();
reg clk=0,rst=1,IMLD=1,DMLD=1;
reg [31:0] IMWD=32'd0,IMA=32'd0,DMWD=32'd0,DMA=32'd0;
risc_v risc(clk,rst,IMLD,IMWD,IMA,DMLD,DMWD,DMA);
always begin #19;clk=~clk;end
// Assembly:
// s0: addr of first element of array
// s1: i
// s2: max
// t0: sltiu
// t1: addr of current data in dm
// t2: current data
/*
MAIN: addi s0,zero,0
    add s1,zero,zero
    lw s2,0(s0)
    For: sltiu t0,s1,40
        beq t0,zero,32
        add t1,s1,s0
        lw t2,0(t1)
        IF: sltu t0,s2,t2
            beq t0,zero,8
            add s2,zero,t2
        END_IF: addi s1,s1,4
        jal -32,zero
    END_FOR: sw s2,140(zero)
*/
initial begin
    // Data Memory Initialization
    #1; DMA=32'd0; DMWD=32'd2;
    #1; DMA=32'd4; DMWD=32'd3;
    #1; DMA=32'd8; DMWD=32'd10;
    #1; DMA=32'd12; DMWD=32'd7;
    #1; DMA=32'd16; DMWD=32'd4;
    #1; DMA=32'd20; DMWD=32'd8;
    #1; DMA=32'd24; DMWD=32'd9;
    #1; DMA=32'd28; DMWD=32'd4;
    #1; DMA=32'd32; DMWD=-32'd11;
    #1; DMA=32'd36;DMWD=-32'd2;
    // Instruction Memory Initialization
    #1;  DMLD=0;
    #1; IMA=32'd0; IMWD=32'b00000000000000000000010000010011;
    #1; IMA=32'd4; IMWD=32'b00000000000000000000010010110011;
    #1; IMA=32'd8; IMWD=32'b00000000000001000010100100000011;
    #1; IMA=32'd12; IMWD=32'b00000010100001001011001010010011;
    #1; IMA=32'd16; IMWD=32'b00000010000000101000000001100011;
    #1; IMA=32'd20; IMWD=32'b00000000100001001000001100110011;
    #1; IMA=32'd24; IMWD=32'b00000000000000110010001110000011;
    #1; IMA=32'd28; IMWD=32'b00000000011110010010001010110011;
    #1; IMA=32'd32; IMWD=32'b00000000000000101000010001100011;
    #1; IMA=32'd36; IMWD=32'b00000000011100000000100100110011;
    #1; IMA=32'd40; IMWD=32'b00000000010001001000010010010011;
    #1; IMA=32'd44; IMWD=32'b11111110000111111111000001101111;
    #1; IMA=32'd48; IMWD=32'b00001001001000000010011000100011;
    #38; rst = 0; IMLD = 0;
    #38000;
    #38 $stop;
end
endmodule