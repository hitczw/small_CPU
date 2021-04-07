module COUNTER(IR_ADDR,LOAD,CLOCK,RST,OUT_ADDR);
//程序计数器，用于输出程序地址
input[12:0] IR_ADDR;
input LOAD;
input CLOCK;
input RST;
output[12:0]OUT_ADDR;
reg[12:0]OUT_ADDR;

always@(posedge CLOCK or posedge RST)begin
	if(RST)begin
		OUT_ADDR<=13'b0000000000000;
	end
	
	else begin
		if(LOAD) begin
			OUT_ADDR<=IR_ADDR;
		end
		
		else begin
			OUT_ADDR<=OUT_ADDR+1;
		end
	end
end
endmodule
