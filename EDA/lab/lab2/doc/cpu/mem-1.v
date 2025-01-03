`timescale 1 ns / 1 ns
module mem(data_in,addr,read,write,data_out);
//inout[7:0] data;  //双向数据总线
input[7:0] data_in;
output[7:0] data_out;
input[4:0] addr;
input read,write;

reg[7:0] memory [31:0];
reg[7:0] data_reg;  //data映像寄存器

always@(posedge write)  //写入数据
begin
	memory[addr] <= data_in;
end

always@(*)  //读出数据
begin
	if(read)
		data_reg=memory[addr];  //inout类型端口不能定义为reg类型，但又需要在always块中被赋值，所以需要data映像寄存器定义为reg类型，在always块里运算，最后再赋值给data
	else
		data_reg=8'd0;
end

assign data_out=read?data_reg:8'bz;  //读信号有效时，输出对应地址的数据，读信号无效时，data处于高阻态，作为可输入状态

endmodule
