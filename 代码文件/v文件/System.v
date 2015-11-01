`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:10:36 08/25/2014 
// Design Name: 
// Module Name:    System 
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
module System(
              input wire clk_in,  //100MHz
				  input wire rst,
				  input wire exec,
				  input wire[1:0] disp_type,
				  input wire[4:0] reg_index,
				  input wire ps2_clk,
				  input wire ps2_data,
				  output wire[7:0] rgb,
				  output wire hsync,vsync,
				  output wire[7:0] led,
			 	  output wire[7:0] segment,
				  output wire[3:0] anode
				  
				  

    );

wire clk;   //50MHz
wire clk_1s;
wire rst_out;
wire exec_out;

wire[31:0] ALUout;
wire[3:0] current_state;  //connect CPU
wire[31:0] instruction;
wire[31:0] Rdata3;
wire[31:0] write_data;
wire[31:0] pc;
wire[3:0] clock;
wire Mem_we , VGA_we;
wire[31:0] mem_addr;
wire[31:0] mem_out;
wire PCWrite,PCWriteCond,lorD,MemRead,IRWrite,MemToReg,ALUsrcA,RegWrite,RegDst;

wire rdn;
wire[7:0] ASCII;
wire pause;
wire clk_25;

wire[1:0] Ran_num;
wire[6:0] Ran_addr;
wire[31:0] reg_data;

   
   clk_div div1(clk_in,clk);
	clk_div div3(clk,clk_25);
	
	timer_1s t1(clk,clk_1s);  //1s clock

	
	assign rdn = 0;

	pbdebounce p1(clk,exec,exec_out);
	pbdebounce p2(clk,rst,rst_out);
	


	Multi_CPU cpu1( 
						 .clk_1s(clk_1s),
						 .exec_out(clk_25),
						 .rst_out(rst_out),
						 .mem_out(mem_out),
						 .reg_index(reg_index),
						 .fifo_ready(fifo_ready),
						 .char_cnt(char_cnt),
						 .pause(pause),
						 .read_Ran(read_Ran),
						 .ASCII(ASCII),
						 .current_state(current_state),
						 .write_data(write_data),
						 .ALUout(ALUout),
						 .result_or_data(reg_data),
						 .Rdata3(Rdata3),
						 .pc(pc),
						 .mem_addr(mem_addr),
						 .Mem_we(Mem_we),
						 .VGA_we(VGA_we),
						 .clock(clock),
						 .inst_reg(instruction),
						 .Ran_addr(Ran_addr),
						 .Ran_num(Ran_num)
						 );
	
	Led_IO io1(
					.pause(pause),
					.mem_addr(mem_addr),
				   .inst(instruction[31:26]),
				   .current_state(current_state),
				   .mode(mode),
				   .rst_out(rst_out),
				   .led(led)
				  );
  
	Seg_IO io2(
	           .ALUout(ALUout),
	           .clk(clk),
				  .fifo_ready(read_Ran),
				  .Rdata3(Rdata3),
				  .disp_type(disp_type),
				  .pc(pc),
				  .clock(clock),
				  .current_state(current_state),
				  .anode(anode),
				  .segment(segment)
				  );
	
	PS2_IO io3(
	           .clk(clk),
				  .rst_out(rst_out),
				  .ps2_clk(ps2_clk),
				  .ps2_data(ps2_data),
				  .rdn(rdn),
				  .ASCII(ASCII),
				  .fifo_ready(fifo_ready)
				  );

	
	VGA_IO io4(
				  .clk_in(clk_in),
              .rst_out(rst_out),
				  .rdn(rdn),
				  .VGA_we(VGA_we),
				  .fifo_ready(fifo_ready),
				  .write_addr(mem_addr[12:0]),
				  .ASCII(write_data[23:0]),
              .hsync(hsync),.vsync(vsync),
			     .rgb(rgb)
				  );
				  
	mem m1(
			  .addra(mem_addr[10:0]),
			  .clka(clk_in),
			  .dina(write_data),
			  .douta(mem_out),
			  .wea(Mem_we)
			  );
	
	Random ran(
				  .clka(clk_in),
				  .addra(Ran_addr),
				  .douta(Ran_num)
				  );

endmodule