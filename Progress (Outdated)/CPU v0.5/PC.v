module PC(

	input clk,
	input reset,
	output logic[31:0] pcout,
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
		
	
	always_ff @(posedge clk) begin
		pcin <= pcnext;

		noop <= (JRcontrol==1)? 1 : 0;

		if(reset == 1) begin
			pcout <= 4;
			pcin <=4;
		end
		
		else begin
			pcout <= pcnext;
		end
		
	end
	
endmodule