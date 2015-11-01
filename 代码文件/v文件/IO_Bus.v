`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:37:56 08/30/2014 
// Design Name: 
// Module Name:    IO_Bus 
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
module IO_Bus(
				  input wire clk_1s,
				  input wire exec,
              input wire fifo_ready,
				  input wire IRWrite,
				  input wire[5:0] action,
				  input wire[7:0] ASCII,
				  input wire[1:0] Ran_num,
				  input wire[31:0] result_or_data,
				  input wire[31:0] Rdata2,
				  input wire[12:0] char_cnt,
				  input wire[31:0] mem_addr,
				  input wire MemWrite,
				  output reg[6:0] Ran_addr,
				  output wire VGA_we,
				  output wire Mem_we,
				  output reg read_Ran,
				  output wire[31:0] reg_data,
				  output wire[31:0] write_data,
				  output wire pause
				  
    );
	 
	 reg   read_ASCII;
	 reg   read_clk;
	 reg   clk_Read;
	 //reg   read_Ran;
	 reg[5:0] clock;   
	 wire  clk_signal;
	 wire Ran_signal;
	 
	 initial begin
		read_Ran <= 1'b0;
		read_ASCII <= 1'b0;
		read_clk <= 1'b0;
		clk_Read <= 1'b0;
		clock <= 6'd10;
		Ran_addr <= 7'b0;
	 end
	 

	assign write_data = Rdata2;
	//assign clk_signal = 8'b11100000;
	assign clk_signal = (mem_addr[31:24] == 8'b11100000);
	assign clk_Write  = clk_signal & (MemWrite) & (exec);
	//assign clk_Read   = (mem_addr[31:24] == clk_signal) & (exec) & (action == 6'd35);
 	assign reg_data =  read_ASCII ? {24'b0,ASCII}:
							 read_Ran ? {30'b0,Ran_num}:
							 read_clk ? {8'b11100000,24'b0} :
							 clk_Read ? {26'b0,clock} :
							 result_or_data ;
	wire pause_signal = (mem_addr[31:24] == 8'b10000000);
	assign pause = pause_signal & (~read_ASCII) & (~read_clk);
	assign VGA_we = (mem_addr[31:24]==8'h40) & (MemWrite) & (exec);
	assign Mem_we = (mem_addr[31:24]==8'b0)  &(MemWrite) & (exec);
	
	 
	 always@(posedge fifo_ready or posedge IRWrite) begin
	   if(fifo_ready) begin
			if(pause) read_ASCII <= 1'b1;
		end
		else read_ASCII <= 1'b0;
	 end
	
	assign Ran_signal = (mem_addr[31:24] == 8'b11000000);
	
	always@(posedge Ran_signal /*or posedge IRWrite*/)begin
		/*if(IRWrite) begin
			read_Ran <= 1'b0;
		end
		else begin*/
			//read_Ran <= 1'b1;
			if(Ran_addr == 7'd99)
				Ran_addr = 7'b0;
			else Ran_addr = Ran_addr + 7'b1;
		//end
	end
	
	always @(posedge Ran_signal or posedge IRWrite) begin
		if(IRWrite)
		read_Ran <= 1'b0;
		else if(Ran_signal) read_Ran <= 1'b1;
	end
	
	always@(posedge clk_1s or posedge IRWrite) begin
		if(IRWrite) read_clk <= 1'b0;
		else if(pause)begin
			read_clk <= 1'b1;
		end
	end

	always @(posedge clk_1s or posedge clk_Write) begin
		if(clk_Write) clock <= write_data[5:0];
		else if(clock != 6'b0) clock <= clock - 6'b1 ;
	end
	
	always @(posedge clk_signal or posedge IRWrite) begin
	   if(IRWrite)clk_Read <= 1'b0;
		else if(action == 6'd35)begin
			clk_Read <= 1'b1;
		end
	end


endmodule
