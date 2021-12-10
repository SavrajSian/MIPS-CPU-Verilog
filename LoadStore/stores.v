module stores(
	input logic[31:0] Read_data_b,
	input logic[31:0] instruction,
	output logic[31:0] write_data
);

logic[2:0] opcode;
logic[7:0] LB_read_data_b;
assign opcode = instruction[28:26];
assign LB_read_data_b = Read_data_b[7:0];

always_comb begin
	case(opcode)
		3'b011: write_data = Read_data_b;
		3'b000: write_data = {24'b0,LB_read_data_b};
	endcase
end

endmodule