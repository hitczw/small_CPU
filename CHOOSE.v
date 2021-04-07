module CHOOSE(IR_ADDR,ALU_OUT,ALU_N,OUT_DATA);
//ALU_OUT为0时候输出ALU_OUT
	input[12:0] IR_ADDR;
	input[7:0] ALU_OUT;
	input ALU_N;
	output[7:0] OUT_DATA;
	
	assign OUT_DATA=ALU_N?IR_ADDR[12:0]:ALU_OUT;
	
endmodule
