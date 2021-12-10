module data_mem(
    input logic[31:0] mem_in, //load data from memory
    input logic[31:0] alu_in, //data from alu
    input logic[31:0] instr,
    input logic mem_sel, //select between mem_data and alu_data
    input logic delay, //dont select if there is a waitrequest from mem
    input logic reset,
    input logic v_read,
    input logic endi,
    input logic clk,
    output logic[31:0] data_to_reg, 
    output logic end_of_store,
    output logic valid //output a vlid signal to following module, if there is a wait, make sure follwoing opearnds do not do anything until data is 'valid
);
logic[31:0] mem_type;
logic[5:0] load_op = instr[31:26];


always_comb begin
    
    case(load_op)
        6'b100011: mem_type = mem_in;
    endcase
    if (reset == 1) begin
        valid = 0;
    end
    else if (delay == 1) begin
        valid = 0;
    end
    else if (v_read == 1) begin
        data_to_reg = (mem_sel == 1 ? mem_type : alu_in);
        valid = 1;
    end
    else begin
        valid = 0;
    end
end

always_ff @(posedge clk) begin
    if (load_op ==6'b101011) begin
        end_of_store = 1;
    end
    else begin
        end_of_store<= endi;
    end
end
endmodule
