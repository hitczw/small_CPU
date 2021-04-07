module CONTROL(CLK1,RST,OPCODE,ZERO,
               INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH,ALU_N,ALU_ENA);
	input CLK1,RST,ZERO;
	input[2:0] OPCODE;
	output reg INC_PC,//计数器时钟,上升沿起作用
				  LOAD_ACC,//累加器使能，累加器加载数据
				  LOAD_PC, //计数器使能，装载地址数据
				  RD,WD, //读写标志位
				  LOAD_IR,//寄存器使能，装载新数据
				  DATACTL_ENA,//输出数据使能
				  FETCH,//为0时选择输出程序地址
				  ALU_N,//
                                  ALU_ENA;
	reg[2:0] state;
	parameter HLT =3'b000, //停机空一个指令周期
							 SKZ =3'b001, //为0跳过下一条指令
							 ADD =3'b010, //
							 ANDD=3'b011,
							 XORR=3'b100,
							 LDA =3'b101, //读地址数据到累加器
							 STO =3'b110, //写累加器数据到指定地址
							 JMP =3'b111; //无条件跳转
	always@(negedge CLK1)begin
		if(RST)begin
			{INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00000000;
			ALU_N<=0;
                        ALU_ENA<=0;
			state<=3'b000;
		end
		
		else begin
			casex(state)
				3'b000:begin
				  {INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00010100;//将RD和load_ir置1，在下一个上升沿读取程序数据
					ALU_N<=0; 
                                        ALU_ENA<=0;
					state<=3'b001;
				end
				
				3'b001:begin
					{INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b10010100;//制造计数器上升沿,使计数器输出的程序地址输出+1,在下一个上升沿读后8位指令数据
			                 ALU_N<=0;
                                         ALU_ENA<=0;
					state<=3'b010;
				end
				
				3'b010:begin
					{INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00000000;//一行程序读取完成，将load_ir和inc_pc置0，此时数据已经锁存在register中，准备进入下一状态
					ALU_N<=0;
                                        ALU_ENA<=0;
					state<=3'b011;
				end
				
				3'b011:begin
					{INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b10000000;//inc_pc制造计数器上升沿,程序地址输出+1,指向下一条指令
					ALU_N<=0;
                                        ALU_ENA<=0;
					state<=3'b100;
				end
				
				/*parameter HLT =3'b000, //停机空一个指令周期
							 SKZ =3'b001, //为0跳过下一条指令
							 ADD =3'b010, //
							 ANDD=3'b011,
							 XORR=3'b100,
							 LDA =3'b101, //读地址数据到累加器
							 STO =3'b110, //写累加器数据到指定地址
							 JMP =3'b111; //无条件跳转*/
				
				3'b100:begin
				//开始处理指令数据
					if(OPCODE==ADD||OPCODE==ANDD||OPCODE==XORR||OPCODE==LDA)begin
					//上述指令需要读取RAM中指定地址的数据，所以要将rd置1，将FETCH置1令地址选择器ADDR选择输出RAM地址
					  {INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00010001;
                                           ALU_ENA<=1;
					   ALU_N<=1;
					end
					
					else if(OPCODE==HLT)begin
					//HLT指令 写指定数到累加器 将ALU_N置1 选择输出指令中的数据
						{INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00000000;
                                           ALU_ENA<=0;
					   ALU_N<=1;
					end
					
					else if(OPCODE==JMP ||(OPCODE==SKZ && ZERO))begin
					//JMP指令，令程序计数器LOAD=1，在下一个INC_PC的上升沿中，将指令中的地址加载到程序计数器COUNTER
					  {INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00010000;
                                           ALU_ENA<=0;
					  ALU_N<=0;
					end
					
					else if(OPCODE==STO)begin
					//STO指令，写累加器数据到指定地址，先输出累加器数据，待wr上升沿写入
					  {INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00000011;
                                           ALU_ENA<=0;
					  ALU_N<=0;
					end
					
					else begin
					  {INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00000000;
                                           ALU_ENA<=0;
					  ALU_N<=0;
					end
					state<=3'b101;
				end
				
				3'b101:begin
					if(OPCODE==ADD||OPCODE==ANDD||OPCODE==XORR||OPCODE==LDA)begin
					//此时上述指令的相关计算ALU已经完成，需要将结果写到累加器中，将load_ACC置1
					  {INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b01010000;
                                          ALU_ENA<=0;
					  ALU_N<=0;
					end
					
					else if(OPCODE==HLT)begin
					//HLT指令 将LOAD_ACC置1，累加器准备存储数据
						{INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b01000000;
					   ALU_N<=1;
                                              ALU_ENA<=0;
					end
					
					else if(OPCODE==JMP ||(OPCODE==SKZ && ZERO))begin
					//JMP指令，LOAD已经为1，制造上升沿让程序计数器输出指令中的地址
					  {INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b10100000;
					  ALU_N<=0;
                                           ALU_ENA<=0;
					end
					
					else if(OPCODE==STO)begin
					//STO指令，制造wr上升沿，将指定地址写入
					  {INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00001011;
                                           ALU_ENA<=0;
					end
					
					/*else if(OPCODE==SKZ && ZERO)begin
					//SKZ指令，累加器数据为0则跳转，制造COUNTER上升沿，使程序地址输出+1
					  {INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b10000000;
					  ALU_N<=0;
                                          ALU_ENA<=0;
					end*/
					
					else begin
						{INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00000000;
						ALU_N<=0;
                                                ALU_ENA<=0;
					end
					state<=3'b110;
					
				end
				
				3'b110:begin
					{INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00000000;
					ALU_N<=0;
                                        ALU_ENA<=0;
					state<=3'b111;
				end
				
				3'b111:begin
				  /*if(OPCODE==SKZ && ZERO)begin
				  //SKZ指令，制造另一个上升沿，此时程序计数器输出指令地址再+1，指向下一条指令地址
					  {INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b10000000;
					  ALU_N<=0;
				  end*/
				  
				  //else begin
						{INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00000000;
                                                 ALU_ENA<=0;
						ALU_N<=0;
				  //end
				  state<=3'b000;
				end
				
				default:begin
				  state<=3'b000;
				  {INC_PC,LOAD_ACC,LOAD_PC,RD,WD,LOAD_IR,DATACTL_ENA,FETCH}=8'b00000000;
                                   ALU_ENA<=0;
				  ALU_N<=0;
				end
			endcase
		end
	end
	
endmodule
