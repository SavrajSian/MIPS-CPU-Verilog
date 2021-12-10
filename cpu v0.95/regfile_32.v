module regfile(
    input logic clk,
    input logic reset,
	input logic fetch,
    input logic reg_dst,
    input logic valid_read,
    input logic valid_write,
    input logic[31:0] Instruction,
    input logic[31:0] WriteData,
    input logic W_en,
	input logic active,
    output logic end_instr_reg,
	output logic v_read,
    output logic[31:0] ReadData1,
    output logic[31:0] ReadData2
);

logic[31:0] regs[31:0];
logic[4:0] read_addr_1;
logic[4:0] read_addr_2;
logic[4:0] write_addr;

assign read_addr_1 = Instruction[25:21];
assign read_addr_2 = Instruction[20:16];
assign write_addr = reg_dst == 1 ? Instruction[15:11]:Instruction[20:16];

always_comb begin
	if (reset == 1) begin
		for (integer idx = 0; idx<32; idx=idx+1) begin
			regs[idx]=0;
			end_instr_reg = 1;
		end
		v_read = 0;
	end
	
end

always_ff @(posedge clk) begin
	
	if ((W_en == 1)&(valid_write==1)) begin    
		regs[write_addr]<= WriteData;
		end_instr_reg<=1; //added end_instr signal output to go into PC asking to fetch next instruction.
		v_read<=0;
	end
	else if (active == 1) begin
		if (valid_read==1) begin
			ReadData1 <= regs[read_addr_1];
			ReadData2 <= regs[read_addr_2];
			if (regs[read_addr_1]>=0) begin
				v_read<=1;
				end_instr_reg<=0;
			end
			else begin
				v_read<=0;
			end
		end	
	end
end
endmodule