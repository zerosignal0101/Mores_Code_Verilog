// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
// File name    : morse_code.v
// Module name  : morse_code
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
 
module morse_code (clk, rst, start_key_ori, sw_ctl, sw_val, kb_row, row, col_g, col_r, finish_flag, beep, seg_ctl, cat, kb_col);

   // input 
   input clk;
   input rst;
   input start_key_ori;
   input [3:0] sw_ctl;
   input [3:0] sw_val;
   input [3:0] kb_row;

   // output
   output [7:0] row;
   output [7:0] col_g;
   output [7:0] col_r;
   output finish_flag;
   output beep;
   output [7:0] seg_ctl;
   output [7:0] cat;
   output [3:0] kb_col;
   

   // variable
   reg start_flag;
   wire start_key;
   reg ack_finish;
   wire [63:0] seg_val;
   wire [63:0] seg_val_send;
   wire [7:0] send_val;
   
   // CONST
   reg [7:0] seg [9:0];
	initial                                                         //在过程块中只能给reg型变量赋值，Verilog中有两种过程块always和initial
	begin
		seg[0] = 8'h3f;                                           //对存储器中第一个数赋值9'b00_0011_1111,相当于共阴极接地，DP点变低不亮，7段显示数字  0
		seg[1] = 8'h06;                                           //7段显示数字  1
		seg[2] = 8'h5b;                                           //7段显示数字  2
		seg[3] = 8'h4f;                                           //7段显示数字  3
		seg[4] = 8'h66;                                           //7段显示数字  4
		seg[5] = 8'h6d;                                           //7段显示数字  5
		seg[6] = 8'h7d;                                           //7段显示数字  6
		seg[7] = 8'h07;                                           //7段显示数字  7
		seg[8] = 8'h7f;                                           //7段显示数字  8
		seg[9] = 8'h6f;                                           //7段显示数字  9
	end

   // init
   initial
   begin
      start_flag <= 0;
      ack_finish <= 0;
      cnt <= 3;
      process_finish <= 1;
   end

   assign seg_val = (sw_ctl[3]) ? processing_seg_val : (sw_ctl[2] ? {seg[sw_val], seg_val_send[47:0]} : seg_val_send);
   assign send_val = (sw_ctl[3])? ready_to_send_val : {sw_ctl, sw_val};
   assign processing_seg_val = {seg[cnt], 8'b0000_0000, seg[ready_to_send_val] ,8'b0000_0000 ,seg[mem_val[15:12]], seg[mem_val[11:8]], seg[mem_val[7:4]], seg[mem_val[3:0]]};

   // Control matrix
   seg_decoder u2(clk, rst, seg_val, seg_ctl, cat);

   morse_send u0(clk, rst, send_val, start_flag, row, col_g, col_r, finish_flag, beep, seg_val_send);
   // 2 -> should be send_val
   debounce u1(clk, rst, start_key_ori, start_key);

   // // test inf loops 
   // always @ (posedge clk or posedge start_key or posedge ack_finish) 
   // begin
   //    if (start_key) begin
   //       start_flag <= 1;
   //    end
   //    else if(ack_finish) begin
   //       start_flag <= 1;
   //    end
   //    else begin
   //       start_flag <= 0;
   //    end
   // end

   always @ (posedge clk or posedge finish_flag) begin
      if(finish_flag) begin
         ack_finish <= 1;
      end
      else begin
         ack_finish <= 0;
      end
   end

   // // Traditional start
   // always @ (posedge clk or posedge start_key or posedge rst) begin
   //    if(rst) begin
   //       start_flag <= 0;
   //    end
   //    else if(start_key) begin 
   //       start_flag <= 1;
   //    end
   //    else begin
   //       start_flag <= 0;
   //    end
   // end


   // Section for 11 10
   wire [15:0] mem_val;
   wire [63:0] processing_seg_val;
   wire [3:0] ready_to_send_val;
   reg [1:0] cnt;
   reg process_finish;

   read_matrix u3(clk, rst, kb_col, kb_row, mem_val);

   always @(posedge ack_finish or posedge rst) begin
      if(rst) begin
         cnt <= 3;
      end
      else if(ack_finish) begin
         if(sw_ctl[3]) begin
            if(cnt == 'b10) begin
               process_finish <= 1;
               cnt <= cnt + 1;
            end
            else begin
               cnt <= cnt + 1;
               process_finish <= 0;
            end
         end 
         else begin
            cnt <= cnt;
         end
      end
      else begin
         cnt <= cnt;
      end
   end

   assign ready_to_send_val = 
   sw_ctl[2] 
   ? (cnt[1] 
      ? (cnt[0] ? mem_val[3:0] : mem_val[11:8]) 
      : (cnt[0] ? mem_val[7:4] : mem_val[15:12]) ) 
   :  (cnt[1] 
      ? (cnt[0] ? mem_val[15:12] : mem_val[11:8] ) 
      : (cnt[0] ? mem_val[7:4] : mem_val[3:0]) ) ;

   always @(posedge clk or posedge start_key or posedge rst or posedge cnt[0] or posedge cnt[1] or posedge ack_finish) begin
      if(rst) begin
         start_flag <= 0;
      end
      else if(cnt[0] | cnt[1]) begin
         start_flag <= ack_finish & (~process_finish);
      end
      else if(start_key) begin 
         start_flag <= 1;
      end
      else begin
         start_flag <= 0;
      end
   end
   
endmodule