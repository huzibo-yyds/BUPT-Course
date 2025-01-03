module full_chip (
    input rst_,
    input clock,
    input [7:0] data_out,
    
    output  rd,
    output  wr,
    output [7:0] data_in,
    output halt,
    output [4:0] addr
);
    wire clock_pin;
    wire rst_pin;
    wire [7:0] data_out_pin;

    wire [7:0] data_in_pin;
    wire [4:0] addr_pin;
    wire rd_pin;
    wire wr_pin;

    //PI  u_pad_clock ( .PAD(clock),	.C(clock_pin));
    PI	u_pad_rst_ ( .PAD(rst_),	.C(rst_pin));
    
    PI  u_pad_data_out7 ( .PAD(data_out[7]),	.C(data_out_pin[7]));
    PI  u_pad_data_out6 ( .PAD(data_out[6]),	.C(data_out_pin[6]));
    PI  u_pad_data_out5 ( .PAD(data_out[5]),	.C(data_out_pin[5]));
    PI  u_pad_data_out4 ( .PAD(data_out[4]),	.C(data_out_pin[4]));
    PI  u_pad_data_out3 ( .PAD(data_out[3]),	.C(data_out_pin[3]));
    PI  u_pad_data_out2 ( .PAD(data_out[2]),	.C(data_out_pin[2]));
    PI  u_pad_data_out1 ( .PAD(data_out[1]),	.C(data_out_pin[1]));
    PI  u_pad_data_out0 ( .PAD(data_out[0]),	.C(data_out_pin[0]));

    PO8  u_pad_data_in7 ( .I(data_in_pin[7]),	.PAD(data_in[7]));
    PO8  u_pad_data_in6 ( .I(data_in_pin[6]),	.PAD(data_in[6]));
    PO8  u_pad_data_in5 ( .I(data_in_pin[5]),	.PAD(data_in[5]));
    PO8  u_pad_data_in4 ( .I(data_in_pin[4]),	.PAD(data_in[4]));
    PO8  u_pad_data_in3 ( .I(data_in_pin[3]),	.PAD(data_in[3]));
    PO8  u_pad_data_in2 ( .I(data_in_pin[2]),	.PAD(data_in[2]));
    PO8  u_pad_data_in1 ( .I(data_in_pin[1]),	.PAD(data_in[1]));
    PO8  u_pad_data_in0 ( .I(data_in_pin[0]),	.PAD(data_in[0]));

    PO8 u_pad_addr4 ( .I(addr_pin[4]),	.PAD(addr[4]));
    PO8 u_pad_addr3 ( .I(addr_pin[3]),	.PAD(addr[3]));
    PO8 u_pad_addr2 ( .I(addr_pin[2]),	.PAD(addr[2]));
    PO8 u_pad_addr1 ( .I(addr_pin[1]),	.PAD(addr[1]));
    PO8 u_pad_addr0 ( .I(addr_pin[0]),	.PAD(addr[0]));

    PO8 u_pad_rd ( .I(rd_pin),	.PAD(rd));
    PO8 u_pad_wr ( .I(wr_pin),	.PAD(wr));
    
    cpu u_cpu(
        .rst_       (rst_pin        ),
        .clock      (clock      ),
        .data_out   (data_out_pin   ),
        .data_in    (data_in_pin    ),
        .addr       (addr_pin       ),
        .rd         (rd_pin         ),
        .halt       (halt           ),
        .wr         (wr_pin         )
    );
endmodule