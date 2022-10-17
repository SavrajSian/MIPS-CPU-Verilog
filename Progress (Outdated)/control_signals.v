module control_signals(
    input logic [31:0] inst,
    input logic end_of_inst_reg
    input logic end_of_inst_store
    output logic MemRead,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegDest,
    output logic RegWrite,
    output logic PCSrc,
    output logic MemtoReg,
    output logic fetch,
);

always_comb begin
    if inst[31:29]= 3'b100 begin //All loads follow this struct
        MemRead = 1;
        ALUSrc = 1;
        RegWrite = 1;
        MemtoReg = 1;
        MemWrite = 0;
        RegDest = 0;
        fetch = (end_of_inst_reg==1) ? 1:0;
    end
    else if inst== 6'b101011 begin //StoreWord
        MemRead = 0;
        ALUSrc = 1;
        RegWrite = 0;
        MemWrite = 1;
        always_ff@(negedge end_of_inst_store) begin
            fetch = 1;
        end
    end
    else if (inst[31:26]== 6'b000000 || inst[31:29]== 3'b001) begin //R or I-type
        MemRead = 0;
        ALUSrc = 0;
        RegWrite = 1;
        MemtoReg = 0;
        RegDest = 1;
        MemWrite = 0;
        fetch = (end_of_inst_reg==1) ? 1:0;
    end
    
end
endmodule
