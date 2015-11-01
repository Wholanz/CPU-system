`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:03:26 08/25/2014 
// Design Name: 
// Module Name:    Led_IO 
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
module Led_IO(
				  input wire pause,
				  input wire[31:0] mem_addr,
				  input wire[5:0] inst,
				  input wire[3:0] current_state,
				  input wire mode,
				  input wire rst_out,
				  output wire[7:0] led
    );

assign led[1:0] = (inst==0)?2'b0:
                  ((inst==35)||(inst==43))?2'd1:
						(inst==4)?2'd2:
						(inst==2)?2'd3:2'd0;
assign led[4:2] = current_state;
assign led[5] = (rst_out);
assign led[6] = (mem_addr[31]);
assign led[7] = (~mode);


endmodule
