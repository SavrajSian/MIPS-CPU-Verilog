module loads_tb();

logic[31:0] mem_in;
logic[31:0] byteout;
logic[31:0] instruction;
logic[1:0] byteneeded;

loads dut(.mem_in(mem_in), .byteout(byteout), .instruction(instruction), .byteneeded(byteneeded));

initial begin
	mem_in = 32'h00FF00FF;
	instruction = 32'h90000000;
	byteneeded = 2;
	#10;
	$display("byte out is %b", byteout);
	assert(byteout == 32'h000000FF);	
	
	mem_in = 32'h08E2F305;
	instruction = 32'h80000000;
	byteneeded = 1;
	#10;
	$display("byte out is %b", byteout);
        assert(byteout == 32'hFFFFFFF3);	
end

endmodule
