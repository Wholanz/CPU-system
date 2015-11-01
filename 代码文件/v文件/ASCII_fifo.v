`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:58:43 08/31/2014 
// Design Name: 
// Module Name:    ASCII_fifo 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ASCII_fifo(
						input wire clk,
						input wire ASCII_ready,
						input wire[7:0] ASCII,
						output wire[7:0] ASCII_read,
						output wire fifo_ready
    );
	 
reg[2:0] wptr,rptr;
reg[2:0] clk_count;
reg[7:0] fifo[0:7];


	
	initial begin
		wptr <= 3'b0;
		rptr <= 3'b0;
		clk_count <= 3'b0;
	end
	
	always@(posedge clk) begin
		if(clk_count == 3'd4) begin
			clk_count <= 3'b0;
			if(fifo_ready) rptr <= rptr + 3'b1;
		end
		else  clk_count <= clk_count + 3'b1;
		
		if(ASCII_ready) begin
			fifo[wptr] <= ASCII;
			wptr <= wptr + 3'b1;
		end
		
	end
	
	
	assign fifo_ready = (rptr != wptr) ; 
	assign ASCII_read = fifo[rptr] ; 
 
endmodule
