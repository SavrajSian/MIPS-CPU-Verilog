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
    output logic PCSrc,
    output logic MemtoReg,
    output logic endi,
    output logic jrtrue,
    output logic jumptrue,
    output logic branchtrue,
    output logic truejump
);

logic [2:0] i_type;
logic [5:0] op; 
logic [3:0] jmp;
logic [5:0] branchbits;
////Maybe get rid of following control sigs
logic jumptrue;
logic branchtrue;
logic jrtrue;
logic link; 


assign jmp = inst[3:0];
assign op = inst[31:26];
assign i_type = inst[31:29];
assign endi = end_of_inst_store || end_of_inst_reg || end_j;   
assign branchbits = inst[20:16]; 

always_comb begin //
	////Jcontrol DONE IN BOTTOM COMB BLOCK
	//if(op == 6'b000010) begin //J
	//	Jcontrol = 1;
	//end
	
	else if(op == 6'b000011) begin //JAL
		link = 1;
		jumptrue = 1;
	end
	
		
	else if(op == 0 && jumpbits == 6'b001001) begin //JALR
		link = 1;
		jrtrue;
	end
	////JRcontrol DONE IN BOTTOM COMB BLOCK
	//else if(op == 0 && jumpbits == 6'b001000) begin 
	//	JRcontrol = 1;
	//end

	if(op = 6'b000100) begin //BEQ
		if(readdata1 == readdata2) begin
			branchtrue = 1;
		end
	end
	
	else if(op = 6'b000001 && branchbits = 5'b00001) begin //BGEZ
		jumptrue = 0;
		jrtrue = 0;
		link = 0;
		if(readdata1 >= 0) begin
			branchtrue = 1;
		end
	end
	
	else if(op = 6'b000001 && branchbits = 5'b10001) begin //BGEZAL
		if(readdata1 => 0) begin
			branchtrue = 1;
			link = 1;
			jumptrue = 0;
			jrtrue = 0;
		end
	end
	
	else if(op = 6'b000111 && branchbits == 0) begin //BGTZ
		if(readdata1 > 0) begin
			branchtrue = 1;
			jumptrue = 0;
			jrtrue = 0;
			link = 0;
		end
	end
	
	else if(op = 6'b000110 && branchbits == 0) begin //BLEZ
		if(readdata1 <= 0) begin
			branchtrue = 1;
			jumptrue = 0;
			jrtrue = 0;
			link = 0;
		end
	end
	
	else if(op = 6'b000001 && branchbits == 0) begin //BLTZ
		if(readdata1 < 0) begin
			branchtrue = 1;
			jumptrue = 0;
			jrtrue = 0;
			link = 0;
		end
	end
	
	else if(op = 6'b000001 && branchbits = 5'b10000) begin //BLTZAL
		if(readdata1 < 0) begin
			branchtrue = 1;
			jumptrue = 0;
			jrtrue = 0;
			link = 0;
		end
	end
	
	else if(op = 6'b000101) begin //BNE
		if(readdata1 != readdata2) begin
			branchtrue = 1;
			jumptrue = 0;
			jrtrue = 0;
			link = 0;
		end
	end
	else begin
		branchtrue = 0;
		jumptrue = 0;
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
		PCSrc = 0;
		MemtoReg = 0;
		JRcontrol = 0;
	end
    else if (i_type==3'b100) begin //All loads follow this struct
        MemRead = 1;
        JRcontrol = 0;
        ALUSrc = 1;
        RegWrite = 1;
        MemtoReg = 1;
        MemWrite = 0;
        RegDest = 0;
    end
    else if (op==6'b101011) begin //StoreWord
        MemRead = 0;
        ALUSrc = 1;
        RegWrite = 0;
        MemWrite = 1;
        JRcontrol = 0;
    end
    else if (op==0 && jmp==8) begin //JR    JALR uses same jump dest
        JRcontrol = 1;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 0;
        ALUSrc = 0;
    end
    else if(op == 6'b000010) begin //J    JAL uses same jump dest
    	Jcontrol = 1;
    	MemRead = 0;
        MemWrite = 0;
        RegWrite = 0;
        ALUSrc = 0;
	end
	else if(op = 6'b000100 || op = 6'b000001 && branchbits = 5'b00001 || op = 6'b000001 && branchbits = 5'b10001 || op = 6'b000111 && branchbits == 0 || op = 6'b000110 && branchbits == 0 || op = 6'b000001 && branchbits == 0 || op = 6'b000001 && branchbits = 5'b10000 || op = 6'b000101) begin //Branches
		BRANCH = 1;
		MemRead = 0;
        MemWrite = 0;
        RegWrite = 0;
        ALUSrc = 0;
    end
		
		

    else if (op==6'b000000 || i_type==001) begin //R or I-type
        MemRead = 0;
        JRcontrol = 0;
        ALUSrc = 0;
        RegWrite = 1;
        MemtoReg = 0;
        RegDest = (op==6'b000000)?1:0;
        MemWrite = 0;
    end
    
end



always_comb begin
	

endmodule
