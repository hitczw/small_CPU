module RAOM(data,addr,read,write);

	inout[7:0] data;
	input[12:0] addr;
	input read;
	input write;

	reg[7:0]raom[13'h1ff:0];
	initial begin

//??
/*
a=1 b=1
loop: c=a+b b=a a=c
goto loop
 */
//HLT 1
raom[0]=8'b00000000;
raom[1]=8'b00001000;

//STO 300
raom[2]=8'b00001001;
raom[3]=8'b01100110;

//STO 301
raom[4]=8'b00001001;
raom[5]=8'b01101110;

//HLT 0
raom[6]=8'b00000000;
raom[7]=8'b00000000;

//STO 302
raom[8]=8'b00001001;
raom[9]=8'b01110110;

//HLT 5
raom[10]=8'b00000000;
raom[11]=8'b00101000;

//STO 400
raom[12]=8'b00001100;
raom[13]=8'b10000110;

//HLT 255
raom[14]=8'b00000111;
raom[15]=8'b11111000;

//STO 401
raom[16]=8'b00001100;
raom[17]=8'b10001110;

//LDA 300
raom[18]=8'b00001001;
raom[19]=8'b01100101;

//ADD 301
raom[20]=8'b00001001;
raom[21]=8'b01101010;

//STO 303
raom[22]=8'b00001001;
raom[23]=8'b01111110;

//LDA 301
raom[24]=8'b00001001;
raom[25]=8'b01101101;

//STO 300
raom[26]=8'b00001001;
raom[27]=8'b01100110;

//LDA 303
raom[28]=8'b00001001;
raom[29]=8'b01111101;

//STO 301
raom[30]=8'b00001001;
raom[31]=8'b01101110;

//LDA 400
raom[32]=8'b00001100;
raom[33]=8'b10000101;

//ADD 401
raom[34]=8'b00001100;
raom[35]=8'b10001010;

//STO 400
raom[36]=8'b00001100;
raom[37]=8'b10000110;

//SKZ 100
raom[38]=8'b00000011;
raom[39]=8'b00100001;

//JMP 18
raom[40]=8'b00000000;
raom[41]=8'b10010111;




	end
	
	assign data=read?raom[addr]:8'bzzzzzzzz;

	always@(posedge write)begin
		raom[addr]<=data;
	end

endmodule
