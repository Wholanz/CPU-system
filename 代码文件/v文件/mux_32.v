`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:58:31 08/24/2014 
// Design Name: 
// Module Name:    mux_32 
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
module mux_32(
           input wire[31:0] A,B,C,D,
			  output wire[31:0] S,
			  input wire[1:0] ctrl
    );

assign S = (ctrl==0)?A:
           (ctrl==1)?B:
			  (ctrl==2)?C:D;

endmodule
