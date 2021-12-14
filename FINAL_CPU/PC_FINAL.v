module PC(
	input active,
	input clk,
	input fetch,
	input reset,
	input logic[31:0] instruction,
	input logic[31:0] RegData,
    input logic link,
	output logic[31:0] pcout,
	output logic end_j,
	output logic[31:0] linkaddr,
	input logic jcontrol,
	input logic jrcontrol,
	input logic bcontrol
);	
	logic[31:0] pcin = 0;
	logic[31:0] pcnext;
	logic[31:0] addrtojumpto;
	logic[3:0] pc_chunk;
	logic[31:0] jraddr; // regfile
	logic[31:0] jaddr; // last 26 bits of inst shift 2, concatenated w first 4 bits of next address
	logic[31:0] braddr; // last 16 bits of inst shift 2, added to next address
	logic[31:0] b_add_tmp;
	logic[25:0] j_add_tmp;

	assign pc_chunk = pcnext[31:28];
	assign b_add_tmp = instruction[15:0]<<2;
	assign j_add_tmp = instruction[25:0]<<2;

	always_comb begin
		if(reset == 1) begin
			pcout = 32'hBFC00000;
			pcin =32'hBFC00000;
			end_j = 0;
		end
		else if (active == 1) begin
			pcnext = pcin + 4;
			linkaddr = pcnext + 4;
			if(jcontrol == 1) begin
				jaddr = {pc_chunk,j_add_tmp};
				addrtojumpto = jaddr;
				end_j = (link == 1) ? 0:1;
			end	
			else if(jrcontrol == 1) begin
				jraddr = RegData;
				addrtojumpto = jraddr;
				end_j = (link == 1)? 0:1;
			end
			else if(bcontrol == 1) begin
				braddr = pcnext+b_add_tmp;
				addrtojumpto = braddr;
				end_j = (link == 1)? 0:1;
			end

		end
	end
		

	always_ff @(posedge clk) begin
		if (active == 1) begin
			if (fetch == 1) begin
				if(reset == 0) begin
					if (jrcontrol==1 ||bcontrol == 1|| jcontrol == 1) begin
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
	end
	
endmodule