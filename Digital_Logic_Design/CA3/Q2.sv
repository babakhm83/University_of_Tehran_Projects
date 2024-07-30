module my_mixer(input signed [15:0] inA, inB,
			output reg signed [15:0] outW);
    assign outW={inA[7:0],inB[7:0]};
endmodule

module my_bitwise_orer(input signed [15:0] inA, inB,
			output reg signed [15:0] outW);
    assign outW=inA|inB;
endmodule

module my_one_right_shifter(input signed [15:0] inA,
			output reg signed [15:0] outW);
    assign outW=inA>>>1;
endmodule

module my_adder(input signed [15:0] inA, inB, input inC,
			output reg signed [15:0] outW);
    assign outW=inA+inB+inC;
endmodule

module my_bitwise_not(input signed [15:0] inA,
			output reg signed [15:0] outW);
    assign outW=~(inA);
endmodule

module my_structural_ALU (input signed [15:0] inA, inB,input inC,input [2:0] opc,
			output reg signed [15:0] outW, output reg zer,neg);
            wire w0 = 1'b0;
            wire [15:0] w1 = 16'b1;
            wire signed [15:0] w2;
            bitwise_not ins0(inA,w2);
            wire signed [15:0] w3;
            adder ins1(w2,w1,w0,w3);
            wire signed [15:0] w4;
            adder ins2(inA,w1,w0,w4);
            wire signed [15:0] w5;
            adder ins3(inA,inB,inC,w5);
            wire signed [15:0] w6;
            one_right_shifter ins4(inB,w6);
            wire signed [15:0] w7;
            adder ins5(w6,inA,w0,w7);
            wire signed [15:0] w8;
            bitwise_orer ins6(inA,inB,w8);
            wire signed [15:0] w9;
            bitwise_not ins7(inB,w9);
            wire signed [15:0] w10;
            bitwise_orer ins8(w2,w9,w10);
            wire signed [15:0] w11;
            bitwise_not ins9(w10,w11);
            wire signed [15:0] w12;
            mixer ins10(inA,inB,w12);
    assign outW = 
            (opc==3'b000) ? w3:
            (opc==3'b001) ? w4:
            (opc==3'b010) ? w5:
            (opc==3'b011) ? w7:
            (opc==3'b100) ? w11:
            (opc==3'b101) ? w8:
            (opc==3'b110) ? w12:
            16'd0;
    assign zer=(outW==16'd0)?1'b1:1'b0;
    assign neg=(outW[15]==1'b1)?1'b1:1'b0;
endmodule