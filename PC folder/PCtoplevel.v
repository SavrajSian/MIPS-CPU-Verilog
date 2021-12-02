module PCtoplevel(
	input clk,
	input reset,
	input logic JRcontrol,
	input logic Jump,
	input logic Branch,
	input logic[31:0] jumpaddr,
	output logic[31:0] pc
);

wire[31:0] PCouttoJBC;
wire[31:0] JBCtoPCin;

PC programcounter(.clk(clk), .reset(reset), .pcin(JBCtoPCin), .pcout(PCouttoJBC));
jumpbranchcontrol JBC(.pcin(PCouttoJBC), .pcout(JBCtoPCin), .JRcontrol(JRcontrol), .Jump(Jump), .Branch(Branch), .jumpaddr(jumpaddr));

assign pc = PCouttoJBC;



endmodule
