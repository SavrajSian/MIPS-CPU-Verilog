module jr1_tb.v ();

logic clk;
logic reset;
logic active;
logic[31:0] register_v0;

/* Avalon memory mapped bus controller (master) */
logic[31:0] address;
logic write;
logic read;
logic waitrequest;
logic[31:0] writedata;
logic[3:0] byteenable;
logic[31:0] readdata;

/*RAM control logic*/
logic[31:0] instruction;
logic inst_input;
logic RAM_Reset;
logic[7:0] inst_addr;

initial begin  //only needed for debugging
    $dumpfile("JR1_waveforms.vcd");
    $dumpvars(0,JR_testcase_1);
end

initial begin //intialise clock
	clk = 0;
	repeat (2000) begin
		clk = !clk;
		#5;
	end
    if(active != 0) begin
        $fatal(2, "Test-bench has not completed after 1000 clock cycles. Giving up.");
    end
end

initial begin
    RAM_Reset = 1;
    #10;
    RAM_Reset = 0;
    inst_input = 1; /*turn on when you want to add instructions*/

    inst_addr = 8'h04; /*first address*/
    instruction = 32'h240ABFC0;  /*ADD BFC*/
    #1; /*seperate instructions by a delay of 1*/

    inst_addr = 8'h08; 
    instruction = 32'h000A5400; /*Shift BFC*/
    #1;

    inst_addr = 8'h0C; 
    instruction = 32'h254A0018;  /*last 2 bits are where to jump to -4 // this exmaple is 1C-4*/
    #1;

    inst_addr = 8'h10;
    instruction = 32'h01400008;
    #1;
    
    inst_addr = 8'h14;
    instruction = 32'h24020040;
    #1;
    
    inst_addr = 8'h18;
    instruction = 32'h24420060;
    #1;
    
    inst_addr = 8'h1C;
    instruction = 32'h24420080;
    #1;
    
    inst_addr = 8'h20;
    instruction = 32'h00000008;
    #1;


    inst_input = 0; /*turn off when you finish*/
end

initial begin
    reset = 1;
    #10;
    reset = 0;
end

always@(negedge active) begin 
    assert (register_v0 == 32'hC0) else $fatal(2, "register value wrong");
end

top_level_cpu cpu_dut( /*Instantiate top_level_cpu*/
    /* Standard signals */
    .clk(clk),
    .reset(reset),
    .active(active),
    .register_v0(register_v0),

    /* Avalon memory mapped bus controller (master) */
    .address(address),
    .write(write),
    .read(read),
    .waitrequest(waitrequest),
    .writedata(writedata),
    .byteenable(byteenable),
    .readdata(readdata)
);

RAM mem_dut( /*Instantiate RAM*/
    .address(address),
    .write(write),
    .read(read),
    .waitrequest(waitrequest),
    .writedata(writedata),
    .byteenable(byteenable),
    .readdata(readdata),
    .instruction(instruction),
    .inst_input(inst_input),
    .RAM_Reset(RAM_Reset),
    .clk(clk),
    .inst_addr(inst_addr)
);

endmodule
