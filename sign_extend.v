module sign_extend(
	input logic signed [15:0] instr_16,
	output logic signed[31:0] instr_32
);
	assign instr_32 = instr_16;
endmodule
