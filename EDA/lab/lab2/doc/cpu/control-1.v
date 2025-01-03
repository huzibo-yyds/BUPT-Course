`timescale 1 ns / 1 ns
module control (clk,rst_,zero,opcode,sel,rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,halt,data_e);
input clk;           
input rst_;          
input zero;          
input [2:0] opcode;  
output reg sel;      
output reg rd,wr;    
output reg ld_ir;    
output reg ld_ac;    
output reg ld_pc;    
output reg inc_pc;   
output reg halt;     
output reg data_e;   

reg [2:0] state;     
reg [2:0] next_state;
reg rd_op,wr_op,ld_ac_op,ld_pc_op,inc_pc_op1,inc_pc_op2,data_e_op,halt_op;  //inc_pc_op1为第7周期的程序计数器的时钟信号，inc_pc_op2为第8周期的



always@(posedge clk or negedge rst_)
begin
if(!rst_)
state<=3'b000;
else
state<=next_state;
end


always@(*)
begin
case(state)  //以8个时钟周期作为状态
3'b000 : next_state=3'b001;  //采用格雷码，消除冒险
3'b001 : next_state=3'b011;
3'b011 : next_state=3'b010;
3'b010 : next_state=3'b110;
3'b110 : next_state=3'b111;
3'b111 : next_state=3'b101;
3'b101 : next_state=3'b100;
3'b100 : next_state=3'b000;
endcase
end


always@(posedge clk or negedge rst_)
begin
if(!rst_)
begin 
sel<=0;
rd<=0;
wr<=0;
ld_ir<=0;
ld_ac<=0;
ld_pc<=0;
inc_pc<=0;
halt<=0;
data_e<=0;
end
else
begin
case(state)
3'b000 : begin   //1号周期   
sel<=1;
rd<=0;
wr<=0;
ld_ir<=0;
ld_ac<=0;
ld_pc<=0;
inc_pc<=0;
halt<=0;
data_e<=0;
end
3'b001 : begin   //2号   
sel<=1;
rd<=1;
wr<=0;
ld_ir<=0;
ld_ac<=0;
ld_pc<=0;
inc_pc<=0;
halt<=0;
data_e<=0;
end
3'b011 : begin  //3号     
sel<=1;
rd<=1;
wr<=0;
ld_ir<=1;
ld_ac<=0;
ld_pc<=0;
inc_pc<=0;
halt<=0;
data_e<=0;
end
3'b010 : begin  //4号     前4个时钟周期输出信号与指令无关
sel<=1;
rd<=1;
wr<=0;
ld_ir<=1;
ld_ac<=0;
ld_pc<=0;
inc_pc<=0;
halt<=0;
data_e<=0;
end
3'b110 : begin  // 5号      第5周期开始不同指令将有不同输出   
sel<=0;
rd<=0;
wr<=0;
ld_ir<=0;
ld_ac<=0;
ld_pc<=0;
inc_pc<=1;  //指令计数器常规计数
halt<=halt_op;
data_e<=0;
end
3'b111 : begin  //6号     
sel<=0;
rd<=rd_op;
wr<=0;
ld_ir<=0;
ld_ac<=0;
ld_pc<=0;
inc_pc<=0;
halt<=0;
data_e<=0;
end
3'b101 : begin  //7号     
sel<=0;
rd<=rd_op;
wr<=0;
ld_ir<=0;
ld_ac<=0;
ld_pc<=ld_pc_op;
inc_pc<=inc_pc_op1;
halt<=0;
data_e<=data_e_op;
end
3'b100 : begin  //8号     
sel<=0;
rd<=rd_op;
wr<=wr_op;
ld_ir<=0;
ld_ac<=ld_ac_op;
ld_pc<=ld_pc_op;
inc_pc<=inc_pc_op2;
halt<=0;
data_e<=data_e_op;
end		
endcase
end
end


always@(*)
begin
if(!rst_)
begin
rd_op=0;
wr_op=0;
ld_ac_op=0;
ld_pc_op=0;
inc_pc_op1=0;
inc_pc_op2=0;
data_e_op=0;
halt_op=0;
end
else
begin
case(opcode)
3'd0 : begin  //HLT 
rd_op=0;
wr_op=0;
ld_ac_op=0;
ld_pc_op=0;
inc_pc_op1=0;
inc_pc_op2=0;
data_e_op=1;
halt_op=1;  //在第5周期拉高halt信号
end
3'd1 : begin  //SKZ 
rd_op=0;
wr_op=0;
ld_ac_op=0;
ld_pc_op=0;
inc_pc_op1=zero;
inc_pc_op2=zero;
data_e_op=1;
halt_op=0;		  
end
3'd2 : begin  //ADD 
rd_op=1;
wr_op=0;
ld_ac_op=1;
ld_pc_op=0;
inc_pc_op1=0;
inc_pc_op2=0;
data_e_op=0;
halt_op=0;		  
end
3'd3 : begin  //AND 
rd_op=1;
wr_op=0;
ld_ac_op=1;
ld_pc_op=0;
inc_pc_op1=0;
inc_pc_op2=0;
data_e_op=0;
halt_op=0;		  
end
3'd4 : begin  //XOR 
rd_op=1;
wr_op=0;
ld_ac_op=1;
ld_pc_op=0;
inc_pc_op1=0;
inc_pc_op2=0;
data_e_op=0;
halt_op=0;		  
end	
3'd5 : begin  //LDA 
rd_op=1;
wr_op=0;
ld_ac_op=1;
ld_pc_op=0;
inc_pc_op1=0;
inc_pc_op2=0;
data_e_op=0;
halt_op=0;		  
end
3'd6 : begin  //STO 
rd_op=0;
wr_op=1;
ld_ac_op=0;
ld_pc_op=0;
inc_pc_op1=0;
inc_pc_op2=0;
data_e_op=1;
halt_op=0;		  
end
3'd7 : begin  //JMP 
rd_op=0;
wr_op=0;
ld_ac_op=0;
ld_pc_op=1;
inc_pc_op1=0;
inc_pc_op2=1;
data_e_op=1;
halt_op=0;		  
end	
endcase
end
end


endmodule
