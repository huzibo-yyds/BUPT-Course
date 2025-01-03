`timescale 1 ns / 100 ps
module alu(out,zero,opcode,data,accum);
input[7:0] data,accum;  //accum来自累加器，data来自存储器
input[2:0] opcode;
output zero;
output[7:0] out;
reg[7:0] out;

parameter PASS0=3'b000,
	  PASS1=3'b001,
	  ADD=3'b010,
	  AND=3'b011,
	  XOR=3'b100,
	  PASSD=3'b101,
	  PASS6=3'b110,
	  PASS7=3'b111;

always@(*)
begin
  case(opcode)
    PASS0 : out=#3.5 accum;  //选通accum  HLT指令    
	PASS1 : out=#3.5 accum;  //选通accum  SKZ指令    
	ADD : out=#3.5 accum+data;  //加法运算  ADD指令 
	AND : out=#3.5 accum&data;  //按位与  AND指令
	XOR : out=#3.5 accum^data;  //按位异或  XOR指令
	PASSD : out=#3.5 data;  //选通data  LDA指令     
	PASS6 : out=#3.5 accum;  //选通accum  STO指令   
	PASS7 : out=#3.5 accum;  //选通accum  JMP指令 
  endcase
end

assign #1.2 zero=!accum;  //零标志判断

endmodule
