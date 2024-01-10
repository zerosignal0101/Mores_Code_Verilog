// ********************************************************************
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// ********************************************************************
// File name    : divider.v
// Module name  : divider
// Author       : LXR
// Description  : divider component.
// 
// --------------------------------------------------------------------
// Code Revision History : 
// --------------------------------------------------------------------
// Version: |Mod. Date:   |Changes Made:
// V1.0     |2023/11/15   |Initial ver
// --------------------------------------------------------------------

module divider(clk_in, rst_in, clk_out);
	
	parameter N = 500; // original 500

	// input
	input clk_in;
	input rst_in;

	// output
	output reg clk_out;

	// variable
	reg [20:0] cnt;

	// init
	initial
	begin
		cnt <= 0;
		clk_out <= 1'b1; 
	end

	always @ (posedge clk_in or posedge rst_in)
	begin
		if(rst_in)
			cnt <= 2'd0;			
		else if(cnt >= N)		
			cnt <= 2'd0;			
		else
			cnt <= cnt + 2'd2; 		
	end

	always @ (posedge clk_in or posedge rst_in)
	begin
		if(rst_in)                  
			clk_out <= 1'b1;          
		else if(cnt == N)  		
			clk_out <= ~clk_out;        
		else                            
			clk_out <= clk_out; 		
	end

endmodule