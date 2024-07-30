`timescale 1ns/1ns
module controller(input Detected,Collected,Transmitted,clk,rst, output reg Detect,Collect,Load,Transmit);
    parameter [1:0] Detecting=0,Collecting=1,Loading=2,Transmitting=3;
    reg [1:0] ns,ps;
    always@(ps,Detected,Collected,Transmitted) begin
        ns=Detecting;
        {Detect,Collect,Load,Transmit} = 4'b0;
        case (ps)
            Detecting: begin ns = Detected ? Collecting : Detecting; Detect = 1; end
            Collecting: begin ns = Collected ? Loading : Collecting; Collect = 1; end
            Loading: begin ns = Transmitting; Load = 1; end
            Transmitting: begin ns = Transmitted ? Detecting : Transmitting; Transmit = 1; end
            default: ns= Detecting;
        endcase
    end
    always@(posedge clk, posedge rst) begin
        if(rst)
            ps<=Detecting;
        else
            ps<=ns;
    end
endmodule