module stores_tb();

logic[31:0] Read_data_b;
logic[31:0] instruction;
logic[31:0] write_data;


initial begin
	Read_data_b = 32'hF3C8E52D;
	instruction = 32'hAC000000; //sw
	#10;
	$display("Readdatain: %b", Read_data_b);
	$display("opcode: %b", instruction[28:26]);
	$display("data to be stored: %b", write_data);
	assert(write_data == 32'hF3C8E52D);
	
	Read_data_b = 32'hF3C8E52D;
	instruction = 32'hA0000000;  //sb
	#10;
	$display("Readdatain: %b", Read_data_b);
	$display("opcode: %b", instruction[28:26]);
	$display("data to be stored: %b", write_data);
	assert(write_data == 32'h0000002D);

	Read_data_b = 32'h12345678;
	instruction = 32'hAC000000; //sw
	#10;
	$display("Readdatain: %b", Read_data_b);
	$display("opcode: %b", instruction[28:26]);
	$display("data to be stored: %b", write_data);
	assert(write_data == 32'h12345678);
	
	Read_data_b = 32'h12345678;
	instruction = 32'hA0000000;  //sb
	#10;
	$display("Readdatain: %b", Read_data_b);
	$display("opcode: %b", instruction[28:26]);
	$display("data to be stored: %b", write_data);
	assert(write_data == 32'h00000078);

end

stores dut(.Read_data_b(Read_data_b), .instruction(instruction), .write_data(write_data));

endmodule
