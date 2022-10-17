module instr_reg(
    input logic[31:0] mem_in, //instruction from memory
    input logic delay, //dont select if there is a waitrequest from mem
    output logic[31:0] instruction,
    output logic valid, //output a vlid signal to following module, if there is a wait, make sure follwoing opearnds do not do anything until data is 'valid'
    input logic fetch,
    input logic reset
);
    
always_comb begin
    if (reset == 1) begin
        instruction = 0;
    end
    else if (fetch == 1) begin      
        if (delay == 1) begin
           // valid = 0;
        end
        else begin
            instruction = mem_in;
            //valid = 1;
        end
    end
    //else begin
        //valid = 0;
    //end
end
endmodule


