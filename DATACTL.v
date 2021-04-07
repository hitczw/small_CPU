module DATACTL(IN,DATA_ENA,DATA);
	//数据控制器,用于数据输出
	input[7:0] IN;
	input DATA_ENA;
	output[7:0] DATA;
	
	assign DATA=DATA_ENA?IN:8'bzzzzzzzz;
endmodule
