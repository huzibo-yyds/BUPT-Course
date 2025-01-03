`timescale 1 ns / 1 ns
module counter ( cnt, clk, data, rst_, load ) ;
output [4:0] cnt ;
input [4:0] data ;
input clk ;
input rst_ ;
input load ;
reg [4:0] cnt ;
 always @ ( posedge clk or negedge rst_ )
 if ( !rst_ )
 #1.2 cnt <= 0 ;//异步复位
 else
 if ( load )
 cnt <= #3 data ;//同步置位
 else 
 cnt <= #4 cnt + 1 ;//正常计数
endmodule
