module ALU(
	input logic[31:0] instruction,
	input logic[31:0] ReadData1,
	input logic reset,
	input logic[31:0] ReadData2,
	output logic[31:0] ALUResult	
);

logic[5:0] opcode;
assign opcode = instruction[31:26];
logic[5:0] func;
assign func = instruction[5:0];
logic[31:0] immediateSE;
assign immediateSE = instruction[15:0];
logic[31:0] immediateZE;
assign immediateZE = {16'b0, instruction[15:0]};

always_comb begin

	if(opcode==0) begin
		case(func)
			6'b100000: ALUResult = ReadData1 + ReadData2;
		endcase
	end

	else if(opcode == 6'b001001)begin
		ALUResult = ReadData1 + immediateZE;
	end	
	
	else if(opcode == 6'b100011 || opcode == 6'b101011)begin
		ALUResult = ReadData1 + immediateSE;
	end


end

endmodule