`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2019 05:46:50 PM
// Design Name: 
// Module Name: AWS_aes_top_tb
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
`timescale 1ns / 1ps

module aes_top_tb();

parameter   ram_data_width    =   8;
parameter   ram_addr_width    =   10;  
//INSTRUCTIONS  
localparam   INS_IDLE          =   8'b00000000  ; //00H
localparam   INS_W_STATE       =   8'b00000001  ; //01H
localparam   INS_R_STATE1      =   8'b00000101  ; //05H
localparam   INS_R_STATE2      =   8'b00110101  ; //35H
localparam   INS_WRITE_EN      =   8'b00000110  ; //06H
localparam   INS_WRITE_UNEN    =   8'b00000100  ; //04H
localparam   INS_Page_Program  =   8'b00000010  ; //02H
localparam   INS_DPage_Program =   8'b00000111  ; //07H
localparam   INS_QPage_Program =   8'b00110010  ; //32H
localparam   INS_Read_Date     =   8'b00000011  ; //03H
localparam   INS_FRead_Date    =   8'b00001011  ; //0BH
localparam   INS_FRead_Dual    =   8'b00111011  ; //3BH
localparam   INS_FRead_Quad    =   8'b01101011  ; //6BH

    reg [7:0] ad_data_in; 
    wire ADC_EN_N;
    wire ADC_CLK;
    wire led_en; 
    
    
    reg clka_0;
    reg rst_n;
    reg I_qspi_clk    ; // QPI×????????±????
    reg I_qspi_cs     ; // QPI×???????????
    reg R_qspi_io0 ;                
    reg R_qspi_io1 ;                
    reg R_qspi_io2 ;                
    reg R_qspi_io3 ;
    
    wire IO_qspi_io0 ; // QPI×???????/??????????
    wire IO_qspi_io1 ; // QPI×???????/??????????
    wire IO_qspi_io2 ; // QPI×???????/??????????
    wire IO_qspi_io3 ; // QPI×???????/??????????
    reg R_qspi_io0_out_en;
    reg R_qspi_io1_out_en;
    reg R_qspi_io2_out_en;
    reg R_qspi_io3_out_en; 
    //wire [ram_addr_width-1:0] ram_addr;
    //wire [ram_data_width-1:0] ram_din;
    //wire [ram_data_width-1:0] ram_dou;
    wire                      ram_ena;
    assign IO_qspi_io0     =   R_qspi_io0_out_en ? R_qspi_io0 :1'bz;                
    assign IO_qspi_io1     =   R_qspi_io1_out_en ? R_qspi_io1 :1'bz;                
    assign IO_qspi_io2     =   R_qspi_io2_out_en ? R_qspi_io2 :1'bz ;                
    assign IO_qspi_io3     =   R_qspi_io3_out_en ? R_qspi_io3 :1'bz ;
    wire    I_qspi_clk_d;
    reg [3:0] key_bus;
    assign   #2 I_qspi_clk_d = I_qspi_clk ;//*******2改为20*********//
    
        aes_top aes_top_dut(
                                .sclk(clka_0), 
                                .rst_n(rst_n), 
                                .key_bus(key_bus),  
                                .qspi_d0(IO_qspi_io0), 
                                .qspi_d1(IO_qspi_io1), 
                                .qspi_d2(IO_qspi_io2), 
                                .qspi_d3(IO_qspi_io3), 
                                .I_qspi_cs(I_qspi_cs), 
                                .I_qspi_clk(I_qspi_clk_d),
                                .ADC_EN_N(ADC_EN_N), 
                                .ADC_CLK(ADC_CLK), 
                                .led_en(led_en)
                                 );

    initial begin
    key_bus = 4'b1111;
    end   

    always begin/***两个 由5 改为10***/
    #5 clka_0 = 1;
    #5 clka_0 = 0;
    end

    integer i;
    integer j;
    integer k;
    reg [7:0] temp;

    initial begin
  //INITIAL
  #602;
  rst_n =1;
#20 rst_n = 0;
#20 rst_n = 1;
  I_qspi_cs = 1;
   I_qspi_clk = 0;
#20 I_qspi_clk = 1;
#20 I_qspi_clk = 0;
  #500;
  I_qspi_cs = 0;
  #50;

