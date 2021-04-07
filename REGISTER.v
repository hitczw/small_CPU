module REGISTER(DATA,ENA,CLK,OPCODE,IR_ADDR/*,RST*/);
	input[7:0] DATA;
	input ENA;
	input CLK;
	//input RST;
	output [2:0] OPCODE;
	output [12:0] IR_ADDR;
	reg[15:0] opc_iraddr;
	reg state;
	
	assign OPCODE=opc_iraddr[2:0];
	assign IR_ADDR=opc_iraddr[15:3];
	
	always@(posedge CLK)begin
          /*if(RST)begin
            opc_iraddr<=16'b0000_0000_0000_0000;
	    state<=0;
          end*/

	  //else 
               if(ENA) begin
				case(state)
				1'b0:begin
					opc_iraddr[15:8]<=DATA;
					state<=1;
				end
				1'b1:begin
					opc_iraddr[7:0]<=DATA;
					state<=0;
				end
				/*default:begin
					opc_iraddr[15:0]<=16'bxxxxxxxxxxxxxxx;
					state<=1'bx;
				end*/
				endcase
		end
		
		else begin
			//opc_iraddr<=16'b0000000000000000;
			state<=0;
		end
			
	end
endmodule
