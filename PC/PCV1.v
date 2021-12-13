module PC(
	input active,
	input clk,
	input fetch,
	input reset,
	input inst[31:0],
	output logic[31:0] pcout,
	output logic end_j,
	input logic JRcontrol,
	//input logic Jump,
	//input logic Branch,
	input logic[31:0] jumpaddr,
	input truejump,
	input BRANCH

);	
	logic[31:0] pcin = 0;
	logic[31:0] pcnext;
	logic[31:0] addrtojumpto;
	logic noop;
	logic branchoffset;
	
	assign branchoffset = inst[15:0]<<2;
	
	
	always_comb begin
		if (active == 1) begin
			if(noop==1)begin
				pcnext = addrtojumpto;
			end				

			else begin 
				pcnext = pcin + 4;
				if(JRcontrol == 1) begin
					addrtojumpto = jumpaddr;
				end
				else if(Jcontrol == 1) begin
					addrtojumpto = {(pcout+4)[31:28]], inst[25:0]<<2}; ////pcin here is meant to be address of instr after jump instr, not sure if thats case when this would be done - CHECK
				end 
				else if(BRANCH == 1) begin //branches all have same offset so would all have same target address
					if(branchoffset[17] == 0) begin // signed offset - if MSB = 0 means positive number so add offset
						addrtojumpto =  pcout + 4 + {14'd0, branchoffset}; // PC + 4 + offset
					end
					else begin // ie if MSB = 1 and offset is negative, so take away offset
						addrtojumpto = pcout + 4 - ~({14'b11111111111111, branchoffset}) + 1; //invert bits and add 1 to make into normal number, then take away
					end
				end
				
			end	
		end
	end
		

	always_ff @(posedge clk) begin
		if (active == 1) begin
			if (fetch == 1) begin
				
				if(reset == 1) begin
					pcout <= 4;
					pcin <=4;
					end_j <= 0;
				end
				else if (JRcontrol==1 || Jcontrol==1 || (BRANCH==1 && truejump==1) ) begin // last condition is if its a branch instr and conditions are correct
					pcout <= addrtojumpto;
					pcin <= addrtojumpto;
					end_j <= 1;
				end
			
				else begin
					pcout <= pcnext;
					pcin <= pcnext;
					end_j <= 0;
				end
			end
		end
	end
	
	
endmodule
