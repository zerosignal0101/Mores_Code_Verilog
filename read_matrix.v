// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
// File name    : read_matrix.v
// Module name  : read_matrix
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
 
module read_matrix (clk, rst, kb_col, kb_row, mem_val);
 
   // input 
   input clk;
   input rst;
   input [3:0] kb_row;

   // output
   output reg [3:0] kb_col;
   output [15:0] mem_val;

   // variable
   wire [3:0] kb_key_ori [3:0];
   wire [3:0] kb_key_pulse [3:0];
   reg [1:0] cnt;
   reg [3:0] read_val [3:0];

   // init
   initial
   begin
      read_val[0] <= 'b0000;
      read_val[1] <= 'b0000;
      read_val[2] <= 'b0000;
      read_val[3] <= 'b0000;
      cnt <= 0;
   end

   // Main verilog
   always @(posedge clk) begin
      cnt <= cnt + 1;
   end

   always @(posedge clk) begin
      case (cnt) 
         0 : kb_col <= 'b0111;
         1 : kb_col <= 'b1011;
         2 : kb_col <= 'b1101;
         3 : kb_col <= 'b1110;
      endcase
   end

   assign mem_val = {read_val[3], read_val[2], read_val[1], read_val[0]};

   assign kb_key_ori[0][0] = kb_col[0] ? kb_key_ori[0][0] : (~kb_row[0]);
   assign kb_key_ori[0][1] = kb_col[1] ? kb_key_ori[0][1] : (~kb_row[0]);
   assign kb_key_ori[0][2] = kb_col[2] ? kb_key_ori[0][2] : (~kb_row[0]);
   assign kb_key_ori[0][3] = kb_col[3] ? kb_key_ori[0][3] : (~kb_row[0]);

   assign kb_key_ori[1][0] = kb_col[0] ? kb_key_ori[1][0] : (~kb_row[1]);
   assign kb_key_ori[1][1] = kb_col[1] ? kb_key_ori[1][1] : (~kb_row[1]);
   assign kb_key_ori[1][2] = kb_col[2] ? kb_key_ori[1][2] : (~kb_row[1]);
   assign kb_key_ori[1][3] = kb_col[3] ? kb_key_ori[1][3] : (~kb_row[1]);

   assign kb_key_ori[2][0] = kb_col[0] ? kb_key_ori[2][0] : (~kb_row[2]);
   assign kb_key_ori[2][1] = kb_col[1] ? kb_key_ori[2][1] : (~kb_row[2]);
   assign kb_key_ori[2][2] = kb_col[2] ? kb_key_ori[2][2] : (~kb_row[2]);
   assign kb_key_ori[2][3] = kb_col[3] ? kb_key_ori[2][3] : (~kb_row[2]);

   assign kb_key_ori[3][0] = kb_col[0] ? kb_key_ori[3][0] : (~kb_row[3]);
   assign kb_key_ori[3][1] = kb_col[1] ? kb_key_ori[3][1] : (~kb_row[3]);
   assign kb_key_ori[3][2] = kb_col[2] ? kb_key_ori[3][2] : (~kb_row[3]);
   assign kb_key_ori[3][3] = kb_col[3] ? kb_key_ori[3][3] : (~kb_row[3]);

   debounce u0(clk, rst, kb_key_ori[0][0], kb_key_pulse[0][0]);
   debounce u1(clk, rst, kb_key_ori[0][1], kb_key_pulse[0][1]);
   debounce u2(clk, rst, kb_key_ori[0][2], kb_key_pulse[0][2]);
   debounce u3(clk, rst, kb_key_ori[0][3], kb_key_pulse[0][3]);

   debounce u4(clk, rst, kb_key_ori[1][0], kb_key_pulse[1][0]);
   debounce u5(clk, rst, kb_key_ori[1][1], kb_key_pulse[1][1]);
   debounce u6(clk, rst, kb_key_ori[1][2], kb_key_pulse[1][2]);
   debounce u7(clk, rst, kb_key_ori[1][3], kb_key_pulse[1][3]);

   debounce u8(clk, rst, kb_key_ori[2][0], kb_key_pulse[2][0]);
   debounce u9(clk, rst, kb_key_ori[2][1], kb_key_pulse[2][1]);
   debounce u10(clk, rst, kb_key_ori[2][2], kb_key_pulse[2][2]);
   debounce u11(clk, rst, kb_key_ori[2][3], kb_key_pulse[2][3]);

   debounce u12(clk, rst, kb_key_ori[3][0], kb_key_pulse[3][0]);
   debounce u13(clk, rst, kb_key_ori[3][1], kb_key_pulse[3][1]);
   debounce u14(clk, rst, kb_key_ori[3][2], kb_key_pulse[3][2]);
   debounce u15(clk, rst, kb_key_ori[3][3], kb_key_pulse[3][3]);

   always @(posedge clk or posedge rst) begin
      if(rst) begin
         read_val[0] <= 0;
         read_val[1] <= 0;
         read_val[2] <= 0;
         read_val[3] <= 0;
      end 
      else if(kb_key_pulse[0][0]) begin
         read_val[0][0] = ~read_val[0][0];
      end
      else if(kb_key_pulse[0][1]) begin
         read_val[0][1] = ~read_val[0][1];
      end
      else if(kb_key_pulse[0][2]) begin
         read_val[0][2] = ~read_val[0][2];
      end
      else if(kb_key_pulse[0][3]) begin
         read_val[0][3] = ~read_val[0][3];
      end

      
      else if(kb_key_pulse[1][0]) begin
         read_val[1][0] = ~read_val[1][0];
      end
      else if(kb_key_pulse[1][1]) begin
         read_val[1][1] = ~read_val[1][1];
      end
      else if(kb_key_pulse[1][2]) begin
         read_val[1][2] = ~read_val[1][2];
      end
      else if(kb_key_pulse[1][3]) begin
         read_val[1][3] = ~read_val[1][3];
      end

      else if(kb_key_pulse[2][0]) begin
         read_val[2][0] = ~read_val[2][0];
      end
      else if(kb_key_pulse[2][1]) begin
         read_val[2][1] = ~read_val[2][1];
      end
      else if(kb_key_pulse[2][2]) begin
         read_val[2][2] = ~read_val[2][2];
      end
      else if(kb_key_pulse[2][3]) begin
         read_val[2][3] = ~read_val[2][3];
      end

      else if(kb_key_pulse[3][0]) begin
         read_val[3][0] = ~read_val[3][0];
      end
      else if(kb_key_pulse[3][1]) begin
         read_val[3][1] = ~read_val[3][1];
      end
      else if(kb_key_pulse[3][2]) begin
         read_val[3][2] = ~read_val[3][2];
      end
      else if(kb_key_pulse[3][3]) begin
         read_val[3][3] = ~read_val[3][3];
      end
      
      
   end
   
endmodule