module instr_reg(
    input logic[31:0] mem_in, //instruction from memory
    input logic delay, //dont select if there is a waitrequest from mem
    output logic[31:0] instruction,
    output logic valid_r, //output a vlid signal to following module, if there is a wait, make sure follwoing opearnds do not do anything until data is 'valid'
    output logic end_ctrl,
    input logic reset,
    input logic clk,
    input logic fetch
);

logic[31:0] be_mem_in;

assign valid_r = !fetch;
assign be_mem_in = {mem_in[7:0],mem_in[15:8],mem_in[23:16],mem_in[31:24]};

always_comb /*@(posedge clk)*/ begin
    if (reset == 1) begin
        //instruction = 0;
    end
    else begin      
        //if (delay == 1) begin
            //valid_r = 0;
        //end
        /*else*/ if (fetch == 1) begin
            instruction = be_mem_in;
            //valid_r = 1;
            end_ctrl = 0;
        end
        else begin
            end_ctrl = 1;
            //valid_r = 0;
        end
    end
end

endmodule