// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
// File name    : seg_decoder.v
// Module name  : seg_decoder
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
 
module seg_decoder (clk, rst, seg_val , seg_ctl, cat);

   // input 
   input clk;
   input rst;
   input [63:0] seg_val;

   // output
   output reg [7:0] seg_ctl;
   output reg [7:0] cat;

   // variable
   reg [2:0] cnt;

   // init
   initial
   begin
      seg_ctl <= 0;
      cat <= 8'b1111_1111;
      cnt <= 0;
   end

   // Main
   always @ (posedge clk or posedge rst) 
   begin 
      if(rst) begin
         cnt <= 0;
      end
      else 
         cnt = cnt + 1;
   end


   always @ (posedge clk or posedge rst)
   begin
      if(rst) begin
         seg_ctl <= 0;
         cat <= 8'b1111_1111;
      end
      else begin
         case (cnt)
            0 : begin
               cat <= 'b1111_1110;
               seg_ctl <= seg_val[7:0];
            end
            1 : begin
               cat <= 'b1111_1101;
               seg_ctl <= seg_val[15:8];
            end
            2 : begin 
               cat <= 'b1111_1011;
               seg_ctl <= seg_val[23:16];
            end
            3 : begin 
               cat <= 'b1111_0111;
               seg_ctl <= seg_val[31:24];
            end
            4 : begin 
               cat <= 'b1110_1111;
               seg_ctl <= seg_val[39:32];
            end
            5 : begin 
               cat <= 'b1101_1111;
               seg_ctl <= seg_val[47:40];
            end
            6 : begin 
               cat <= 'b1011_1111;
               seg_ctl <= seg_val[55:48];
            end
            7 : begin 
               cat <= 'b0111_1111;
               seg_ctl <= seg_val[63:56];
            end
         endcase
      end
   end

   
endmodule