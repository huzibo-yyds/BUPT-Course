`timescale 1 ns / 1 ns
module dffr(clk,rst_,d,q,q_);
	input clk,rst_;  
	input d;         
	output q,q_;     
	
	/*wire de,dl,dl_,qe;

	nand n1(de,dl,qe);       //门级描述
	nand n2(qe,clk,de,rst_);
	nand n3(dl,d,dl_,rst_);
	nand n4(dl_,dl,clk,qe);
	nand n5(q,qe,q_);
	nand n6(q_,dl_,q,rst_);*/
	reg qout_r;

	always @(posedge clk or negedge rst_)
	begin :DFFR_PROC
	  if (rst_ == 1'b0)
	    qout_r <= 1'b0;
	  else                  
	    qout_r <= d;
	end
	
	assign q = qout_r;
	assign q_ = q;
endmodule
