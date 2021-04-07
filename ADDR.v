module ADDR(FETCH,IR_ADDR,PC_ADDR,OUT_ADDR);
//地址选择器，选择ROM地址或者RAM地址
input FETCH;
input[12:0] IR_ADDR;
input[12:0] PC_ADDR;
output[12:0] OUT_ADDR;

assign OUT_ADDR=FETCH?IR_ADDR:PC_ADDR;
endmodule
