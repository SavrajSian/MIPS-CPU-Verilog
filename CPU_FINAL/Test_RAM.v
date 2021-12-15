module RAM(
    input logic[31:0] address,
    input logic write,
    input logic read,
    output logic waitrequest,
    input logic[31:0] writedata,
    input logic[7:0] inst_addr,
    input logic[3:0] byteenable,
    output logic[31:0] readdata,
    input logic[31:0] instruction,
    input logic inst_input,
    input logic RAM_Reset,
    input logic clk
);

logic[7:0] RAM[255:0];
logic[5:0] eff_addr;
logic[5:0] addr0; 
logic[5:0] addr1;
logic[5:0] addr2;
logic[5:0] addr3;

logic en_0;
logic en_1;
logic en_2; 
logic en_3;

logic[7:0] byte0;
logic[7:0] byte1;
logic[7:0] byte2;
logic[7:0] byte3;

logic[5:0] i0;
logic[5:0] i1;
logic[5:0] i2;
logic[5:0] i3;

assign byte0 = instruction[7:0];
assign byte1 = instruction[15:8];
assign byte2 = instruction[23:16];
assign byte3 = instruction[31:24];

assign eff_addr = address + 4 - 32'hBFC00000;
assign addr0 = eff_addr;
assign addr1 = eff_addr + 1;
assign addr2 = eff_addr + 2;
assign addr3 = eff_addr + 3;

assign i0 = inst_addr;
assign i1 = inst_addr + 1;
assign i2 = inst_addr + 2;
assign i3 = inst_addr + 3;

assign en_0 = byteenable[0];
assign en_1 = byteenable[1];
assign en_2 = byteenable[2];
assign en_3 = byteenable[3];

assign waitrequest = 0;

always_comb begin
    if(inst_input == 1) begin
        RAM[i0] = byte3;
        RAM[i1] = byte2;
        RAM[i2] = byte1;
        RAM[i3] = byte0;
    end
end

always_ff @(posedge clk ) begin 
    if (RAM_Reset == 1) begin
        for(integer idx = 0; idx<128; idx=idx+1) begin
            RAM[idx] <= 0;
        end
    end
    else if (read == 1) begin
        readdata <= {RAM[addr3], RAM[addr2], RAM[addr1], RAM[addr0]};
    end
    else if (write == 1) begin
        if(en_0 == 1) begin
            RAM[addr0] <= writedata[31:24];
        end
        if(en_1 == 1) begin
            RAM[addr1] <= writedata[23:16];
        end
        if(en_2 == 1) begin
            RAM[addr2] <= writedata[15:8];
        end
        if(en_3 == 1)  begin
            RAM[addr3] <= writedata[7:0];
        end
    end
end

endmodule;