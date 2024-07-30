`timescale 1ns/1ns
module lut(input [2:0] adr, output [7:0] data);
    reg [15:0] datat;
    always @(adr) begin
        case(adr)
            0: datat =  16'hFF;// 1/1
            1: datat =  16'h80;// 1/2
            2: datat =  16'h55;// 1/3
            3: datat =  16'h40;// 1/4
            4: datat =  16'h33;// 1/5
            5: datat =  16'h2B;// 1/6
            6: datat =  16'h25;// 1/7
            7: datat =  16'h20;// 1/8
        endcase
    end
    assign data = datat;
endmodule