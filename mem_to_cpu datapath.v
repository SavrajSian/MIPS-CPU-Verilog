module mem_to_cpu(
    input logic[31:0] mem_in, //load data from memory
    input logic[31:0] alu_in, //data from alu
    input logic mem_sel, //select between mem_data and alu_data
    input logic delay, //dont select if there is a waitrequest from mem
    output logic[31:0] data_to_reg 
    output logic valid //output a vlid signal to following module, if there is a wait, make sure follwoing opearnds do not do anything until data is 'valid'
);
    
always_comb begin
    if delay == 1 begin
        valid = 0;
    end
    else begin
        data_to_reg = (mem_sel == 1 ? mem_in : alu_in);
        valid = 1;
    end
end


