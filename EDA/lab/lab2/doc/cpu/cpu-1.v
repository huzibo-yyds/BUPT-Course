`timescale 1 ns / 1 ns 

module cpu 
 ( 
 rst_,clock,rd,wr,data_in,data_out,addr,halt,pc_addr,ir_addr,opcode
 ); 
input rst_;
input clock;
output  rd;
output  wr;
output [7:0] data_in; 
reg [7:0] data_in;
input [7:0] data_out;
output [4:0] addr; 
output halt;
//reg [4:0] addr;
// wire [7:0] data_in ;
// wire [7:0] data_out ;
 wire [7:0] alu_out ; 
 wire [7:0] ir_out ; 
 wire [7:0] ac_out ; 
 output [4:0] pc_addr ; 
 output [4:0] ir_addr ; 
 //wire [4:0] addr ; 
 output [2:0] opcode ;

 assign opcode = ir_out[7:5]; 
 assign ir_addr = ir_out[4:0]; 
 control ctl1 
 ( 
 .rd (rd ),
 .wr (wr ), 
 .ld_ir (ld_ir ), 
 .ld_ac (ld_ac ), 
 .ld_pc (ld_pc ), 
 .inc_pc (inc_pc ), 
 .halt (halt ), 
 .data_e (data_e ), 
 .sel (sel ), 
 .opcode (opcode ), 
 .zero (zero ), 
 .clk (clock ), 
 .rst_ (rst_ ) 
 ); 
 alu alu1  
 ( 
 .out (alu_out ), 
 .zero (zero ), 
 .opcode (opcode ), 
 .data (data_out ), 
 .accum (ac_out ) 
 ); 
 register ac  //累加器 
 ( 
 .out (ac_out ), 
 .data (alu_out ), 
 .load (ld_ac ), 
 .clk (clock ), 
 .rst_ (rst_ ) 
 ); 
 register ir  //指令寄存器 
 ( 
 .out (ir_out ), 
 .data (data_out ), 
 .load (ld_ir ), 
 .clk (clock ), 
 .rst_ (rst_ ) 
 ); 
 scale_mux #(5) smx  
 ( 
 .out (addr ),
 .sel (sel ), 
 .b (pc_addr ), 
 .a (ir_addr ) 
 ); 
 //mem mem1 
 //( 
 //.data_in(data_in),
 //.data_out(data_out),
 //.addr (addr ), 
 //.read (rd ), 
 //.write (wr ) 
// ); 
 counter pc 
 ( 
 .cnt (pc_addr ), 
 .data (ir_addr ), 
 .load (ld_pc ), 
 .clk (inc_pc ), 
 .rst_ (rst_ ) 
 ); 
 //clock clk 
 //( 
 //.clk (clock ) 
 //); 

 always@(*) data_in = (data_e) ? alu_out: 8'bz; 
endmodule
