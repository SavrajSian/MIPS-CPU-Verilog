module PC(

	input clk,
	input reset,
	input logic[31:0] pcin,
	output logic[31:0] pcout

);	

	always_ff @(posedge clk) begin
		
		if(reset == 1) begin
			pcout <= 32'd0;
		end
		else begin
			pcout <= pcin;
		end
		
	end
	
endmodule
