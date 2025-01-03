`timescale 1 ns / 1 ns
module mux (a,b,sel,out);
	input a,b;  
	input sel;  
	output out; 
	wire sel_,sel_a,sel_b;
	not (sel_,sel);       //门级描述
	and (sel_b,sel,b);     
	and (sel_a,sel_,a);       
	or  (out,sel_a,sel_b); 
endmodule
