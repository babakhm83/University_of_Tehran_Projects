`timescale 1ns/1ns
`default_nettype none

`define HALF_CLK 5
`define CLK (2 * `HALF_CLK)

module testbench ();
    reg clk, rst, start;

    parameter OUTPUT_WIDTH = 32;

    reg signed [7 : 0] X;
    reg [2 : 0] N;

    integer valid_cnt = 0;

    wire signed [OUTPUT_WIDTH - 1 : 0] Y;
    wire valid, ready, overflow, error;
    reg [OUTPUT_WIDTH : 0] outputs [0 : 5 * 20 - 1];
    always @(clk)begin
        # `HALF_CLK
        clk <= ~clk;
    end

    integer j;
    integer true_;
    always @(posedge clk) begin
        if (valid) begin
            //remove this if not necessary
            valid_cnt = valid_cnt + 1;
            if (valid_cnt >= 1 ? ready : 1) begin
                if ({overflow, Y} == outputs[j])
                    true_ = true_ + 1;
                j++;
            end
        end
    end

    integer ov = 0;
    always @(posedge clk) begin
        if (overflow)
            ov++;
    end

    natural_log_acc #(
        .BITS_X(8),.BITS_N(3)
    ) dut (
        .clk(clk),
        .rst(rst),
        .Start(start),
        .X(X),
        .N((N) ? N-1 : 3'd7),
        .Reset(rst),
        .Y(Y),
        .Valid(valid),
        .Ready(ready),
        .Overflow(overflow),
        .Error(error)
    );

    reg [7 : 0] inputs [0 : 19];
    reg [2 : 0] N_in [0 : 4];
    integer i, n;
    initial begin
        $readmemh("inputs.txt", inputs);
        $readmemh("outputs.mem", outputs);
        N_in = {3'd2, 3'd3, 3'd4, 3'd5, 3'd7};
        n = 0;
        true_ = 0;
        j = 0;

        ///////////////////////
        clk = 0;
        start = 0;
        rst = 0;
        #`CLK;
        rst = 1;
        #`CLK;
        rst = 0;
        #`CLK;

        while (n < 5) begin
            i = 0;
            start = 1;
            #`CLK;
            start = 0;
            N = N_in[n];
            #`CLK;
            while (i < 20) begin
                while (!ready) #`CLK;

                X = inputs[i];
                i++;
                #`CLK;
            end
            repeat (N <= 4 ? 3 : 7) #`CLK;
            rst = 1;
            #`CLK;
            rst = 0;
            #`CLK;
            n++;
        end
        #`CLK;
        #`CLK;

    end
endmodule