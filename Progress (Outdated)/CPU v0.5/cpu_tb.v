module mini_cpu_tb();
//to compile run: iverilog -Wall -g 2012 -s cpu_tb -o cpu_tb alu.v cpu_tb.v PCtoplevel.v PC.v jumpbranchcontrol.v regfile_32.v

logic clk;
logic reset;
logic active;
//logic[31:0] register_v0;

/* Avalon memory mapped bus controller (master) */
logic[31:0] address;
logic write;
logic read;
logic waitrequest;
logic[31:0] writedata;
//logic[3:0] byteenable;
logic[31:0] readdata;

logic[31:0] RAM[63:0];

initial begin
    $dumpfile("mini_CPU_Waveforms.vcd");
    $dumpvars(0,mini_cpu_tb);
end
initial begin
	clk = 0;
	repeat (2000) begin
		clk = !clk;
		#5;
	end
end

initial begin
    for (integer idx = 0; idx<64; idx=idx+1) begin
        RAM[idx] = 0;
    end
    RAM[4] = 32'h242A000C; //addi reg10 = reg1 + 12 reg10 = 12
    RAM[8] = 32'h8D510000; //load reg17 = mem[reg[10]+0] reg17 = 123
    RAM[12] = 32'h01512821; //add reg5 = reg10+reg17 reg5 = 132
    RAM[16] = 32'h243D0009; //addi reg29 = reg1 + 9 reg29 = 9
    RAM[20] = 32'hAFA50004; //store mem[reg[29]+4] = reg5 mem13 = 132
    RAM[24] = 32'h03A00008; //jump to reg[29] go to RAM9
    RAM[28] = 32'h2434010A; //addi reg20 = reg1+266 reg20 = 266 SHOULD EXECUTE
    RAM[32] = 32'h242F01A4; //addi reg15 = reg1+420 reg15 = 420 SHOULD NOT EXEUTE
    RAM[36] = 32'h25EF0045; //addi reg15 = reg15+69 reg15 = 69 SHOULD BE FINAL value of 15
    RAM[40] = 32'h00000008; //jump to adr 0 HALT CPU
    RAM[48] = 32'h0000007B; // data to be loaded 
end

always_ff @ (posedge clk) begin
    if (read==1) begin
        readdata <= RAM[address];
    end
    if (write==1) begin
        RAM[address] <= writedata;
    end
end


initial begin
    reset = 1;
    #5;
    reset = 0;
    if (active == 0) begin
        //$display("reg 10 = %x" , reg_out[10]);
       // $display("reg 17 = %x" , reg_out[17]);
       // $display("reg 5 = %x" , reg_out[5]);
       // $display("reg 29 = %x" , reg_out[29]);
        //$display("reg 20 = %x" , reg_out[20]);
        //$display("reg 15 = %x" , reg_out[15]);
        $display("RAM[52] = %x" , RAM[52]);
    end
end

top_level_CPU dut(
    /* Standard signals */
    .clk(clk),
    .reset(reset),
    .active(active),

    /* Avalon memory mapped bus controller (master) */
    .address(address),
    .write(write),
    .read(read),
    .waitrequest(waitrequest),
    .writedata(writedata),
    //output logic[3:0] byteenable,
    .readdata(readdata)
    //.reg_out[4:0](reg_out[4:0])
);

endmodule