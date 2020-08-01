`timescale 1ns / 1ps

module qspi_pintest(
    clk,
    rst_n,
    qspi_d0,
    qspi_d1,
    qspi_d2,
    qspi_d3,
    I_qspi_cs,
    I_qspi_clk,
    
    key_bus
    );

input   clk;
input   rst_n;
inout   qspi_d0;
inout   qspi_d1;
inout   qspi_d2;
inout   qspi_d3;
input   I_qspi_cs;
input   I_qspi_clk;
input [3:0] key_bus;
wire[7:0]   o_cdata;
wire        o_cdata_valid;
wire        o_cien;

wire[7:0]   cal_o_data;
wire        cal_o_valid;
wire        cal_o_busy;
wire            fifo_ren;
// wire            fifo_rclk;
wire            fifo_full;
wire            fifo_empty;
wire[7:0]       fifo_odata;

wire        u_busy;
wire        u_wen;
wire        u_tx_en;
wire        tx_clk;
wire[7:0]   u_rx_data;
wire        u_o_valid;
wire [31:0] addr;
wire [7:0]  o_data;
wire [7:0]  i_data;
wire o_valid;
wire i_valid; 

QSPI_slave u_qspi_slave(
    .I_qspi_clk  (I_qspi_clk)  , 
    .I_qspi_cs   (I_qspi_cs)  , 
    .IO_qspi_io0 (qspi_d0)  ,
    .IO_qspi_io1 (qspi_d1)  ,
    .IO_qspi_io2 (qspi_d2)  , 
    .IO_qspi_io3 (qspi_d3)  , 
    .o_addr      (addr)    ,
    .o_data      (o_data)  ,
    .i_data      (i_data)  ,
    .o_valid     (o_valid) ,
    .i_valid     (i_valid)
    );
    
wire [7:0] fifo_o;
wire [7:0] fifo_i;
wire  fifo_ovalid;
wire  fifo_ivalid;

wire [31:0] addrb;
wire [7:0] dinb;
wire [7:0] doutb;
wire web;

wire SHA_ivalid;

blk_mem_gen_0 u_blk_mem_gen_0_inst(
    .addra(addr),
    .clka(I_qspi_clk),
    .dina(o_data),
    .douta(i_data),
    .wea(o_valid),
    
    .addrb(addrb),
    .clkb(clk),
    .dinb(dinb),
    .doutb(),
    .web(web)
);

wire [3:0] key_bus;
key_diver u_key_diver(
     .sclk(clk),
     .rst_n(rst_n),
     .key_bus(key_bus),
     .key_data_0(dinb),
     .key_addr(addrb),
     .en(web)
);

endmodule
