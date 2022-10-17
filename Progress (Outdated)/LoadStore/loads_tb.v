module loads_tb();

logic[31:0] mem_in;
logic[31:0] mem_out;
logic[31:0] instruction;
logic[3:0] byteenable;

loads dut(.mem_in(mem_in), .mem_out(mem_out), .instruction(instruction), .byteenable(byteenable));

initial begin
	
	mem_in = 32'h00FF00FF; //LBU
	instruction = 32'h90000000;
	byteenable = 4'b0100;
	#10;
	$display("Unsigned byte out is %h", mem_out);
	assert(mem_out == 32'h00000000);	
	
	mem_in = 32'h08E2F305; //LB
	instruction = 32'h80000000;
	byteenable = 4'b0010;
	#10;
	$display("Signed byte out is %h", mem_out);
    assert(mem_out == 32'hFFFFFFE2);

	mem_in = 32'h8F4C29E7; //LW
	instruction = 32'h8C000000;
	byteenable = 4'b1111;
	#10;
	$display("word out is %h", mem_out);
	assert(mem_out == 32'hE7294C8F);
	
	mem_in = 32'h25B04457; //LH (Left half)
	instruction = 32'h84000000;
	byteenable = 4'b1100;
	#10;
	$display("half word out is %h", mem_out);
	assert(mem_out == 32'h00005744);
	
	mem_in = 32'h95B08457; //LH (Right half)
	instruction = 32'h84000000;
	byteenable = 4'b0011;
	#10;
	$display("half word out is %h", mem_out);
	assert(mem_out == 32'hFFFF95B0);
	
	mem_in = 32'h85B04457; //LHU (Left half)
	instruction = 32'h94000000;
	byteenable = 4'b1100;
	#10;
	$display("Unsigned half word out is %h", mem_out);
	assert(mem_out == 32'h00005744);
	
	mem_in = 32'h95B08457; //LHU (Right half)
	instruction = 32'h94000000;
	byteenable = 4'b0011;
	#10;
	$display("Unsigned half word out is %h", mem_out);
	assert(mem_out == 32'h000095B0);
	
	mem_in = 32'h04030201;
	instruction = 32'h8C000000;
	byteenable = 4'b1111;
	#10;
	$display("word out into reg is %h", mem_out);
	assert(mem_out == 32'h01020304);
	
	mem_in = 32'h04030000;
	instruction = 32'h84000000;
	byteenable = 4'b1100;
	#10;
	$display("word out into reg is %h", mem_out);
	assert(mem_out == 32'h00000304);
	
end

endmodule
