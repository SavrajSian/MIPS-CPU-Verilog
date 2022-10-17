module registers(
	input logic clk, 
	input logic write_en,
	input logic[4:0] read_reg1, 
	input logic[4:0] read_reg2,
	input logic[4:0] write_reg,
	input logic[31:0] write_data,
	output logic[31:0] data_out1,
	output logic[31:0] data_out2
);

logic[31:0] regs[4:0];


always_ff @(posedge clk)begin 
	data_out1 <= regs[read_reg1];
	data_out2 <= regs[read_reg2];
	if (write_en==1) begin
		regs[write_reg] <= write_data;
	end
	
end
    
endmodule