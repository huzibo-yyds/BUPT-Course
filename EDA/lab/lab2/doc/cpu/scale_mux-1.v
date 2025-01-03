module scale_mux(out,sel,b,a);
parameter size=8;
output[size-1:0] out;
input[size-1:0]b,a;
input sel;
reg[size-1:0] out;
	always@(sel or a or b)
		if(!sel) out=a;
		else out=b;
endmodule
