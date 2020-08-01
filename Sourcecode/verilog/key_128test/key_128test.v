`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/27 15:21:27
// Design Name: 
// Module Name: key_diver
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
module key_128test(
     input sclk,
     input rst_n,
     input [3:0] key_bus,
     output key_data,
     output en
   );
  
   reg en;
   reg [127:0] key_data;
   reg [4:0] count5;
     
   always@(posedge sclk or negedge rst_n)//////第一组
       begin
           if(!rst_n)
               begin
                   key_data[31:0] <= 0;
               end
           else
               begin
                    if(key_bus[0] == 1)
                         key_data[31:0] <= 32'hffff_ffff;
                    else
                         key_data[31:0]<= 0;
               end
        end
        
   always@(posedge sclk or negedge rst_n)/////第二组
            begin
                if(!rst_n)
                    begin
                        key_data[63:32] <= 0;
                    end
                else
                    begin
                         if(key_bus[1] == 1)
                              key_data[63:32] <= 32'hffff_ffff;
                         else
                              key_data[63:32]<= 0;
                    end
             end
             
   always@(posedge sclk or negedge rst_n)/////第三组
                      begin
                          if(!rst_n)
                              begin
                                  key_data[95:64] <= 0;
                              end
                          else
                              begin
                                   if(key_bus[2] == 1)
                                        key_data[95:64] <= 32'hffff_ffff;
                                   else
                                        key_data[95:64]<= 0;
                              end
                       end
                       
   always@(posedge sclk or negedge rst_n)/////第四组
                                          begin
                                              if(!rst_n)
                                                  begin
                                                      key_data[127:96] <= 0;
                                                  end
                                              else
                                                  begin
                                                       if(key_bus[3] == 1)
                                                            key_data[127:96]  <= 32'hffff_ffff;
                                                       else
                                                            key_data[127:96] <= 0;
                                                  end
                                           end             
        
     always@(posedge sclk or negedge rst_n)
      begin
        if(!rst_n)
           begin
               count5 <= 0;
               en <= 0;
            end
          else
            begin
              if(count5 < 5'b1_1111)
                 begin
                   count5 <= count5 + 1;
                   en <= 0;
                  end
                else
                   begin
                     count5 <= 0;
                     en <= 1;
                   end
             end
         end
endmodule
