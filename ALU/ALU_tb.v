module ALU_tb();

logic[31:0] instruction;
logic[31:0] ReadData1;
logic reset;
logic[31:0] ReadData2;
logic[31:0] ALUResult;

initial begin
	$dumpfile("ALU_tb_waves.vcd");
	$dumpvars(0, ALU_tb);
	
	ReadData1 = 30;
	ReadData2 = 50;
	instruction = 32'h014B4820;
	#1;
	assert(ALUResult==80);
	
	ReadData1 = 20;
	instruction = 32'h21490014;
	#1;
	assert(ALUResult==40);

	ReadData1 = 60;
	instruction=32'h8D49001E;
	#1;
	assert(ALUResult ==90);
end

ALU dut(.instruction(instruction), .ReadData1(ReadData1), .reset(reset), .ReadData2(ReadData2), .ALUResult(ALUResult));


endmodule
