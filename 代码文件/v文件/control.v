`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:01:52 08/24/2014 
// Design Name: 
// Module Name:    control 
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
module control( 
					input wire pause,
               input wire[3:0] current_state,
					output wire PCWrite,
					            PCWriteCond,
									lorD,
									MemRead,
									MemWrite,
									IRWrite,
									MemToReg,
									RegWrite,
									RegDst,
									Extensrc,
									ALUwrite,
					output wire[1:0] PCSource,
					                 ALUop,
										  ALUsrcB,
										  ALUsrcA
    );
assign PCWrite = (~pause) & ((current_state==0)|(current_state==9));
assign PCWriteCond = (~pause) & (current_state==8);
assign lorD =  ((current_state==3)|(current_state==5));
assign MemRead = (~pause) & ((current_state==0)|(current_state==3));
assign MemWrite = (~pause) & (current_state==5);
assign IRWrite = (~pause) & (current_state==0);
assign MemToReg =  (current_state==4);
assign ALUsrcA[0] = ((current_state==2)|(current_state==6)|(current_state==8))|(current_state==12);
assign ALUsrcA[1] = (current_state==11);
assign RegWrite = (~pause) & ((current_state==4)|(current_state==7))|(current_state==10);
assign RegDst =(current_state==7);
assign Extensrc = (current_state == 12);

assign PCSource[1] = (current_state==9);
assign PCSource[0] = (current_state==8);
assign ALUop[1] = (current_state==6);
assign ALUop[0] = (current_state==8);
assign ALUsrcB[1] = ((current_state==1)|(current_state==2))|(current_state==11)|(current_state==12);
assign ALUsrcB[0] = (current_state==0)|(current_state==11);
assign ALUwrite = (~pause) & 
						(current_state == 4'd1)|
						(current_state == 4'd2)|
						(current_state == 4'd6)|
						(current_state == 4'd11)|
						(current_state == 4'd12);


endmodule