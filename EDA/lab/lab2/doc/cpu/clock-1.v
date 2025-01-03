`timescale 1 ns / 1 ns
module clock(clk);
output clk;
reg clk;
initial begin
clk=0;
forever begin
	#10 clk=~clk;   //50MHz时钟
end
end
endmodule
