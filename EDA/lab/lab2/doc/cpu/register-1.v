`timescale 1 ns / 1 ns 
module register (clk,rst_,load,data,out);
	input clk,rst_,load; 
	input [7:0] data;
	output [7:0] out;
	wire [7:0] d;

genvar i;    //genvar型变量专用于generate-for循环  
generate    //采用generate-for语句重复例化子模块，提高了代码的简洁性
	for(i=0;i<=7;i=i+1)
		begin : G1 
		mux U1(.a(out[i]),.b(data[i]),.sel(load),.out(d[i]));
			  
		dffr U2(.clk(clk),.rst_(rst_),.d(d[i]),.q(out[i]),.q_());

	end
endgenerate  	  	  
endmodule
