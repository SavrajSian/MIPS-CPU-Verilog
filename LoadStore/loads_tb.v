module loads_tb();

logic[31:0] mem_in;
logic[31:0] mem_out;
logic[31:0] instruction;
logic[3:0] byteenable;

loads dut(.mem_in(mem_in), .mem_out(mem_out), .instruction(instruction), .byteenable(byteenable));

initial begin
	mem_in = 32'h00FF00FF;
	instruction = 32'h90000000;
	byteenable = 4'b0100;
	#10;
	$display("byte out is %b", mem_out);
	assert(mem_out == 32'h000000FF);	
	
	mem_in = 32'h08E2F305;
	instruction = 32'h80000000;
	byteenable = 4'b0010;
	#10;
	$display("byte out is %b", mem_out);
    assert(mem_out == 32'hFFFFFFF3);

	mem_in = 32'h8F4C29E7;
	instruction = 32'h8C000000;
	byteenable = 4'b1111;
	#10;
	$display("word out is %b", mem_out);
	assert(mem_out == 32'h8F4C29E7);
end

endmodule
