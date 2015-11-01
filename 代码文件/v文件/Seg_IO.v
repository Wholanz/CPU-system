`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:53:22 08/25/2014 
// Design Name: 
// Module Name:    Seg_IO 
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
module Seg_IO(
				  input wire[31:0] ALUout,
              input wire clk,
				  input wire fifo_ready,
				  input wire[31:0] Rdata3,
				  input wire[1:0] disp_type,
				  input wire[31:0] pc,
				  input wire[3:0] clock,
				  input wire[3:0] current_state,
				  output wire[3:0] anode,
				  output wire[7:0] segment
				  
    );
	 
	 
reg[15:0] disp_num;	 
	 
display d1(clk,disp_num,anode,segment);

always @* begin
case(disp_type)
2'b00:
disp_num<= Rdata3[15:0];
2'b01:
disp_num<= Rdata3[31:16];
2'b10:
disp_num<= ALUout[31:16];
2'b11:begin
disp_num[15:12]<= clock[3:0];
disp_num[11:8]<= pc[3:0];
disp_num[7:4]<= current_state;
disp_num[3:0]<= {3'b0,fifo_ready};
end

endcase
end 


endmodule
