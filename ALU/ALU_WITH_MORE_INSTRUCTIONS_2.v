module ALU(
	input logic[31:0] instruction,
	input logic[31:0] ReadData1,
	input logic reset,
	input logic[31:0] ReadData2,
	output logic[31:0] ALUResult,
	output logic[3:0] byteenable
);

	logic[5:0] opcode;
	assign opcode = instruction[31:26];
	logic[5:0] func;
	assign func = instruction[5:0];
	logic[31:0] immediateSE;
	assign immediateSE = {{16{instruction[15]}}, instruction[15:0]};
	logic[31:0] immediateZE;
	assign immediateZE = {16'b0, instruction[15:0]};
	logic[4:0] shamt;
	assign shamt = instruction[10:6];
	
	
	logic[31:0] Reshold; //used to find byteenable in byte instructons
	assign Reshold = (ReadData1+immediateSE);
	logic[1:0] Byteneeded;
	assign Byteneeded = Reshold[1:0];

always_comb begin

	if(opcode==0) begin
		case(func)
			6'b100000: ALUResult = ReadData1 + ReadData2; //ADDU
			6'b100010: ALUResult = ReadData1 - ReadData2; //SUBU
			//6'b011000: ALUResult = ReadData1 * ReadData2;
			//6'b011010: ALUResult = ReadData1 / ReadData2;
			6'b101010: ALUResult = ($signed(ReadData1) < $signed(ReadData2)) ? 1 : 0; //SLT
			6'b101011: ALUResult = (ReadData1 < ReadData2) ? 1 : 0; //SLTU
			6'b100100: ALUResult = ReadData1 & ReadData2; //AND
			6'b100101: ALUResult = ReadData1 | ReadData2; //OR
			6'b101000: ALUResult = ReadData1 ^ ReadData2; //XOR
			6'b000000: ALUResult = ReadData2 << shamt; //SLL
			6'b000100: ALUResult = ReadData2 << ReadData1; //SLLV
			6'b000011: ALUResult = ReadData2 >>> shamt; //SRA
			6'b000111: ALUResult = ReadData2 >>> ReadData1; //SRAV
			6'b000010: ALUResult = ReadData2 >> shamt; //SRL
			6'b000110: ALUResult = ReadData2 >> ReadData1; //SRLV
		endcase
			
	end

	else if(opcode == 6'b001000)begin
		ALUResult = ReadData1 + immediateSE; //ADDIU
	end	
	
	else if(opcode == 6'b100011 || opcode == 6'b101011)begin
		ALUResult = (ReadData1 + immediateSE);//LW and SW
		byteenable = 4'b1111;
	end

	else if(opcode == 6'b001010)begin
		ALUResult = ($signed(ReadData1) < $signed(immediateSE)) ? 1 : 0; //SLTI
	end
	
	else if(opcode == 6'b001011)begin
		ALUResult = (ReadData1 < immediateSE) ? 1 : 0; //SLTIU
	end

	else if(opcode == 6'b001100)begin
		ALUResult = ReadData1 & immediateZE; //ANDI
	end

	else if(opcode == 6'b001101)begin
		ALUResult = ReadData1 | immediateZE; //ORI
	end

	else if(opcode == 6'b001110)begin
		ALUResult = ReadData1 ^ immediateZE; //XORI
	end

	else if(opcode == 6'b100000 || opcode == 6'b101000 || opcode == 6'b100100)begin
		ALUResult = ReadData1 + immediateSE;
		ALUResult[1:0] = 2'b0;		
		case(Byteneeded)
			0: byteenable = 4'b0001;
			1: byteenable = 4'b0010;
			2: byteenable = 4'b0100;
			3: byteenable = 4'b1000;
		endcase
	end
end


endmodule
