module top_level_CPU(
    /* Standard signals */
    input logic clk,
    input logic reset,
    output logic active,
    //output logic[31:0] register_v0,

    /* Avalon memory mapped bus controller (master) */
    output logic[31:0] address,
    output logic write,
    output logic read,
    input logic waitrequest,
    output logic[31:0] writedata,
    //output logic[3:0] byteenable,
    input logic[31:0] readdata
    //output logic[31:0] reg_out[4:0]
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
logic PCSrc;
logic MemtoReg;
logic fetch;
logic jump;
logic JRcontrol;
logic v_read;
logic endi;
logic end_ctrl;
logic end_j;
logic v_load;
logic[31:0] reg_data_in;
logic[31:0] alu_data;

always_comb begin
    addr = (fetch==1)?inst_addr:alu_data;
    address = addr;
    writedata = data_reg_b;
    read = data_read ||fetch;
    if (reset == 1) begin
        active = 1;
    end
	if (inst_addr == 0) begin
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
    .jumpaddr(data_reg_a),
    .JRcontrol(JRcontrol),
    .pcout(inst_addr),
    .end_j(end_j)
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
    .reg_dst(RegDest),
    .valid_read(valid_read),
    .valid_write(valid_write),
    .Instruction(instr),
    .WriteData(reg_data_in),
    .W_en(RegWrite),
    .end_instr_reg(end_of_inst_reg),
    .ReadData1(data_reg_a),
    .ReadData2(data_reg_b),
	.active(active),
    .v_read(v_read)
    //.reg_out[4:0](reg_out[4:0])
);

ALU alu_dut(
    .instruction(instr),
    .ReadData1(data_reg_a),
    .ReadData2(data_reg_b),
    .reset(reset),
    .ALUResult(alu_data)
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
    .data_to_reg(reg_data_in), 
    .valid_w(valid_write), 
    .v_load(v_load),
    .w_en(RegWrite)
);

control_signals control_dut(
    .inst(instr),
    .end_of_inst_reg(end_of_inst_reg),
    .end_of_inst_store(end_of_store),
    .end_j(end_j),
    .waitrequest(waitrequest),
    .MemRead(data_read),
    .MemWrite(write),
    .ALUSrc(ALUSrc),
    .RegDest(RegDest),
    .RegWrite(RegWrite),
    .PCSrc(PCSrc),
    .MemtoReg(MemtoReg),
    .JRcontrol(JRcontrol),
	.clk(clk),
    .endi(endi),
	.reset(reset)
);

endmodule


