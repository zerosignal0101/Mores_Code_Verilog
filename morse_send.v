// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
// File name    : morse_send.v
// Module name  : morse_send
// Author       : zeroSignal
// Description  : 
// Web          : 
// 
// --------------------------------------------------------------------
// Code Revision History : 
// --------------------------------------------------------------------
// Version: |Mod. Date:   |Changes Made:
// V1.0     |2023/11/15   |Initial ver
// --------------------------------------------------------------------
 
module morse_send (clk, rst, val, start_flag, row, col_g, col_r, finish_flag, beep, seg_val);

   // input 
   input clk;
   input rst;
   input [7:0] val;
   input start_flag;

   // output
   output reg [7:0] row;
   output reg [7:0] col_g;
   output reg [7:0] col_r;
   output reg finish_flag;
   output beep;
   output reg [63:0] seg_val; 

   // variable
   // reg [7:0] cnt_row;
   // reg [7:0] cnt_col;
   reg [32:0] data;
   reg [32:0] hold_zero;
   reg [7:0] cnt;
   reg [2:0] cnt_row;
   reg [7:0] cnt_time;
   wire clk_k;
   reg en_beep;
   reg [15:0] running;

   divider u0(clk, start_flag, clk_k);

   // init
   initial
   begin
      row <= 8'b1111_1111;
      col_g <= 8'b0000_0000;
      col_r <= 8'b0000_0000;
      finish_flag <= 0;
      cnt <= 0;
      cnt_time <= 0;
      cnt_row <= 0;
      en_beep <= 0;
      running <= 0;
      seg_val <= 0;
      hold_zero <= 'h0000_0000;
   end

   assign beep = en_beep ? clk : 0;

   // Control matrix
   always @ (posedge clk or posedge start_flag ) 
   begin
      if(start_flag) begin 
         row <= 8'b1111_1111;
         cnt_row <= 0;
      end
      else begin
         row <= ~(8'b1000_0000>>cnt_row);
         cnt_row <= cnt_row + 1;
      end
   end

   always @ (posedge start_flag or posedge clk_k or posedge rst) 
   begin
      if(rst) begin
         col_g <= 8'b0000_0000;
         col_r <= 8'b0000_0000;
         cnt <= 0;
         cnt_time <= 0; 
         finish_flag <= 0;
         en_beep <= 0;
         data <= 'h0000_0000;
         running <= 0;
         hold_zero <= 0;
         seg_val <= 0;
      end
      else if(start_flag) begin
         col_g <= 8'b0000_0000;
         col_r <= 8'b0000_0000;
         cnt <= 0;
         cnt_time <= 0; 
         finish_flag <= 0;
         en_beep <= 0;
         case (val)
            0 : begin 
               data <= 5'b11111;
               hold_zero <= 5'b00000;
               running <= 5;
            end 
            1 : begin 
               data <= 5'b11110;
               hold_zero <= 5'b00000;
               running <= 5;
            end
            2 : begin 
               data <= 5'b11100;
               hold_zero <= 5'b00000;
               running <= 5;
            end
            3 : begin 
               data <= 5'b11000;
               hold_zero <= 5'b00000;
               running <= 5;
            end
            4 : begin 
               data <= 5'b10000;
               hold_zero <= 5'b00000;
               running <= 5;
            end
            5 : begin 
               data <= 5'b00000;
               hold_zero <= 5'b00000;
               running <= 5;
            end
            6 : begin 
               data <= 5'b00001;
               hold_zero <= 5'b00000;
               running <= 5;
            end
            7 : begin 
               data <= 5'b00011;
               hold_zero <= 5'b00000;
               running <= 5;
            end
            8 : begin 
               data <= 5'b00111;
               hold_zero <= 5'b00000;
               running <= 5;
            end
            9 : begin 
               data <= 5'b01111;
               hold_zero <= 5'b00000;
               running <= 5;
            end
            65 : begin
               data <= 'b00001110000;
               hold_zero <= 'b00010001000;
               running <= 11;
            end
            66 : begin
               data <= 'b010001110000100;
               hold_zero <= 'b000000000000000;
               running <= 15;
            end
            255 : begin
               data <= 'b0;
               hold_zero <= 'b1;
               running <= 1;
            end
            
         endcase
      end 
      else if(running != 0) begin
         if(cnt == running) begin
            data <= 'h0000_0000;
            col_g <= 8'b0000_0000;
            col_r <= 8'b0000_0000;
            
            cnt <= 0;
            cnt_time <= 0;
            running <= 0;
         end
         else if(data[cnt]) begin
            if(cnt_time != 3) begin
               col_g <= 8'b1111_1111;
               col_r <= 8'b1111_1111;
               if(cnt_time == 0) begin
                  seg_val <= seg_val << 8;
                  seg_val[3] = 1;
               end
               en_beep <= 1;
               cnt_time <= cnt_time + 1;
            end 
            else begin
               col_g <= 8'b0000_0000;
               col_r <= 8'b0000_0000;
               
               en_beep <= 0;
               cnt_time <= 0;
               cnt <= cnt + 1;
            end
         end
         else if(hold_zero[cnt] != 1) begin
            if(cnt_time != 1) begin
               // if(!hold_zero[cnt]) begin
               //    col_g <= 8'b1111_1111;
               //    col_r <= 8'b1111_1111;
               //    seg_val <= seg_val << 8;
               //    seg_val[7] = 1;
               //    en_beep <= 1;
               //    cnt_time <= cnt_time + 1;
               // end
               // else begin
               //    cnt_time <= cnt_time + 1;
               // end
               // // Unable to function well
               col_g <= 8'b1111_1111;
               col_r <= 8'b1111_1111;
               seg_val <= seg_val << 8;
               seg_val[7] = 1;
               en_beep <= 1;
               cnt_time <= cnt_time + 1;
               
            end 
            else begin
               col_g <= 8'b0000_0000;
               col_r <= 8'b0000_0000;
               
               en_beep <= 0;
               cnt_time <= 0;
               cnt <= cnt + 1;
            end
         end
         else begin
            if(cnt_time != 1) 
               cnt_time <= cnt_time + 1;
            else begin
               cnt_time <= 0;
               cnt <= cnt + 1;
            end
         end
      end
      else if(running == 0) begin
         finish_flag <= 1;
      end
   end  

   
endmodule