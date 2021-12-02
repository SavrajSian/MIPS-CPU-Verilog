module jumpbranchcontrol(
	input logic[31:0] pcin,
	output logic[31:0] pcout,
	input logic JRcontrol,
	input logic Jump,
	input logic Branch,
	input logic[31:0] jumpaddr
);

logic[31:0] PCcurr;
assign PCcurr = pcin + 4;

always_comb begin

	pcout = JRcontrol ? jumpaddr : PCcurr;


end

endmodule
