`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2019 09:37:44 AM
// Design Name: 
// Module Name: ram_count
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


module ram_count(clk, rst_n, aes_done, ram_128text_in, ram_write_en, ram_addr, ram_data);

    input clk;
    input rst_n;
    input aes_done;
    input [127:0] ram_128text_in;   
    output reg ram_write_en;
    output reg [7:0] ram_addr;
    output reg [7:0] ram_data;
    
    reg en;
    reg [3:0] count, count1;
    reg [7:0] data0, data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, data13, data14, data15;
    
    always@(posedge clk or negedge rst_n)//128转8位寄存器
    begin
        if(!rst_n)
            begin
                data0 <= 0;
                data1 <= 0;
                data2 <= 0;
                data3 <= 0;
                data4 <= 0;
                data5 <= 0;
                data6 <= 0;
                data7 <= 0;
                data8 <= 0;
                data9 <= 0;
                data10 <= 0;
                data11 <= 0;
                data12 <= 0;
                data13 <= 0;
                data14 <= 0;
                data15 <= 0;
            end    
        else
        begin 
        if(aes_done)
            begin
                data0 <= ram_128text_in[7:0];
                data1 <= ram_128text_in[15:8];
                data2 <= ram_128text_in[23:16];
                data3 <= ram_128text_in[31:24];
                data4 <= ram_128text_in[39:32];
                data5 <= ram_128text_in[47:40];
                data6 <= ram_128text_in[55:48];
                data7 <= ram_128text_in[63:56];
                data8 <= ram_128text_in[71:64];
                data9 <= ram_128text_in[79:72];
                data10 <= ram_128text_in[87:80];
                data11 <= ram_128text_in[95:88];
                data12 <= ram_128text_in[103:96];
                data13 <= ram_128text_in[111:104];
                data14 <= ram_128text_in[119:112];
                data15 <= ram_128text_in[127:120];
            end
        else
            begin
                data0 <= data0;
                data1 <= data1;
                data2 <= data2;
                data3 <= data3;
                data4 <= data4;
                data5 <= data5;
                data6 <= data6;
                data7 <= data7;
                data8 <= data8;
                data9 <= data9;
                data10 <= data10;
                data11 <= data11;
                data12 <= data12;
                data13 <= data13;
                data14 <= data14;
                data15 <= data15;                
            end
        end    
    end
    
    always@(posedge clk or negedge rst_n)//RAM写使能地址控制2段状态机控制第一部分
    begin 
        if(!rst_n)
            begin
                en <= 0;
            end
        else
            begin
                if(aes_done)
                 begin
                    en <= 1;
                 end
                else if(count < 4'b1111)
                 begin
                    en <= en;
                 end
                else
                 begin
                    en <= 0;
                 end
            end 
    end            

    always@(posedge clk or negedge rst_n)//RAM写使能地址控制2段状态机控制第二部分
    begin 
        if(!rst_n)
            begin
                count <= 0;
                ram_write_en <= 0;
                ram_addr <= 8'b0000_0001;
            end
        else
            begin
                if(aes_done)
                    begin
                        ram_write_en <= 1;
                        count <= count + 1;
                        ram_addr <= ram_addr + 1;
                    end
                else if(en)
                    begin
                        ram_write_en <= 1;
                        count <= count + 1;
                        ram_addr <= ram_addr + 1;
                    end
                else
                    begin
                        ram_write_en <= 0;
                        count <= 0;
                        ram_addr <= 8'b0000_0001;                    
                    end
            end
    end
    
    always@(posedge clk or negedge rst_n)//RAM数据控制2段状态机控制第一部分
    begin
        if(!rst_n)
            begin
                count1 <= 0;
            end
        else
            begin
                if(ram_write_en)
                    count1 <= count1 + 1;
                else
                    count1 <= 0;
            end
    end
    
    always@(posedge clk or negedge rst_n)//RAM数据控制2段状态机控制第二部分
    begin
        if(!rst_n)
            begin
                ram_data <= 0;
            end
        else
            begin
                case(count)
                     4'b0000:    ram_data <= data0;
                     4'b0001:    ram_data <= data1;
                     4'b0010:    ram_data <= data2;
                     4'b0011:    ram_data <= data3;
                     
                     4'b0100:    ram_data <= data4;
                     4'b0101:    ram_data <= data5;
                     4'b0110:    ram_data <= data6;
                     4'b0111:    ram_data <= data7;
                     
                     4'b1000:    ram_data <= data8;
                     4'b1001:    ram_data <= data9;
                     4'b1010:    ram_data <= data10;
                     4'b1011:    ram_data <= data11;
                    
                     4'b1100:    ram_data <= data12;
                     4'b1101:    ram_data <= data13;
                     4'b1110:    ram_data <= data14;
                     4'b1111:    ram_data <= data15;
            
                    default: ram_data <= ram_data;
                endcase
            end
    end
    
endmodule
