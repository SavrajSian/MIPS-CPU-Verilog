module loads(
	input logic[31:0] mem_in,  //data from memory
	output logic[31:0] byteout,  //correct ZE or SE byte out -> regfile 
	input logic[31:0] instruction, // to identify lbu vs lb etc.
	input logic[1:0] byteneeded // which byte to take from floored memory word
);

logic[7:0] bytetmp;
logic[31:0] byteSE;
logic[31:0] byteZE;
logic sel;
logic msb;
assign sel = instruction[28];	
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
	case(byteneeded)
		0: bytetmp = mem0byte;
		1: bytetmp = mem1byte;
		2: bytetmp = mem2byte;
		3: bytetmp = mem3byte;
	endcase
	if(msb==1)begin
		byteSE = {24'hFFFFFF, bytetmp};
	end
	else begin
		byteSE = {24'b0, bytetmp};
	end
	byteZE = {24'b0, bytetmp};
	if(sel == 1) begin
		byteout = byteZE;
	end
	else begin
		byteout = byteSE;
	end
end

endmodule

