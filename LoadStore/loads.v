module loads(
	input logic[31:0] mem_in,  //data from memory
	output logic[31:0] mem_out,  //correct ZE or SE byte out -> regfile 
	input logic[31:0] instruction, // to identify lbu vs lb etc.
	input logic[3:0] byteenable // which byte to take from memory word
);

logic[2:0] opcode;
assign opcode = instruction[28:26];
logic[7:0] bytetmp;
logic msb;	
assign msb = bytetmp[7];

logic[7:0] mem0byte;
logic[7:0] mem1byte;
logic[7:0] mem2byte;
logic[7:0] mem3byte;
assign mem0byte = mem_in[7:0];
assign mem1byte = mem_in[15:8];
assign mem2byte = mem_in[23:16];
assign mem3byte = mem_in[31:24];


always_comb begin	
	if(byteenable != 4'b1111)begin
		case(byteenable)
			4'b0001: bytetmp = mem0byte;
			4'b0010: bytetmp = mem1byte;
			4'b0100: bytetmp = mem2byte;
			4'b1000: bytetmp = mem3byte;
		endcase
		mem_out = (msb==1 && opcode==3'b000)?{24'hFFFFFF, bytetmp}:{24'b0, bytetmp};
	end
	else begin
		mem_out = mem_in;
	end
end

endmodule

