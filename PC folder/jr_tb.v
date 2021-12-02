module jr_tb();

logic clk;
logic reset;
logic JRcontrol;
logic Jump;
logic Branch;
logic[31:0] jumpaddr;
logic[31:0] pc;

initial begin
	$dumpfile("jr_tb_waves.vcd");
        $dumpvars(0, jr_tb);
end

initial begin
	clk=0;
	repeat(100) begin
		#5;
		clk=!clk;
	end
	$finish(0);
end

initial begin
	reset = 0;
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

PCtoplevel dut(.clk(clk), .reset(reset), .JRcontrol(JRcontrol), .Jump(Jump), .Branch(Branch), .jumpaddr(jumpaddr), .pc(pc));




endmodule

