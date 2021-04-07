module ACCUMULATOR(ALU_OUT,LOAD_ACC,RST,ACCUM,ZERO);
//累加寄存器
input[7:0] ALU_OUT;//来自外界的数据，由程序本身或者算术逻辑单元计算得到
input LOAD_ACC;
input RST;
output[7:0] ACCUM;
reg[7:0] ACCUM;

output ZERO;
assign ZERO=!ACCUM;

always@(*)begin
	if(RST)begin
		ACCUM<=8'b00000000;
	end
	
	else if(LOAD_ACC)begin
		ACCUM<=ALU_OUT;
	end
	
	else begin
		ACCUM<=ACCUM;
	end
end
endmodule
