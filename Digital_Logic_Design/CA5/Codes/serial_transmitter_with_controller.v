`timescale 1ns/1ns
module serial_transmitter_with_controller(input serIn,detect,clk,rst, output sd);
    wire start_detect,end_detect, start_count,end_count,start_transmit, end_transit;
    q_mealy_start_sequence_detector();
    bit_counter();
    reg [1:0] ns,ps;
    always@(ps,serIn) begin
        ns=3'b00;
        case (ps)
            3'b00: begin start_detect=1; ns= end_detect ? 3'b00 : 3'b01; end
            3'b01: begin start_detect=0; start_count=1; ns= end_count ? 3'b10 : 3'b01; end
            3'b10: begin start_count=0; start_transmit=1; ns= end_transit ? 3'b11 : 3'b00; end
            default: ns= 3'b000;
        endcase
    end
    always @(posedge clk, rst) begin
        if(rst)
            ps<=3'b000;
        else if(end_detect)
            ps<=ns;
    end
endmodule