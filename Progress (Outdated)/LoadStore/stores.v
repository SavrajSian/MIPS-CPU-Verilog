module stores(
	input logic[31:0] Read_data_b,
	input logic[31:0] instruction,
	output logic[31:0] write_data,
	input logic[3:0] byteenable
);

logic[2:0] opcode;
logic[7:0] LB_read_data_b;
logic[15:8] LB2_read_data_b;
logic[23:16] LB3_read_data_b;
logic[31:24] LB4_read_data_b;

assign opcode = instruction[28:26];
assign LB_read_data_b = Read_data_b[7:0];
assign LB2_read_data_b = Read_data_b[15:8];
assign LB3_read_data_b = Read_data_b[23:16];
assign LB4_read_data_b = Read_data_b[31:24];

always_comb begin
	case(opcode)
		3'b001: write_data = (byteenable==4'b1100)?{{LB_read_data_b, LB2_read_data_b}, 16'h0}:{16'h0, {LB_read_data_b, LB2_read_data_b}};//Endianess conversion
		3'b011: write_data = {LB_read_data_b, LB2_read_data_b, LB3_read_data_b, LB4_read_data_b}; //endian converted
	endcase
	if(opcode == 3'b000)begin
		case(byteenable)
			4'b0001: write_data = {24'b0,LB_read_data_b}; //endian converted
			4'b0010: write_data = {16'b0,LB_read_data_b, 8'b0};
			4'b0100: write_data = {8'b0,LB_read_data_b, 16'b0};
			4'b1000: write_data = {LB_read_data_b, 24'b0};
		endcase
	end
end

endmodule