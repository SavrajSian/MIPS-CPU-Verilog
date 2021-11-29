module mem_to_instruction(
    input logic[31:0] mem_in, //instruction from memory
    input logic delay, //dont select if there is a waitrequest from mem
    output logic[31:0] instruction,
    output logic valid //output a vlid signal to following module, if there is a wait, make sure follwoing opearnds do not do anything until data is 'valid'
);
    
always_comb begin
    if delay == 1 begin
        valid = 0;
    end
    else begin
        instruction = mem_in
        valid = 1;
    end
end


