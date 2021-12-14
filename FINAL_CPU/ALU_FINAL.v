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
	logic[15:0] immediate;
	assign immediate = instruction[15:0];
	logic[31:0] immediateSE;
	assign immediateSE = {{16{instruction[15]}}, instruction[15:0]};
	logic[31:0] immediateZE;
	assign immediateZE = {16'b0, instruction[15:0]};
	logic[4:0] shamt;
	assign shamt = instruction[10:6];
	
    logic signed[31:0] SignedData1;
    logic signed[31:0] SignedData2;
    
    logic [63:0] tmp;
    logic signed[63:0] s_tmp;

	logic[31:0] hi;
	logic[31:0] lo;

    logic[31:0] hi_tmp;
    logic[31:0] lo_tmp;
    logic[31:0] shi_tmp;
    logic[31:0] slo_tmp;

    assign hi_tmp = tmp[63:32];
    assign lo_tmp = tmp[31:0];
    assign shi_tmp = s_tmp[63:32];
    assign slo_tmp = s_tmp[31:0];

	
	logic[31:0] Reshold; //used to find byteenable in byte instructons
	assign Reshold = (ReadData1+immediateSE);
	logic[1:0] Byteneeded;
	assign Byteneeded = Reshold[1:0];

always_comb begin

	if(opcode==0) begin
        SignedData1 = ReadData1;
        SignedData2 = ReadData2;

		case(func)
			6'b100001: ALUResult = ReadData1 + ReadData2; //ADDU
			6'b100011: ALUResult = ReadData1 - ReadData2; //SUBU
			6'b010000: ALUResult = hi; //MFHI
		    6'b010010: ALUResult = lo; //MFLO
            6'b010001: hi = ReadData1; //MTHI
            6'b010011: lo = ReadData1; //MTLO
			6'b101010: ALUResult = SignedData1 < SignedData2 ? 1 : 0; //SLT
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
		if(func == 6'b011000) begin //mulu
			tmp = ReadData1 * ReadData2;
            hi = hi_tmp;
            lo = lo_tmp;
		end
		else if(func == 6'b011010) begin //divu
			hi = ReadData1 / ReadData2;
			lo = ReadData1 % ReadData2;
		end 
        else if(func == 6'b011001) begin //mul
            s_tmp = SignedData1 * SignedData2;
            hi = shi_tmp;
            lo = slo_tmp;
        end
        else if(func == 6'b011011) begin //div
            hi = SignedData1 / SignedData2;
            lo = SignedData1 % SignedData2;
        end
	end

	else if(opcode == 6'b001001)begin
		ALUResult = ReadData1 + immediateSE; //ADDIU
	end	
	
	else if(opcode == 6'b100011 || opcode == 6'b101011)begin
		ALUResult = (ReadData1 + immediateSE);//LW and SW
		ALUResult[1:0] = 2'b0;
		byteenable = 4'b1111;
	end
	
	else if(opcode == 6'b001111)begin
		ALUResult = {immediate, 16'b0}; //LUI	
	end

	else if(opcode == 6'b001010)begin
        SignedData1 = ReadData1;
        SignedData2 = immediateSE;
		ALUResult = (SignedData1 < SignedData2) ? 1 : 0; //SLTI
	end
	
	else if(opcode == 6'b001011)begin
		ALUResult = (ReadData1 < immediateZE) ? 1 : 0; //SLTIU
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
		ALUResult = ReadData1 + immediateSE; //LB, LBU, SB
		ALUResult[1:0] = 2'b0;		
		case(Byteneeded)
			0: byteenable = 4'b0001;
			1: byteenable = 4'b0010;
			2: byteenable = 4'b0100;
			3: byteenable = 4'b1000;
		endcase
	end
	else if(opcode == 6'b100001 || opcode == 6'b101001 || opcode == 6'b100101) begin
		ALUResult = ReadData1 + immediateSE; //LH, LHU, SH
		ALUResult[1:0] = 2'b0;
		case(Byteneeded)
			0: byteenable = 4'b0011;
            		1: byteenable = 4'b0110;
			2: byteenable = 4'b1100;
		endcase
	end
	else if(opcode == 6'b100110)begin
		ALUResult = ReadData1 + immediateSE; //LWR
		ALUResult[1:0] = 2'b0;
		case(Byteneeded)
			0: byteenable = 4'b0001;
			1: byteenable = 4'b0011;
			2: byteenable = 4'b0111;
			3: byteenable = 4'b1111;
		endcase
	end
	else if(opcode == 6'b100010)begin
		ALUResult = ReadData1 + immediateSE; //LWL
		ALUResult[1:0] =2'b0;
		case(Byteneeded)
			0: byteenable = 4'b1111;
			1: byteenable = 4'b1110;
			2: byteenable = 4'b1100;
			3: byteenable = 4'b1000;
		endcase
	end
end


endmodule