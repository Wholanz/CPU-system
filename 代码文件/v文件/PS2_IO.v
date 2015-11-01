`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:19:04 08/26/2014 
// Design Name: 
// Module Name:    PS2_IO 
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
module PS2_IO(
				  input wire clk,
				  input wire rst_out,
				  input wire ps2_clk,
				  input wire ps2_data,
				  input wire rdn,
				  output wire[7:0] ASCII,
				  output wire fifo_ready
    );
	 
wire[7:0] data_pre;
wire[7:0] data;
wire ready;
wire overflow;

  	  Scan_To_ASCII chan(
							  .clk(clk),
							  .ready(ready),
							  .scan_code(data),
							  .data_pre(data_pre),
							  .ASCII(ASCII),
							  .fifo_ready(fifo_ready)
							  );
							  
	  ps2_keyboard ps1(.clk(clk),
							 .clrn(~rst_out),
							 .ps2_clk(ps2_clk),
							 .ps2_data(ps2_data),
							 .rdn(rdn),
							 .data(data),
							 .data_pre(data_pre),
							 .ready(ready),
							 .overflow(overflow)
							 );
							 


endmodule
