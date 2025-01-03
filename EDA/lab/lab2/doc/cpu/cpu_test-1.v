`timescale 1 ns / 1 ns

module cpu_test;  

  reg		rst_	;
  reg [(3*8):1] mnemonic;
  wire [4:0] addr;
  wire [7:0] data_in ;
  wire [7:0] data_out ;

// Instantiate the VeriRISC CPU

  full_chip u_full_chip
 ( 
  .rst_(rst_),
  .clock(clock), 
  .rd(rd),
  .wr(wr),
  .data_in(data_in),
  .data_out(data_out),
  .addr(addr)
 ) ;
  
  clock clk1
 (
  .clk(clock)
 );

  mem mem1 
 ( 
  .data_in(data_in),
  .data_out(data_out),
  .addr (addr ), 
  .read (rd ), 
  .write (wr ) 
 );

// Generate mnemonic

  always @ ( u_full_chip.u_cpu.opcode )
    case ( u_full_chip.u_cpu.opcode )
      3'h0    : mnemonic = "HLT" ;
      3'h1    : mnemonic = "SKZ" ;
      3'h2    : mnemonic = "ADD" ;
      3'h3    : mnemonic = "AND" ;
      3'h4    : mnemonic = "XOR" ;
      3'h5    : mnemonic = "LDA" ;
      3'h6    : mnemonic = "STO" ;
      3'h7    : mnemonic = "JMP" ;
      default : mnemonic = "???" ;
    endcase


// Monitor signals

  initial
    begin
      $timeformat ( -9, 1, " ns", 12 ) ;
//      $shm_open ( "waves.shm" ) ;
//      $shm_probe ( mnemonic, cpu1, "A" ) ;
      $dumpvars (0,cpu_test);
    end


// Apply stimulus

  always
    begin
     `ifdef INCA
     $display("\n************************************************************");
     $display("*        THE FOLLOWING DEBUG TASKS ARE AVAILABLE:          *");
     $display("* Enter \"scope cpu_test; deposit test.N 1; task test; run\" *");
     $display("*         to run the 1st diagnostic program.               *");
     $display("* Enter \"scope cpu_test; deposit test.N 2; task test; run\" *");
     $display("*         to run the 2nd diagnostic program.               *");
     $display("* Enter \"scope cpu_test; deposit test.N 3; task test; run\" *");
     $display("*         to run the Fibonacci program.                    *");
     $display("* Enter \"scope cpu_test; deposit test.N 4; task test; run\" *");
     $display("*         to run the COUNTER program.               *");
     $display("* Enter \"scope cpu_test; deposit test.N 5; task test; run\" *");
     $display("*         to run the 2^n program.                    *");
     $display("************************************************************\n");
     `else
     $display("\n***********************************************************");
     $display("*        THE FOLLOWING DEBUG TASKS ARE AVAILABLE:         *");
     $display("* Enter \"call test(1);run\" to run the 1st diagnostic program.   *");
     $display("* Enter \"call test(2);run\" to run the 2nd diagnostic program.   *");
     $display("* Enter \"call test(3);run\" to run the Fibonacci program.        *");
     $display("* Enter \"call test(4);run\" to run the COUNTER program.        *");
     $display("* Enter \"call test(5);run\" to run the 2^n program.        *");
     $display("***********************************************************\n");
     `endif
      $stop ;
      @ ( negedge u_full_chip.u_cpu.clock )
      rst_ = 0;
      @ ( negedge u_full_chip.u_cpu.clock )
      rst_ = 1;
      @ ( posedge u_full_chip.u_cpu.ctl1.halt )
      $display ( "HALTED AT PC = %h", u_full_chip.u_cpu.pc_addr ) ;
      disable test ;  //检测到HALT指令，测试就结束
    end


// Define the test task

  task test ;
    input [2:0] N ;
    reg [12*8:1] testfile ;
    if ( 1<=N && N<=5 )
      begin
        testfile = { "CPUtest", 8'h30+N, ".dat" } ;
        $readmemb ( testfile, mem1.memory ) ;  //将指令读入存储器
        case ( N )
          1:
            begin
              $display ( "RUNNING THE BASIC DIAGOSTIC TEST" ) ;
              $display ( "THIS TEST SHOULD HALT WITH PC = 17" ) ;
              $display ( "PC INSTR OP DATA ADR" ) ;
              $display ( "-- ----- -- ---- ---" ) ;
              forever @ ( u_full_chip.u_cpu.opcode or u_full_chip.u_cpu.ir_addr )
	        $strobe ( "%h %s   %h  %h  %h  %h",
                    u_full_chip.u_cpu.pc_addr, mnemonic, u_full_chip.u_cpu.opcode, u_full_chip.u_cpu.data_in, u_full_chip.u_cpu.data_out, u_full_chip.u_cpu.addr ) ;
            end
          2:
            begin
              $display ( "RUNNING THE ADVANCED DIAGOSTIC TEST" ) ;
              $display ( "THIS TEST SHOULD HALT WITH PC = 10" ) ;
              $display ( "PC INSTR OP DATA ADR" ) ;
              $display ( "-- ----- -- ---- ---" ) ;
              forever @ ( u_full_chip.u_cpu.opcode or u_full_chip.u_cpu.ir_addr )
	        $strobe ( "%h %s   %h  %h  %h  %h",
                    u_full_chip.u_cpu.pc_addr, mnemonic, u_full_chip.u_cpu.opcode, u_full_chip.u_cpu.data_in, u_full_chip.u_cpu.data_out, u_full_chip.u_cpu.addr ) ;
            end
           3:
              begin
                $display ( "RUNNING THE FIBONACCI CALCULATOR" ) ;
                $display ( "THIS PROGRAM SHOULD CALCULATE TO 144" ) ;
                $display ( "FIBONACCI NUMBER" ) ;
                $display ( " ---------------" ) ;
                forever @ ( u_full_chip.u_cpu.opcode )
                  if (u_full_chip.u_cpu.opcode == 3'h2)
                    $strobe ( "%d", mem1.memory[5'h1B] ) ;
              end
	  4:
             begin
                $display ( "RUNNING THE COUNTER CALCULATOR" ) ;
                $display ( "THIS PROGRAM IS A COUNTER" ) ;
                $display ( "COUNTER NUMBER" ) ;
                $display ( " ---------------" ) ;
                forever @ ( u_full_chip.u_cpu.opcode )
                  if (u_full_chip.u_cpu.opcode == 3'h4)
                    $strobe ( "%d", mem1.memory[5'h1D] ) ;
	     end
	  5:
             begin
                $display ( "RUNNING THE ODD CALCULATOR" ) ;
                $display ( "THIS PROGRAM IS A COUNTER" ) ;
                $display ( "COUNTER NUMBER" ) ;
                $display ( " ---------------" ) ;
                forever @ ( u_full_chip.u_cpu.opcode )
                  if (u_full_chip.u_cpu.opcode == 3'h3)
                    $strobe ( "%d", mem1.memory[5'h1A] ) ;
		
            end
        endcase
      end
    else
      begin
        $display("Not a valid test number. Please try again." ) ;
        $stop ;
      end
  endtask
`ifdef FSDB
    initial begin 
                $fsdbDumpfile("cpu_test.fsdb");
        $fsdbDumpvars("+all");
    end 
`endif

  //initial $sdf_annotate("full_chip.sdf", u_full_chip);
endmodule

