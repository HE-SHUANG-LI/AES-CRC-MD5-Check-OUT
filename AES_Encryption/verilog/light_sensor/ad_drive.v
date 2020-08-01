`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/26 13:03:04
// Design Name: 
// Module Name: ad_drive
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


module ad_drive(
    input KEY_DONE,
    input [7:0] ad_data,
    input rst_n,
    input locked,
    input ADC_CLK_90,
    output reg ADC_EN_N,
    output data128,
    output data128_en0,
    output reg led_open
    );
    
    reg [2:0] count;
    reg [2:0] count1;
    reg [7:0] ad_data_0;
    reg aes_ok;
    reg [127:0] data128;
    reg en1, en2, en3;
    reg data128_en;
    reg [7:0] ad_data_8;
    
    always@(posedge ADC_CLK_90 or negedge rst_n)
    begin
        if(!rst_n)
            aes_ok <= 0;
        else if(KEY_DONE && locked)
            aes_ok <= 1;
        else
            aes_ok <= aes_ok;
    
    end
    
     always@(posedge ADC_CLK_90 or negedge rst_n)
       begin
           if(!rst_n)
               begin
                   count <= 0;
                   ad_data_0 <= 8'b0;
               end
           else 
             begin
                if(count == 3'b111 && locked && aes_ok)
                       begin
                            count <= 0;
                            ad_data_0 <= ad_data;
                       end
                 else if(locked)
                       begin
                            count <= count + 1;
                            ad_data_0 <= ad_data_0;
                       end
             end  
       end
       
       
       always@(posedge ADC_CLK_90 or negedge rst_n)
              begin
                  if(!rst_n)
                      begin
                          ADC_EN_N <= 0;
                          count1 <= 0;
                      end
                  else
                      begin
                          if(count1 == 3'b110 && locked && aes_ok)
                              begin
                                   count1 <= count1 + 1;
                                   ADC_EN_N <= 1;
                              end
                            else if(count1 == 3'b111 && locked)
                               begin
                                   ADC_EN_N <= 0;
                                   count1 <= 0;
                                end
                             else if(locked)
                                begin
                                    ADC_EN_N <= 0;
                                    count1 <= count1 + 1;
                                end
                      end
              end
              
     always@(posedge ADC_CLK_90 or negedge rst_n)
              begin
                  if(!rst_n)
                      begin
                          led_open <= 0;
                      end
                  else
                      begin
                          if(ad_data_0 > 8'b00001111)
                              led_open <= 1;
                           else
                              led_open <= 0;
                      end
              end
              
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////              

              
              assign data128_en0 = en3 & data128_en;
              
              always@(posedge ADC_CLK_90 or negedge rst_n)
              begin
                if(!rst_n)
                    ad_data_8 <= 0;
                else
                    ad_data_8 <= ad_data_0;
              end
                           
              always@(posedge ADC_CLK_90 or negedge rst_n)
                                  begin
                                      if(!rst_n)
                                          begin
                                              en1 <= 0;
                                              en2 <= 0;
                                              en3 <= 0;
                                          end
                                      else
                                          begin
                                             en1 <= ADC_EN_N;
                                             en2 <= en1;
                                             en3 <= en2;
                                          end
                                   end 
                                   
        always@(posedge ADC_CLK_90 or negedge rst_n)
        begin
            if(!rst_n)    
                data128_en <= 0;
            else if(en2)
                data128_en <= 1;
            else
                data128_en <= data128_en;
        end                                          

        always@(posedge ADC_CLK_90 or negedge rst_n)///////////11111111111111
        begin
            if(!rst_n)    
                data128[15:0] <= 0;
            else if(en2 && (ad_data_8[0] == 1))
                data128[15:0] <= 16'hffff;
            else if(en2 && (ad_data_8[0] == 0))
                data128[15:0] <= 0;    
            else
                data128[15:0] <= data128[15:0];
        end        

        always@(posedge ADC_CLK_90 or negedge rst_n)/////////////22222222222222
        begin
            if(!rst_n)    
                data128[31:16] <= 0;
            else if(en2 && (ad_data_8[1] == 1))
                data128[31:16] <= 16'hffff;
            else if(en2 && (ad_data_8[1] == 0))
                data128[31:16] <= 0;
            else
                data128[31:16] <= data128[31:16];
        end
 
        always@(posedge ADC_CLK_90 or negedge rst_n)///////////33333333333333
        begin
            if(!rst_n)    
                data128[47:32] <= 0;
            else if(en2 && (ad_data_8[2] == 1))
                data128[47:32] <= 16'hffff;
            else if(en2 && (ad_data_8[2] == 0))
                data128[47:32] <= 0;    
            else
                data128[47:32] <= data128[47:32];
        end        

        always@(posedge ADC_CLK_90 or negedge rst_n)/////////////4444444444444
        begin
            if(!rst_n)    
                data128[63:48] <= 0;
            else if(en2 && (ad_data_8[3] == 1))
                data128[63:48] <= 16'hffff;
            else if(en2 && (ad_data_8[3] == 0))
                data128[63:48] <= 0;
            else
                data128[63:48] <= data128[63:48];
        end

        always@(posedge ADC_CLK_90 or negedge rst_n)///////////55555555555555
        begin
            if(!rst_n)    
                data128[79:64] <= 0;
            else if(en2 && (ad_data_8[4] == 1))
                data128[79:64] <= 16'hffff;
            else if(en2 && (ad_data_8[4] == 0))
                data128[79:64] <= 0;    
            else
                data128[79:64] <= data128[79:64];
        end        

        always@(posedge ADC_CLK_90 or negedge rst_n)/////////////66666666666666
        begin
            if(!rst_n)    
                data128[95:80] <= 0;
            else if(en2 && (ad_data_8[5] == 1))
                data128[95:80] <= 16'hffff;
            else if(en2 && (ad_data_8[5] == 0))
                data128[95:80] <= 0;
            else
                data128[95:80] <= data128[95:80];
        end
 
        always@(posedge ADC_CLK_90 or negedge rst_n)///////////7777777777777
        begin
            if(!rst_n)    
                data128[111:96] <= 0;
            else if(en2 && (ad_data_8[6] == 1))
                data128[111:96] <= 16'hffff;
            else if(en2 && (ad_data_8[6] == 0))
                data128[111:96] <= 0;    
            else
                data128[111:96] <= data128[111:96];
        end        

        always@(posedge ADC_CLK_90 or negedge rst_n)/////////////888888888888
        begin
            if(!rst_n)    
                data128[127:112] <= 0;
            else if(en2 && (ad_data_8[7] == 1))
                data128[127:112] <= 16'hffff;
            else if(en2 && (ad_data_8[7] == 0))
                data128[127:112] <= 0;
            else
                data128[127:112] <= data128[127:112];
        end

endmodule
