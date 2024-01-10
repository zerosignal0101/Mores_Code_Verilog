// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
// File name    : debounce.v
// Module name  : debounce
// Author       : nickwald
// Description  : 
// Web          : www.nickwald.top
// 
// --------------------------------------------------------------------
// Code Revision History : 
// --------------------------------------------------------------------
// Version: |Mod. Date:   |Changes Made:
// V1.0     |2023/11/15   |Initial ver
// --------------------------------------------------------------------
// Module Function:按键消抖
 
module debounce (clk,reset,btn0,press);
 
   // input 
   input clk;
   input reset;
   input btn0;

   // output
   output reg press;

   // variable
   reg stable_flag;
   reg [8:0] cnt_time;

   // init
   initial
   begin
      stable_flag <= 0;
      cnt_time <= 0;
   end

   always @(posedge clk or posedge reset) begin
      if (reset == 1'b1) begin
         cnt_time <= 3'b000;
      end else if (cnt_time == 'b11111) begin
         cnt_time <= 3'b000;
      end else if (btn0 == 1'b1) begin
         cnt_time <= cnt_time + 3'b001;
      end else begin
         cnt_time <= 3'b000;
      end
   end

   always @(posedge clk or posedge reset) begin
      if (reset == 1'b1) begin
         stable_flag <= 1'b0;
      end else if (btn0 == 1'b1 && cnt_time == 'b11111) begin
         stable_flag <= 1'b1;
      end else if (btn0 == 1'b0) begin
         stable_flag <= 1'b0;
      end
   end

   always @(posedge clk or posedge reset) begin
      if (reset == 1'b1) begin
         press <= 1'b0;
      end else if (stable_flag == 1'b0 && cnt_time == 'b11111) begin
         press <= 1'b1;
      end else begin
         press <= 1'b0;
      end
   end
   
endmodule