for (k=0;k>=0;k=k-1) begin
  //ins:QPage_Program
  #100;
  #20 I_qspi_cs = 0;
  R_qspi_io0_out_en = 1;
  R_qspi_io1_out_en = 1;
  R_qspi_io2_out_en = 1;
  R_qspi_io3_out_en = 1;
  temp = INS_QPage_Program;
  for (i=7;i>=0;i=i-1) begin
  R_qspi_io0 = temp[i];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  //address[31:24]
  temp = {8'b00000000};
  for (i=7;i>=0;i=i-4) begin
  R_qspi_io3 = temp[i-3];
  R_qspi_io2 = temp[i-2];
  R_qspi_io1 = temp[i-1];
  R_qspi_io0 = temp[i];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  //address[23:16]
  temp = {8'b00000000};
  for (i=7;i>=0;i=i-4) begin
  R_qspi_io3 = temp[i-3];
  R_qspi_io2 = temp[i-2];
  R_qspi_io1 = temp[i-1];
  R_qspi_io0 = temp[i];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  //address[15:8]
  temp = {8'b00000000};
  for (i=7;i>=0;i=i-4) begin
  R_qspi_io3 = temp[i-3];
  R_qspi_io2 = temp[i-2];
  R_qspi_io1 = temp[i-1];
  R_qspi_io0 = temp[i];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  //address[7:0]
  temp = {8'b10000000};
  for (i=7;i>=0;i=i-4) begin
  R_qspi_io3 = temp[i-3];
  R_qspi_io2 = temp[i-2];
  R_qspi_io1 = temp[i-1];
  R_qspi_io0 = temp[i];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  // QDummy/**空闲节拍4个**/
  temp = {8'b00000000};
  for (i=7;i>=0;i=i-2) begin
  R_qspi_io3 = temp[i-3];
  R_qspi_io2 = temp[i-2];
  R_qspi_io1 = temp[i-1];
  R_qspi_io0 = temp[i];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  //data[7:0]
  //#20  I_qspi_clk = 1;
  //#20  I_qspi_clk = 0;
  R_qspi_io0_out_en = 1;
  R_qspi_io1_out_en = 1;
  R_qspi_io2_out_en = 1;
  R_qspi_io3_out_en = 1;
  temp = {8'b00110001};//0x31
  for (j=4;j>0;j=j-1) begin
  for (i=7;i>=0;i=i-4) begin
  R_qspi_io0 = temp[i-3];
  R_qspi_io1 = temp[i-2]; 
  R_qspi_io2 = temp[i-1];
  R_qspi_io3 = temp[i  ];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  temp = temp + 1;
  end
  #30  I_qspi_cs = 1;
  R_qspi_io0_out_en = 1;
  R_qspi_io1_out_en = 1;
  R_qspi_io2_out_en = 1;
  R_qspi_io3_out_en = 1;

#300000 ;

/******************************************************************************************************************************************************************************************/

  //ins:FRead_Quad
  #20 I_qspi_cs = 0;
  R_qspi_io0_out_en = 1;
  temp = INS_FRead_Quad;
  for (i=7;i>=0;i=i-1) begin
  R_qspi_io0 = temp[i];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  //address[31:24]
  temp = {8'b00000000};
  for (i=7;i>=0;i=i-4) begin
  R_qspi_io3 = temp[i-3];
  R_qspi_io2 = temp[i-2];
  R_qspi_io1 = temp[i-1];
  R_qspi_io0 = temp[i];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  //address[23:16]
  temp = {8'b00000000};
  for (i=7;i>=0;i=i-4) begin
  R_qspi_io3 = temp[i-3];
  R_qspi_io2 = temp[i-2];
  R_qspi_io1 = temp[i-1];
  R_qspi_io0 = temp[i];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  //address[15:8]
  temp = {8'b00000000};
  for (i=7;i>=0;i=i-4) begin
  R_qspi_io3 = temp[i-3];
  R_qspi_io2 = temp[i-2];
  R_qspi_io1 = temp[i-1];
  R_qspi_io0 = temp[i];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  //address[7:0]
  temp = {8'b00000001};
  for (i=7;i>=0;i=i-4) begin
  R_qspi_io0 = temp[i-3];
  R_qspi_io1 = temp[i-2];
  R_qspi_io2 = temp[i-1];
  R_qspi_io3 = temp[i];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  //DUMMY[7:0]
  temp = {8'b00000000};
  for (i=7;i>=0;i=i-2) begin
  R_qspi_io0 = temp[i-3];
  R_qspi_io1 = temp[i-2];
  R_qspi_io2 = temp[i-1];
  R_qspi_io3 = temp[i];
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  //data[7:0]
  R_qspi_io0_out_en = 0;
  R_qspi_io1_out_en = 0;
  R_qspi_io2_out_en = 0;
  R_qspi_io3_out_en = 0;
  for (j=17;j>0;j=j-1) begin
  for (i=7;i>=0;i=i-4) begin
  #20  I_qspi_clk = 1;
  #20  I_qspi_clk = 0;
  end
  end
  #30  I_qspi_cs = 1;
  R_qspi_io0_out_en = 1;
  R_qspi_io1_out_en = 1;
  R_qspi_io2_out_en = 1;
  R_qspi_io3_out_en = 1;
  
#300000 ;


end
  #20 $stop;
    end
    

                                 
endmodule
