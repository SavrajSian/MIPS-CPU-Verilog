module top_level_cpu(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    output logic[3:0] byteenable,
    input logic[31:0] readdata
);

logic[31:0] instr;
logic[31:0] inst_addr;
logic[31:0] addr;
logic[31:0] data_reg_a;
logic[31:0] data_reg_b;
logic data_read;
logic valid_read;
logic valid_write;
logic end_of_inst_reg;
logic end_of_store;
logic MemRead;
logic MemWrite;
logic ALUSrc;
logic RegDest;
logic RegWrite;
logic MemtoReg;
logic fetch;
logic v_read;
logic endi;
logic end_ctrl;
logic end_j;
logic v_load;
logic jumptrue;
logic jrtrue;
logic branchtrue;
logic link;
logic jalr;
logic halt;
logic[31:0] reg_data_in;
logic[31:0] alu_data;
logic[3:0] byteenablet;
logic[31:0] linkaddr;
logic[31:0] loaddata;

always_comb begin
    byteenable = byteenablet;
    addr = (fetch==1)?inst_addr:alu_data;
    address = addr;
    read = data_read ||fetch;
    if (reset == 1) begin
        active = 1;
    end
	if (inst_addr == 4 && halt == 1) begin
		active = 0;
	end
end
always_ff @(negedge clk) begin
    fetch = (end_ctrl==1)?endi:end_ctrl;
end
always_ff @(posedge clk) begin
	v_load <= v_read;
end



PC pc_dut(
    .active(active),
    .clk(clk),
    .fetch(fetch),
    .reset(reset),
    .instruction(instr),
    .RegData(data_reg_a),
    .jrcontrol(jrtrue),
    .jcontrol(jumptrue),
    .bcontrol(branchtrue),
    .pcout(inst_addr),
    .end_j(end_j),
    .linkaddr(linkaddr),
    .link(link)
);

instr_reg instreg_dut(
    .mem_in(readdata),
    .clk(clk),
    .delay(waitrequest),
    .instruction(instr),
    .valid_r(valid_read),    
    .end_ctrl(end_ctrl),
	.reset(reset),
    .fetch(fetch)
);

regfile reg_dut(
    .clk(clk),
    .reset(reset),
    .fetch(fetch),
    .byteenable(byteenablet),
    .linkaddr(linkaddr),
    .reg_dst(RegDest),
    .valid_read(valid_read),
    .valid_write(valid_write),
    .Instruction(instr),
    .MemData(reg_data_in),
    .W_en(RegWrite),
    .end_instr_reg(end_of_inst_reg),
    .ReadData1(data_reg_a),
    .ReadData2(data_reg_b),
	.active(active),
    .v_read(v_read),
    .register_v0(register_v0),
    .link(link),
    .jalr(jalr)
);

ALU alu_dut(
    .instruction(instr),
    .ReadData1(data_reg_a),
    .ReadData2(data_reg_b),
    .reset(reset),
    .ALUResult(alu_data),
    .byteenable(byteenablet)
);

loads load_dut(
    .mem_in(loaddata),
    .mem_out(reg_data_in),
    .mem_sel(MemtoReg),
    .instruction(instr),
    .byteenable(byteenablet)
);

stores store_dut(
    .Read_data_b(data_reg_b),
    .byteenable(byteenablet),
    .write_data(writedata),
    .instruction(instr)
);

data_mem data_dut(
    .mem_in(readdata),
    .alu_in(alu_data),
    .instr(instr),
    .reset(reset),
    .v_read(v_read),
    .clk(clk),
    .fetch(fetch),
    .end_of_store(end_of_store),
    .mem_sel(MemtoReg),
    .delay(waitrequest),
    .data_to_load(loaddata), 
    .valid_w(valid_write), 
    .v_load(v_load),
    .w_en(RegWrite)
);

control_signals control_dut(
    .inst(instr),
    .readdata1(data_reg_a),
    .readdata2(data_reg_b),
    .end_of_inst_reg(end_of_inst_reg),
    .end_of_inst_store(end_of_store),
    .end_j(end_j),
    .waitrequest(waitrequest),
    .MemRead(data_read),
    .MemWrite(write),
    .ALUSrc(ALUSrc),
    .RegDest(RegDest),
    .RegWrite(RegWrite),
    .MemtoReg(MemtoReg),
    .jrtrue(jrtrue),
    .jumptrue(jumptrue),
    .branchtrue(branchtrue),
    .link(link),
	.clk(clk),
    .endi(endi),
    .halt(halt),
    .jalr(jalr),
	.reset(reset)
);

endmodule

