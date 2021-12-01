module sign_extend_tb();
	logic [15:0] instr_16;
	logic [31:0] instr_32;

	sign_extend dut(
		.instr_16(instr_16),
		.instr_32(instr_32)
	);

	initial begin
		instr_16 = 1000111100001111;
		$display("instr_16=%b, instr_32=%b", instr_16, instr_32);
	end
endmodule
