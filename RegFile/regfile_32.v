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
	input logic byteenable,
    output logic end_instr_reg,
	output logic v_read,
    output logic[31:0] ReadData1,
    output logic[31:0] ReadData2
	output logic[31:0] registerv0
);

logic[31:0] regs[31:0];
logic[4:0] read_addr_1;
logic[4:0] read_addr_2;
logic[4:0] write_addr;
logic[31:0] regval;

assign read_addr_1 = Instruction[25:21];
assign read_addr_2 = Instruction[20:16];
assign write_addr = reg_dst == 1 ? Instruction[15:11]:Instruction[20:16];
assign registerv0 = regs[2]; 
assign regval = regs[write_addr];

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
		if (write_addr != 0) begin
			if(instruction[31:26] == 6'b100110 || instruction[31:26] == 6'b100010)begin
				case(byteenable)
					4'b1000: regs[write_addr] <= {WriteData[7:0], regval[24:0]};
					4'b1100: regs[write_addr] <= {WriteData[15:0], regval[15:0]};
					4'b1110: regs[write_addr] <= {WriteData[23:0], regval[7:0]};
					4'b0001: regs[write_addr] <= {regval[31:8], WriteData[7:0]};
					4'b0011: regs[write_addr] <= {regval[31:16], WriteData[15:0]};
					4'b0111: regs[write_addr] <= {regval[31:24] ,WriteData[23:0]};
					4'b1111: regs[write_addr] <= WriteData;
				endcase
			end
			else begin
				regs[write_addr]<= WriteData;
				end_instr_reg<=1; //added end_instr signal output to go into PC asking to fetch next instruction.
				v_read<=0;
			end
		end
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
		else begin 
			v_read<=0;
		end	
	end
end
endmodule