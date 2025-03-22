module controller_circular_buffer(read_en,write_en,full,empty, valid,ready,cnt_w,cnt_r,wen);
    input read_en,write_en,full,empty;
    output valid,ready,cnt_w,cnt_r,wen;
    assign valid = (~empty);
    assign ready = (~full);
    assign cnt_r = ({write_en,read_en}==2'b00)?1'b0:({write_en,read_en}==2'b01)?(~empty):
    ({write_en,read_en}==2'b10)?1'b0:1'b1;
    assign cnt_w = ({write_en,read_en}==2'b00)?1'b0:({write_en,read_en}==2'b01)?1'b0:
    ({write_en,read_en}==2'b10)?(~full):1'b1;
    assign wen = ({write_en,read_en}==2'b00)?1'b0:({write_en,read_en}==2'b01)?1'b0:
    ({write_en,read_en}==2'b10)?(~full):(~full);
endmodule