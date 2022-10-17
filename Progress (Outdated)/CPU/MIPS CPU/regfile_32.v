module regfile(
    input logic clk,
    input logic reset,
    input logic reg_dst,
    input logic valid_read,
    input logic valid_write,
    input logic[31:0] Instruction,
    input logic[31:0] WriteData,
    input logic W_en,
	input logic active,
    output logic end_instr,
    output logic[31:0] ReadData1,
    output logic[31:0] ReadData2,
    output logic[31:0] reg_out[4:0]
);

logic[31:0] regs[32:0];
logic[4:0] read_addr_1;
logic[4:0] read_addr_2;
logic[4:0] write_addr;

assign read_addr_1 = Instruction[25:21];
assign read_addr_2 = Instruction[20:16];
assign write_addr = reg_dst == 1 ? Instruction[15:11]:Instruction[20:16];



always_ff @(posedge clk) begin
	if (active != 1) begin
		if (reset == 1) begin
			for (integer idx = 0; idx<32; idx=idx+1) begin
				regs[idx]<=0;
			end
		end
		if (valid_read==1) begin
			ReadData1 <= regs[read_addr_1];
			ReadData2 <= regs[read_addr_2];
		end
		if ((W_en == 1)&(valid_write==1)) begin
			regs[write_addr]<= WriteData;
			end_instr<=1; //added end_instr signal output to go into PC asking to fetch next instruction.
		end
	end
end
endmodule