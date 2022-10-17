module PC(
	input active,
	input clk,
	input fetch,
	input reset,
	output logic[31:0] pcout,
	output logic end_j,
	input logic JRcontrol,
	//input logic Jump,
	//input logic Branch,
	input logic[31:0] jumpaddr

);	
	logic[31:0] pcin = 0;
	logic[31:0] pcnext;
	logic[31:0] addrtojumpto;
	logic noop;
	
	
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
				else if (JRcontrol==1) begin
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