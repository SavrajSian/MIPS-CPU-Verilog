module control_signals(
    input logic [31:0] inst,
    input logic end_of_inst_reg,
    input logic waitrequest,
    input logic clk,
    input logic reset,
    input logic end_j,
    input logic end_of_inst_store,
    output logic MemRead,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegDest,
    output logic RegWrite,
    output logic PCSrc,
    output logic MemtoReg,
    output logic endi,
    output logic JRcontrol
);

logic [2:0] i_type;
logic [5:0] op; 
logic [3:0] jmp;


assign jmp = inst[3:0];
assign op = inst[31:26];
assign i_type = inst[31:29];
assign endi = end_of_inst_store || end_of_inst_reg || end_j;    

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
    else if (op==0 && jmp==8) begin
        JRcontrol = 1;
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

endmodule