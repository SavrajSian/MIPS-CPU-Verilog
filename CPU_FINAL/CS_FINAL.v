module control_signals(
    input logic [31:0] inst,
    input logic end_of_inst_reg,
    input logic waitrequest,
    input logic clk,
    input logic reset,
    input logic end_j,
    input logic end_of_inst_store,
    input logic[31:0] readdata1,
    input logic[31:0] readdata2,
    output logic MemRead,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegDest,
    output logic RegWrite,
    output logic MemtoReg,
    output logic endi,
    output logic jrtrue,
    output logic jumptrue,
    output logic branchtrue,
    output logic jalr,
    output logic link,
    output logic halt
);

logic [2:0] i_type;
logic [5:0] op; 
logic [3:0] jmp;
logic [5:0] branchbits;
logic rd1bit15;
////Maybe get rid of following control sigs


assign jmp = inst[3:0];
assign op = inst[31:26];
assign i_type = inst[31:29];
assign rd1bit15 = readdata1[15];
assign endi = end_of_inst_store || end_of_inst_reg || end_j;   
assign halt = end_of_inst_store || end_of_inst_reg;
assign branchbits = inst[20:16]; 

always_comb begin 
	if(op == 6'b000010) begin //J
		jumptrue = 1;
        link = 0;
        branchtrue = 0;
        jrtrue =0;
        jalr = 0;
	end
	
	else if(op == 6'b000011) begin //JAL
		link = 1;
		jumptrue = 1;
        jalr = 0;
        branchtrue = 0;
        jrtrue = 0;
	end
	
    else if(op==0 && jmp==8) begin //JR
        jrtrue = 1;
        jalr = 0;
        branchtrue = 0;
        jumptrue = 0;
        link = 0;
    end

    else if(op == 0 && jmp == 9) begin //JALR
		link = 1;
		jrtrue = 1;
        jalr = 1;
        jumptrue = 0;
        branchtrue = 0;
	end
	else if(op == 6'b000100) begin //BEQ
		branchtrue = (readdata1 == readdata2) ? 1:0; 
		jumptrue = 0;
        jalr = 0;
		jrtrue = 0;
		link = 0;
	end
	
	else if(op == 6'b000001 && branchbits == 5'b00001) begin //BGEZ
		jumptrue = 0;
        jalr = 0;
		jrtrue = 0;
		link = 0;
		branchtrue = (rd1bit15 == 0) ? 1:0;
	end
	
	else if(op == 6'b000001 && branchbits == 5'b10001) begin //BGEZAL
		branchtrue = (rd1bit15 == 0) ? 1:0;
        link = 1;
        jumptrue = 0;
        jalr = 0;
        jrtrue = 0;
	end
	
	else if(op == 6'b000111 && branchbits == 0) begin //BGTZ
		branchtrue = (rd1bit15 == 0 && readdata1 != 0) ? 1:0;
        jumptrue = 0;
        jalr = 0;
        jrtrue = 0;
        link = 0;
	end
	
	else if(op == 6'b000110 && branchbits == 0) begin //BLEZ
		branchtrue = (rd1bit15 == 1 || readdata1 == 0) ? 1:0; 
        jumptrue = 0;
        jalr = 0;
        jrtrue = 0;
        link = 0;
	end
	
	else if(op == 6'b000001 && branchbits == 0) begin //BLTZ
		branchtrue = (rd1bit15 == 1) ? 1:0;
		jumptrue = 0;
        jalr = 0;
		jrtrue = 0;
        link = 0;
	end
	
	else if(op == 6'b000001 && branchbits == 5'b10000) begin //BLTZAL
		branchtrue = (rd1bit15 == 1) ? 1:0;
        jumptrue = 0;
        jalr = 0;
        jrtrue = 0;
        link = 1;
	end
	
	else if(op == 6'b000101) begin //BNE
		branchtrue = (readdata1 != readdata2) ? 1:0; 
        jumptrue = 0;
        jalr = 0;
        jrtrue = 0;
        link = 0;
	end

	else begin
		branchtrue = 0;
		jumptrue = 0;
        jalr = 0;
		jrtrue = 0;
		link = 0;
	end
end


always_comb begin
	if (reset==1) begin
		MemRead = 0;
		MemWrite = 0;
		ALUSrc = 0;
		RegDest = 1;
		RegWrite = 0;
		MemtoReg = 0;
        branchtrue = 0;
		jumptrue = 0;
		jrtrue = 0;
		link = 0;
	end
    else if (i_type==3'b100) begin //All loads follow this struct
        MemRead = 1;
        ALUSrc = 1;
        RegWrite = 1;
        MemtoReg = 1;
        MemWrite = 0;
        RegDest = 0;
    end
    else if (i_type==6'b101) begin //StoreWord
        MemRead = 0;
        ALUSrc = 1;
        RegWrite = 0;
        MemWrite = 1;
    end
    else if (jrtrue == 1||jumptrue == 1||branchtrue == 1) begin //JR    JALR uses same jump dest
        MemRead = 0;
        MemWrite = 0;
        RegWrite = (link == 1) ? 1:0;
        ALUSrc = 0;
        MemtoReg = 0;
        RegDest = 1;
    end

    else if (op==6'b000000 || i_type==001) begin //R or I-type
        MemRead = 0;
        ALUSrc = 0;
        RegWrite = 1;
        MemtoReg = 0;
        RegDest = (op==6'b000000)?1:0;
        MemWrite = 0;
    end
    
end
	

endmodule
