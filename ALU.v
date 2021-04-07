module ALU(DATA,ACCUM,OPCODE,ALU_OUT,ALU_ENA,CLK);
//改进：取消算术时钟，减少逻辑复杂性
input[7:0] DATA;
input[7:0] ACCUM;
input[2:0] OPCODE;
output[7:0] ALU_OUT;
input CLK;
reg[7:0] ALU_OUT;
input ALU_ENA;
parameter HLT =3'b000, //停机空一个指令周期
	  SKZ =3'b001, //为0跳过下一条指令
	  ADD =3'b010, //
	  ANDD=3'b011,
	  XORR=3'b100,
	  LDA =3'b101, //读地址数据到累加器
	  STO =3'b110, //写累加器数据到指定地址
	  JMP =3'b111; //无条件跳转
	  
always@(posedge CLK)begin
    if(ALU_ENA)begin
      casex (OPCODE)
	ADD: ALU_OUT<=DATA+ACCUM;
	ANDD:ALU_OUT<=DATA&ACCUM;
	XORR:ALU_OUT<=DATA^ACCUM;
	LDA:ALU_OUT <=DATA;
	default:ALU_OUT<=ALU_OUT;
      endcase
    end
   else begin
     ALU_OUT<=ALU_OUT;
   end
    

end
endmodule

/*module ALU(DATA,ACCUM,ALU_CLOCK,OPCODE,ALU_OUT);
input[7:0] DATA;
input[7:0] ACCUM;
input[2:0] OPCODE;
input ALU_CLOCK;
output[7:0] ALU_OUT;
reg[7:0] ALU_OUT;

parameter HLT =3'b000, //停机空一个指令周期
			 SKZ =3'b001, //为0跳过下一条指令
			 ADD =3'b010, //
			 ANDD=3'b011,
			 XORR=3'b100,
			 LDA =3'b101, //读地址数据到累加器
			 STO =3'b110, //写累加器数据到指定地址
			 JMP =3'b111; //无条件跳转
always@(posedge ALU_CLOCK)begin
	casex (OPCODE)
		//HLT:ALU_OUT<=ACCUM;
		//SKZ:ALU_OUT<=ACCUM;
		ADD:ALU_OUT<=DATA+ACCUM;
		ANDD:ALU_OUT<=DATA&ACCUM;
		XORR:ALU_OUT<=DATA^ACCUM;
		//LDA:ALU_OUT<=ACCUM;
		//STO:ALU_OUT<=ACCUM;
		//JMP:ALU_OUT<=ACCUM;
		default:ALU_OUT<=ACCUM;
	endcase
end


endmodule*/