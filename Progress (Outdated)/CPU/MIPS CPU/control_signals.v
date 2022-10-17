module control_signals(
    input logic [31:0] inst,
    input logic end_of_inst_reg,
    input logic end_of_inst_store,
    input logic clk,
    input logic reset,
    output logic MemRead,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegDest,
    output logic RegWrite,
    output logic PCSrc,
    output logic MemtoReg,
    output logic fetch,
    output logic JRcontrol
);

logic [2:0] l_s = inst[31:29];
logic [5:0] op = inst[31:25];
logic [3:0] jmp = inst[3:0];

always@* begin
	if (reset==0) begin
		assign MemRead = 0;
		assign MemWrite = 0;
		assign ALUSrc = 0;
		assign RegDest = 0;
		assign RegWrite = 0;
		assign PCSrc = 0;
		assign MemtoReg = 0;
		assign fetch = 0;
		assign JRcontrol = 0;
	end
end

always_comb begin
    if (l_s==3'b100) begin //All loads follow this struct
        MemRead = 1;
        ALUSrc = 1;
        RegWrite = 1;
        MemtoReg = 1;
        MemWrite = 0;
        RegDest = 0;
        fetch = (end_of_inst_reg==1) ? 1:0;
    end
    else if (op==6'b101011) begin //StoreWord
        MemRead = 0;
        ALUSrc = 1;
        RegWrite = 0;
        MemWrite = 1;
    end
    else if (op==6'b000000 || l_s==001) begin //R or I-type
        MemRead = 0;
        ALUSrc = 0;
        RegWrite = 1;
        MemtoReg = 0;
        RegDest = 1;
        MemWrite = 0;
        fetch = (end_of_inst_reg==1) ? 1:0;
    end
    else if (op==0 && jmp==8) begin
        JRcontrol = 1;
        MemRead = 0;
        MemWrite = 0;
        RegWrite = 0;
        ALUSrc = 0;
    end
end

always_ff @(negedge end_of_inst_store) begin
    if (op==6'b101011) begin
        fetch <= 1;
    end
end

always_ff @(posedge clk) begin 
    if (op==0 && jmp==8) begin
        fetch <= 1;
    end
end 

endmodule