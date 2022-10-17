module cpu_tb(
);

//to compile run: iverilog -Wall -g 2012 -s cpu_tb -o cpu_tb alu.v cpu_tb.v PCtoplevel.v PC.v jumpbranchcontrol.v regfile_32.v


logic clk;
logic resetalu, resetmem, resetpc;
logic[64][31:0] mem;

logic zero;
logic[4:0] control;
logic[5:0] sa;
logic[31:0] a, b, result, imm;

logic JRcontrol, Jump, Branch;
logic[31:0] jumpaddr, pc;

logic reg_dst, valid, W_en, end_instr;
logic[31:0] Instruction, WriteData, ReadData1, ReadData2;


initial begin
	clk = 0;
	repeat (2000) begin
		clk = !clk;
		#5;
	end
end



initial begin
	a = 1;
	b = 1;
	imm = 1;
	
repeat (100) begin
//add
	control = 1;
	assert(result == a+b);
	a <= a + 2;
	b <= b + 3;
//addi
	control = 0;
	assert(result == a+imm);
	imm <= imm +4;
end
end


/*
initial begin
	valid = 1;
//store & load
	Instruction = //add instr
	#5
	W_en = 1
	Instruction = //add intstr
	assert(ReadData1==//add data)

end
*/

//jump

initial begin
	resetpc = 0;
	JRcontrol = 0;
	Jump = 0;
	Branch = 0;
	jumpaddr = 0;
	@(posedge clk);
	#1;
	assert(pc == 4);
	@(posedge clk);
	#1;
	assert(pc == 8);
	@(posedge clk);
	#1;
	assert(pc ==12);
	JRcontrol = 1;
	jumpaddr = 24;
	@(posedge clk);
	#1;
	assert(pc ==24);
	@(posedge clk);
	#1;
	assert(pc ==28);
end


ALU alu(
	.reset(resetalu),
	.a(a),
	.b(b),
	.immediate(imm),
	.sa(sa),
	.control(control),
	.r(result),
	.zero(zero)
);

PCtoplevel PC(
	.clk(clk),
	.reset(resetpc),
	.JRcontrol(JRcontrol),
	.Jump(Jump),
	.Branch(Branch),
	.jumpaddr(jumpaddr),
	.pc(pc)
);

regfile regf(
	.clk(clk),
	.reset(resetmem),
	.reg_dst(reg_dst),
	.valid(valid),
	.Instruction(Instruction),
	.WriteData(WriteData),
	.W_en(W_en),
	.end_instr(end_instr),
	.ReadData1(ReadData1),
	.ReadData2(ReadData2)
);


endmodule