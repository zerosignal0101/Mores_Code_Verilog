// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
// File name    : morse_code_tb.v
// Module name  : morse_code_tb
// Author       : LXR
// Description  : testbench component.
// 
// --------------------------------------------------------------------
// Code Revision History : 
// --------------------------------------------------------------------
// Version: |Mod. Date:   |Changes Made:
// V1.0     |2023/11/15   |Initial ver
// --------------------------------------------------------------------
`timescale 100us / 1us



module morse_code_tb;
	
	parameter CLK_PERIOD = 10; 
 
	reg sys_clk;
	

	reg sys_rst_n;  //active low
	reg sys_key_n;
	reg [3:0] sw_val;
	reg [3:0] sw_ctl;

	wire [7:0] row;
	wire [7:0] col_g;
	wire [7:0] col_r;
	wire finish_flag;
	wire beep;
	wire ready_to_send_val;

	initial
	begin
		sw_val = 4'b0010;
		sw_ctl = 4'b1100;
		sys_rst_n = 0;
		sys_key_n = 0;
		#20000
		sys_key_n = 1;
		#1000
		sys_key_n = 0;
		#20000
		sys_key_n = 1;
		#1000
		sys_key_n = 0;
		#5000
		sys_key_n = 1;
		#1000
		sys_key_n = 0;
		#5000
		sys_key_n = 1;
		#1000
		sys_key_n = 0;
		#5000
		sys_key_n = 1;
		#1000
		sys_key_n = 0;
		#5000
		sys_key_n = 1;
		#1000
		sys_key_n = 0;
		#5000
		sys_key_n = 1;
		#1000
		sys_key_n = 0;
		#5000

		#100000

		$stop;
	end


	initial
		sys_clk = 1'b0;
	always
		sys_clk = #(CLK_PERIOD/2) ~sys_clk;



	morse_code u1(
		.clk(sys_clk),
		.rst(sys_rst_n),
		.start_key_ori(sys_key_n),
		.sw_ctl(sw_ctl),
		.sw_val(sw_val),
		.row(row),
		.col_g(col_g),
		.col_r(col_r),
		.finish_flag(finish_flag),
		.beep(beep),
		.ready_to_send_val(ready_to_send_val)
	);


endmodule