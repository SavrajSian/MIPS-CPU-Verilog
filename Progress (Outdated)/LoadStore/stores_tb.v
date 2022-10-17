module stores_tb();

logic[31:0] Read_data_b;
logic[31:0] instruction;
logic[31:0] write_data;
logic[3:0] byteenable;


initial begin
	Read_data_b = 32'hF3C8E52D; //SW
	instruction = 32'hAC000000;
	byteenable = 4'b1111;
	#10;
	$display("data to be stored: %h", write_data);
	assert(write_data == 32'h2DE5C8F3);
	
	Read_data_b = 32'hF3C8E52D; //SB
	instruction = 32'hA0000000;
	byteenable = 4'b0100;
	#10;
	$display("data to be stored: %h", write_data);
	assert(write_data == 32'h002D0000);
	
	Read_data_b = 32'h4502d22f; //SH
	instruction = 32'hA4000000;
	byteenable = 4'b1100;
	#10;
	$display("data to be stored: %h", write_data);
	assert(write_data == 32'h2fd20000);
	
	Read_data_b = 32'h01020304;
	instruction = 32'hAC000000;
	byteenable = 4'b1111;
	#10;
	$display("initial data from reg: 32'h01020304");
	$display("data to be stored: %h", write_data);
	$display("Data in memory now 32'h01020304");
	assert(write_data == 32'h04030201);
	
	Read_data_b = 32'h01020304;
	instruction = 32'hA4000000;
	byteenable = 4'b1100;
	#10;
	$display("initial data from reg: 32'h12330304");
	$display("data to be stored: %h", write_data);
	$display("Data in memory now 32'hXXXX0304");
	assert(write_data == 32'h04030000);
end

stores dut(.Read_data_b(Read_data_b), .instruction(instruction), .write_data(write_data), .byteenable(byteenable));

endmodule