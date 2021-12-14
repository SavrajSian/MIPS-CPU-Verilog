module data_mem(
    input logic[31:0] load_in, //load data from load
    input logic[31:0] alu_in, //data from alu
    input logic[31:0] instr,
    input logic mem_sel, //select between mem_data and alu_data
    input logic delay, //dont select if there is a waitrequest from mem
    input logic reset,
    input logic fetch,
    input logic v_read,
    input logic clk,
    input logic v_load,
    input logic w_en,
    output logic[31:0] data_to_reg, 
    output logic end_of_store,
    output logic valid_w //output a vlid signal to following module, if there is a wait, make sure follwoing opearnds do not do anything until data is 'valid
);

logic[2:0] ls_op;
assign ls_op = instr[31:29];


always_comb begin
    if (reset == 1) begin
        valid_w = 0;
        end_of_store = 0;
    end
    else if (mem_sel == 0) begin /* if not load/store*/
        if(v_read == 1 && w_en) begin
            data_to_reg = alu_in;
            valid_w = 1;
        end
        else begin
            valid_w = 0;
        end
    end
    
end

always_ff @(posedge clk) begin
    if (ls_op ==6'b100 && v_load == 1) begin /*if store*/
        if(delay == 0) begin 
            end_of_store <= 1;
        end
        else begin
            end_of_store<= 0;
        end
    end
    else if (mem_sel == 1) begin /*if load*/
        if(delay == 0 && v_load == 1) begin 
            data_to_reg <= load_in;
            valid_w <= 1;
        end
        else begin
            valid_w<= 0;
        end
    end
    
end
endmodule