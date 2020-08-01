`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2019 02:00:23 PM
// Design Name: 
// Module Name: AWS_aes_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module aes_top(
                    sclk, rst_n, key_bus, 
                    qspi_d0, qspi_d1, qspi_d2, qspi_d3, I_qspi_cs, I_qspi_clk,
                    ADC_EN_N, ADC_CLK, led_en
                    );

    input   sclk;
    input   rst_n;    
    input [3:0] key_bus; 
    output ADC_EN_N;
    output ADC_CLK;
    output led_en; 
    
    input   I_qspi_cs;
    input   I_qspi_clk;       
    inout   qspi_d0;
    inout   qspi_d1;
    inout   qspi_d2;
    inout   qspi_d3;
    
    wire [7:0] ad_data_in;
    wire [127:0] key_data;
    wire KEY_DONE_en;
    wire web;
    wire [7:0] addrb;
    wire [7:0] dinb, doutb;
    wire ram_write_en;
    wire [7:0] ram_addr;
    wire [7:0] ram_data;
    wire [127:0] ad_data128;
    wire ad_data128_en;
    wire clk_out50M;
    wire clk_out25M;
    wire aes_done;
    wire [127:0] text_out;
    
    key_128test key_128test_inst(
                                .sclk(clk_out50M),
                                .rst_n(rst_n),
                                .key_bus(key_bus),
                                .key_data(key_data),
                                .en(KEY_DONE_en)
                                 );
    

                                 
    light_sensor light_sensor_inst(
                                     .ad_data(ad_data_in),
                                     .sclk(sclk),
                                     .rst_n(rst_n),
                                     .KEY_DONE(KEY_DONE_en),
                                     .ADC_EN_N(ADC_EN_N),
                                     .ADC_CLK(ADC_CLK),
                                     .led_en(led_en),
                                     .data128(ad_data128),
                                     .data128_en(ad_data128_en),
                                     .clk_out50M(clk_out50M),
                                     .clk_out25M(clk_out25M)
                                      );


    aes_cipher_top aes_cipher_top_inst(
                                        .clk(clk_out50M), 
                                        .rst(rst_n), 
                                        .ld(ad_data128_en), 
                                        .done(aes_done), 
                                        .key(key_data), 
                                        .text_in(ad_data128), 
                                        .text_out(text_out)
                                         );


                                         
    ram_count ram_count_inst(
                              .clk(clk_out50M), 
                              .rst_n(rst_n), 
                              .aes_done(aes_done), 
                              .ram_128text_in(text_out), 
                              .ram_write_en(ram_write_en), 
                              .ram_addr(ram_addr), 
                              .ram_data(ram_data)
                               );
    

                               
    blk_mem_gen_0 blk_mem_gen_0_inst(
                                 .clka(clk_out50M),    // input wire clka
                                 .wea(ram_write_en),      // input wire [0 : 0] wea
                                 .addra(ram_addr),  // input wire [7 : 0] addra
                                 .dina(ram_data),    // input wire [7 : 0] dina
                                 .douta(),  // output wire [7 : 0] douta/*******未使用端口********/
                                 
                                 .clkb(I_qspi_clk),    // input wire clkb//
                                 .web(web),      // input wire [0 : 0] web
                                 .addrb(addrb),  // input wire [7 : 0] addrb
                                 .dinb(dinb),    // input wire [7 : 0] dinb/*******未使用端口********/
                                 .doutb(doutb)  // output wire [7 : 0] doutb
                               );
    blk_mem_gen_1 blk_mem_gen_1_inst(
                                 .clka(clk_out50M),    // input wire clka
                                 .wea(web),      // input wire [0 : 0] wea
                                 .addra(8'b0110_0000),  // input wire [7 : 0] addra
                                 .dina(dinb),    // input wire [7 : 0] dina
                                 .douta(ad_data_in) // output wire [7 : 0] douta
                               );
                               
    QSPI_slave QSPI_slave_inst(
                               //QSPI
                               .I_qspi_clk      (I_qspi_clk)    , 
                               .I_qspi_cs       (I_qspi_cs)    ,
                               .IO_qspi_io0     (qspi_d0)    , 
                               .IO_qspi_io1     (qspi_d1)    , 
                               .IO_qspi_io2     (qspi_d2)    , 
                               .IO_qspi_io3     (qspi_d3)    , 
                               //other
                               .o_addr          (addrb)    ,
                               .o_data          (dinb)    ,/*******未使用端口********/
                               .i_data          (doutb)    ,
                               .o_valid         (web)    ,
                               .i_valid         ()/*******未使用端口********/ 
                               );

endmodule
