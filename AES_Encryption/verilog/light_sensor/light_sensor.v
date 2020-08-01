`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/26 10:59:07
// Design Name: 
// Module Name: light_sensor
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


module light_sensor(
    input [7:0] ad_data,
    input sclk,
    input rst_n,
    input KEY_DONE,
    output ADC_EN_N,
    output ADC_CLK,
    output led_en,
    output [127:0] data128,
    output data128_en,
    output clk_out50M,
    output clk_out25M
    );
    
    wire led_open, ad_data_1,ADC_CLK_90,locked;
    reg [7:0] data1;
    
    assign led_en = led_open;
    
    clk_wiz_0 clk_wiz_0_inst(// Clock in ports
      // Clock out ports
     .clk_out1(ADC_CLK),
     .clk_out2(ADC_CLK_90),
     .clk_out3(clk_out50M),     // output clk_out3
     .clk_out4(clk_out25M),     // output clk_out4
      // Status and control signals
     .reset(!rst_n),
     .locked(locked),
     .clk_in1(sclk)
     );
     
    ad_drive ad_drive_inst(
               .KEY_DONE(KEY_DONE),
               .ad_data(ad_data),
               .rst_n(rst_n),
               .locked(locked),
               .ADC_CLK_90(ADC_CLK_90),
               .ADC_EN_N(ADC_EN_N),
               .data128(data128),
               .data128_en0(data128_en),
               .led_open(led_open)
               );                                

endmodule
