module ALU_tb();

logic[31:0] instruction;
logic[31:0] ReadData1;
logic reset;
logic[31:0] ReadData2;
logic[31:0] ALUResult;
logic[3:0] byteenable;

ALU dut(.instruction(instruction), .ReadData1(ReadData1), .reset(reset), .ReadData2(ReadData2), .ALUResult(ALUResult), .byteenable(byteenable));

initial begin
	instruction = 32'h80000006; //immediate 6
	ReadData1 = 0;
	reset = 0;
	ReadData2 = 6;
	#10;
	assert(ALUResult == 4);
	assert(byteenable == 4'b0100);
	$display("LOAD BYTE: Getting byte %b from address %d", byteenable, ALUResult);
	
	instruction = 32'h90000012; //immediate 18
	ReadData1 = 5;
	reset = 0;
	ReadData2 = 18;
	#10;
	assert(ALUResult == 20);
	assert(byteenable == 4'b1000);
	$display("LOAD BYTE UNSIGNED: Getting byte %b from address %d", byteenable, ALUResult);
	
	instruction = 32'h8C000011; //immediate 17
	ReadData1 = 7;
	reset = 0;
	ReadData2 = 17;
	#10;
	assert(ALUResult == 24);
	assert(byteenable == 4'b1111);
	$display("LOAD WORD: Getting word from address %d", ALUResult);
	
	instruction = 32'hA000001D; //immediate 29
	ReadData1 = 20;
	reset = 0;
	ReadData2 = 29;
	#10;
	assert(ALUResult == 48);
	assert(byteenable == 4'b0010);
	$display("STORE BYTE: Storing into byte %b in address %d", byteenable, ALUResult);
	
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

endmodule
