module PC(
	input active,
	input clk,
	input fetch,
	input reset,
	output logic[31:0] pcout,
	input logic JRcontrol,
	//input logic Jump,
	//input logic Branch,
	input logic[31:0] reg_data_a, //address for jumping - changed from jumpaddr to this
	input logic[31:0] reg_data_b, //address for comparing for BNE
	input logic[31:0] inst

);	
	logic[31:0] pcin = 0;
	logic[31:0] pcnext;
	logic[31:0] addrtojumpto;
	logic [5:0] op = inst[31:26]; // mistake here in PC on GitHub i think
	logic [5:0] jumpbits = inst[5:0];
	logic [5:0] branchbits = inst[20:16];
	logic noop;
	logic Jcontrol; 
    logic JALcontrol;
    logic JALRcontrol;
    logic JRcontrol; 
    logic BEQcontrol; 
    logic BGEZcontrol; 
    logic BGEZALcontrol;
    logic BGTZcontrol; 
    logic BLEZcontrol;
    logic BLTZcontrol;
    logic BLTZALcontrol;
    logic BNEcontrol; 
    logic JUMP;
    logic BRANCH;
    logic [17:0] branchoffset = inst[15:0]<<2;
    logic [27:0] jumpoffset 
	
	always comb begin //control signals

		if(op == 6'b000010) begin //J
			Jcontrol = 1;
			//bits [25:0] shifted left 2 bits is address jumping to. Remaining upper bits are corresponding
			//bits of address of instr in branch delay slot..
			/////Jump made of immediate field shifted left 2 bits, combined with upper 4 bits of PC+4.
			//execute instr in branch delay slot and then jump.
		end
	
		else if(op == 6'b000011) begin //JAL
			JALcontrol = 1;
			//place return address in GPR(reg) 31 = PC + 8. Need signals here for that
			//execute instr in branch delay slot and then jump.
		end
	
		
		else if(op == 0 && jumpbits == 6'b001001) begin //JALR
			JALRcontrol = 1;
			//place return address in GPR 'rd' given in instr: GPR[rd] = PC + 8
			//jump to address in 'rs' - needs to be stored in a temp register and in next cycle: PC <- temp
			//execute instr in branch delay slot and then jump.
		end
	
		else if(op == 0 && jumpbits == 6'b001000) begin //JR
			JRcontrol = 1;
			//jump to address in 'rs', need: temp<-GPR[rs], then PC<-temp (2 separate cycles)
			//execute instr in branch delay slot and then jump. 
		end
		
		else if(op = 6'b000100) begin //BEQ
			BEQcontrol =1;
			//if rs == rt, branch. Use ALU 'zero' result (so rs-rt == 0, branch)
			//bits [15:0] shifted left 2 bits added to address of instr after branch - PC + 4 + offset. This forms target address.
			//execute instr in branch delay slot and then branch if necessary
		end
	
		else if(op = 6'b000001 && branchbits = 5'b00001) begin //BGEZ
			BGEZcontrol = 1;
			//if rs => 0, branch (sign bit is 0)
			//bits [15:0] shifted left 2 bits added to address of instr after branch. This forms target address.
			//execute instr in branch delay slot and then branch if necessary
		end
	
		else if(op = 6'b000001 && branchbits = 5'b10001) begin //BGEZAL
			BGEZALcontrol = 1;
			// if rs=>0, branch (sign bit is 0).
			//place return address in GPR 31: GPR[31] <- PC + 8
			//bits [15:0] shifted left 2 bits added to address of instr after branch. This forms target address.
			//execute instr in branch delay slot and then branch if necessary
		end
	
		else if(op = 6'b000111 && branchbits == 0) begin //BGTZ
			BGTZcontrol = 1;
			//if rs>0, branch (sign bit is 0, value not 0)
			//bits [15:0] shifted left 2 bits added to address of instr after branch. This forms target address.
			//execute instr in branch delay slot and then branch if necessary
		end
	
		else if(op = 6'b000110 && branchbits == 0) begin //BLEZ
			BLEZcontrol = 1;
			//if rs <= 0, branch (if sign bit is 1 or value is 0)
			//bits [15:0] shifted left 2 bits added to address of instr after branch. This forms target address.
			//execute instr in branch delay slot and then branch if necessary
		end
	
		else if(op = 6'b000001 && branchbits == 0) begin //BLTZ
			BLTZcontrol = 1;
			//if rs<0, branch (if sign bit is 1)
			//bits [15:0] shifted left 2 bits added to address of instr after branch. This forms target address.
			//execute instr in branch delay slot and then branch if necessary
		end
	
		else if(op = 6'b000001 && branchbits = 5'b10000) begin //BLTZAL
			BLTZALcontrol = 1;
			//if rs<0, branch (if sign bit is 1)
			//place return address in GPR 31: GPR[31] <- PC + 8
			//bits [15:0] shifted left 2 bits added to address of instr after branch. This forms target address.
			//execute instr in branch delay slot and then branch if necessary
		end
	
		else if(op = 6'b000101) begin //BNE
			BNEcontrol = 1;
			//if rs ≠ rt, branch.
			//bits [15:0] shifted left 2 bits added to address of instr after branch. This forms target address.
			//execute instr in branch delay slot and then branch if necessary
		end
		
		if(Jcontrol == 1 || JALcontrol == 1 || JALRcontrol == 1 || JRcontrol == 1) begin
			JUMP = 1;
		end
		else begin
			JUMP = 0;
		end
				
		if(BEQcontrol == 1 || BGEZcontrol == 1 || BGEZALcontrol == 1 || BGTZcontrol == 1 || BLEZcontrol == 1 || BLTZcontrol == 1 || BLTZALcontrol == 1 || BNEcontrol == 1) begin
			BRANCH = 1;
		end
		else begin
			BRANCH = 0;
		end
			
			
		
		
	end
	
	
	always_comb begin
		if (active == 1) begin
			if(noop==1)begin
				pcnext = addrtojumpto;
			end				

			else begin 
				pcnext = pcin + 4;
				if(JRcontrol == 1) begin
					addrtojumpto = reg_data_a;
				end
				else if(Jcontrol == 1) begin
					jumpoffset = inst[25:0]<<2; //// Not sure about this part of J either
				end
				//// Add cases for JAL and JALR later.
				else if(BRANCH == 1) begin //branches all have same offset so would all have same target address
					if(branchoffset[17] == 0) begin // signed offset - if MSB = 0 means positive number so add offset
						addrtojumpto =  pcin + 4 + {14'd0, branchoffset};
					end
					else begin // ie if MSB = 1 and offset is negative, so take away offset
						addrtojumpto = pcin + 4 - ~({14'b11111111111111, branchoffset}) + 1; //invert bits and add 1 to make into normal number, then take away
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
				end
				else if (JRcontrol==1) begin //JR
					pcout <= addrtojumpto;
					pcin <= addrtojumpto;
				end
				else if (JALRcontrol == 1) begin //JALR
					////COMPLETE LATER
				end
				else if(Jcontrol == 1) begin //J
					pcout <= {pcin[31:28], jumpoffset}; ////pcin here is meant to be address of instr after jump instr, not sure if thats case when this would be done - CHECK 
					pcin <= {pcin[31:28], jumpoffset}; /////CHECKKKKKKKKK
				end
				else if(JALcontrol == 1) begin //JAL
					////COMPLETE LATER
				end
								
				else if (BEQcontrol == 1 && reg_data_a == reg_data_b) begin //BEQ
					pcout <= addrtojumpto;
					pcin <= addrtojumpto;
				end
				else if (BGEZcontrol == 1 && reg_data_a => 0) begin //BGEZ
					pcout <= addrtojumpto;
					pcin <= addrtojumpto;
				end
				else if(BGEZALcontrol == 1 && reg_data_a => 0) begin //BGEZAL
					////COMPLETE LATER
				end
				else if(BGTZcontrol == 1 && reg_data_a > 0) begin //BGTZ
					pcout <= addrtojumpto;
					pcin <= addrtojumpto;
				end
				else if(BLEZcontrol == 1 && reg_data_a <= 0) begin //BLEZ
					pcout <= addrtojumpto;
					pcin <= addrtojumpto;
				end
				else if(BLTZcontrol == 1 && reg_data_a < 0) begin //BLTZ
					pcout <= addrtojumpto;
					pcin <= addrtojumpto;
				end
				else if(BLTZALcontrol == 1 && reg_data_a < 0) //BLTZAL
					////COMPLETE LATER
				end
				else if(BNEcontrol == 1 && reg_data_a != reg_data_b) // BNE
					pcout <= addrtojumpto;
					pcin <= addrtojumpto;
				end
				
					
				else if ()
				else begin
					pcout <= pcnext;
					pcin <= pcnext;
				end
			end
		end
	end
	
	
endmodule