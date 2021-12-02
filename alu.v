module ALU(
    input reset,

    input logic[4:0] control,
    input logic[31:0] a,
    input logic[31:0] b,
    input logic[5:0] sa,
    input logic[31:0] immediate,

    output logic[31:0] r,
    output logic zero
);
    logic[4:0] instr;
    logic[15:0] lower;
    assign zero = (r==0) ? 1 : 0;
    assign lower = b[15:0];
 
   always @(*) begin
       if (reset==1) begin
            r<=0;
       end
       else begin
            case(control)
                00000000: r <= a + immediate;  			//ADDIU
                00000001: r <= a + b; 				//ADDU
                00000010: r <= a & b;                 		//AND
                00000011: r <= a & immediate; 	    		//ANDI
                //00000100-00010011 branch
                //00000100:
                //00000101:
                //00000110:
                //00000111:
                //00001000:
                //00001001:
                //00001010:
                //00001011:
                00001100: begin r <= a[30:0] / b[30:0]; 	//DIV
                                 if(a[31]+b[31]==0) begin
                                    r[31]=0;
				 end
                                 else begin
                                    r[31]=1;
				 end 
			  end             
                00001101: r <= a / b;                 		//DIVU
                //00001110-00010001 jump
                //00001110:
                //00001111:
                //00010000:
                //00010001:
                //00010010-00011001 load
                //00010010:
                //00010011:
                //00010100:
                //00010101:
                //00010110:
                //00010111:
                //00011000:
                //00011001:
		//00011010-00011011 Move to
                //00011010:
                //00011011:
                00011100: begin r <= a[30:0] * b[30:0];		//MULT
                                 if(a[31]+b[31]==0) begin
                                    r[31]=0;
				 end
                                 else begin
                                    r[31]=1;
				 end 
			  end               
                00011101: r <= a * b;                  		//MULTU
                00011110: r <= a | b;                  		//OR
                00011111: r <= a | immediate;          		//ORI 
                //00100000-00100001 store
                //00100000:
                //00100001:
                //00100010-00100011 shift
                //00100010:
                //00100011:
                00100100: begin if(a[31]==1 && b[31]==0) begin 	//SLT
                                  r <= 1; 
				end
                              	else if(a[31]==0 && b[31]==1) begin
                                  r <= 0; 
				end
                                else if(a[30:0] > b[30:0]) begin
                                       r <= 0; 
				end
                                else begin
                                       r <= 1; 
				end
                          end
                00100101: begin if(a[31]==1 && immediate[31]==0) begin 
                                  r <= 1; 
				end
                              	else if(a[31]==0 && immediate[31]==1) begin
                                  r <= 0; 
				end 
                                else if(a[30:0] > immediate[30:0]) begin
                                       r <= 0; 
				end
                                else begin
                                       r <= 1; 
				end
                          end                                  //SLTI
                00100110: begin if(a > immediate) begin	       //SLTIU
                                    r <= 0; 
				end
                                else begin
                                    r <= 1; 
				end
			  end                  
                00100111: begin if(a > b) begin		       //SLTU
                                     r <= 0; 
				end
                                else begin
                                     r <= 1; 
				end     
			  end         
                //00101000-00110011 shift
                //00101000:
                //00101001:
                //00101010:
                //00101011:
                00101100: r <= a-b;                            //SUBU 
                //00101101 store
                //00101101:
                00101110: r <= a^b;                            //XOR 
                00101111: r <= a^immediate;                    //XORI
            endcase
        end
    end
endmodule