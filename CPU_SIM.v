`timescale 1ns/1ns
module CPU_SIM;

//module CPU_top(RST,CLK,ACCUM_OUT);
reg RST;
reg CLK;
wire[7:0] ACCUM_OUT;

initial
begin
  RST=1;
  CLK=0;
#300
  RST=0;
end

always#100 CLK=~CLK;
CPU_top  ex(RST,CLK,ACCUM_OUT);
           //CPU_top(RST,CLK,ACCUM_OUT);

endmodule