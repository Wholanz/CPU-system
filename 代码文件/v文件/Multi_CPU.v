`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:19:55 08/29/2014 
// Design Name: 
// Module Name:    Multi_CPU 
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
module Multi_CPU(
           input wire clk_1s,
			  input wire exec_out,
           input wire rst_out,
			  input wire[31:0] mem_out,
			  input wire[4:0] reg_index,
			  
			  input wire[7:0] ASCII,
			  input wire fifo_ready,
			  input wire[12:0] char_cnt,
			  input wire[1:0] Ran_num,
			  output wire pause,
			  output wire read_Ran,
			  
			  output wire[3:0] current_state,
			  output reg[31:0] ALUout,
			  output wire[31:0] result_or_data,
			  output wire[31:0] Rdata3,
			  output wire[31:0] pc,
			  output wire[31:0] mem_addr,
			  output wire Mem_we,
			  output wire VGA_we,
			  output wire[31:0] write_data,
			  output reg[3:0] clock,
			  output reg[31:0] inst_reg,
			  output wire[6:0] Ran_addr
			  	  
    );
wire MemWrite;
wire ALUwrite;
wire[31:0] reg_data;
wire multi_clk;

reg[31:0] memdata_reg;
wire[31:0] A,B;
reg[31:0] Rdata1,Rdata2;

reg[15:0] disp_num;

wire[4:0] reg_dst;
//wire[31:0] result_or_data;
wire[31:0] ALUop1,ALUop2;
wire[31:0] PC_next;

wire[31:0] branch_exten,normal_exten,exten;
wire[31:0] upper_16;
wire[31:0] immediate_add;
wire[3:0] next_state;
wire[31:0] ALUresult;
wire[2:0] ALUsignal;
wire zero;
wire branch_or_not;
wire pc_change;

wire[13:0] VGA_addr;


wire PCWrite,PCWriteCond,lorD,MemRead,IRWrite,MemToReg,RegWrite,RegDst,Extensrc;
wire[1:0] PCSource,ALUop,ALUsrcB,ALUsrcA;

initial begin
clock <= 0;
end



pc pp1(pause,pc_change,multi_clk,rst_out,PC_next,pc);   //pc change

state_now s1(pause,multi_clk,next_state,current_state);    //state change
state_control s2(multi_clk,inst_reg[31:26],current_state,next_state);

control c1(pause,current_state,PCWrite,PCWriteCond,lorD,MemRead,MemWrite,IRWrite,MemToReg,RegWrite,RegDst,Extensrc,ALUwrite,PCSource,ALUop,ALUsrcB,ALUsrcA);   //control signal unit

regfile re1(multi_clk,rst_out,RegWrite,inst_reg[25:21],inst_reg[20:16],reg_index,reg_dst,reg_data,A,B,Rdata3);  //registers

aluc a1(ALUop,inst_reg[5:0],ALUsignal);    //alu
alu  a2(ALUop1,ALUop2,ALUsignal,zero,ALUresult);

assign multi_clk = exec_out;
//mux mu0(exec_out,clk_1s,multi_clk,mode);      //all of the multiplexors
mux_32 mu1(pc,ALUout,0,0,mem_addr,{1'b0,lorD});
mux_5 mu2(inst_reg[20:16],inst_reg[15:11],5'd0,5'd0,reg_dst,{1'b0,RegDst});
mux_32 mu3(ALUout,memdata_reg,0,0,result_or_data,{1'b0,MemToReg});
mux_32 mu4(pc,Rdata1,0,0,ALUop1,ALUsrcA);
assign branch_exten = {{16{inst_reg[15]}},inst_reg[15:0]};
assign normal_exten = {16'b0,inst_reg[15:0]};
assign upper_16 = {inst_reg[15:0],16'b0};
mux_32 mu6(branch_exten,normal_exten,0,0,exten,{1'b0,Extensrc});
mux_32 mu7(Rdata2,1,exten,upper_16,ALUop2,ALUsrcB);
mux_32 mu8(ALUresult,ALUout,{6'd0,inst_reg[25:0]},0,PC_next,PCSource);


	IO_Bus bus(
				  .clk_1s(clk_1s),
				  .exec(exec_out),
				  .fifo_ready(fifo_ready),
				  .IRWrite(IRWrite),
				  .action(inst_reg[31:26]),
				  .ASCII(ASCII),
				  .result_or_data(result_or_data),
				  .Rdata2(Rdata2),
				  .char_cnt(char_cnt),
				  .mem_addr(mem_addr),
				  .MemWrite(MemWrite),
				  .VGA_we(VGA_we),
				  .Mem_we(Mem_we),
				  .read_Ran(read_Ran),
				  .reg_data(reg_data),
				  .write_data(write_data),
				  .pause(pause),
				  .Ran_num(Ran_num),
				  .Ran_addr(Ran_addr)
				  ); 

and and1(branch_or_not,zero,PCWriteCond);
or  or1(pc_change,branch_or_not,PCWrite);



always @(negedge multi_clk) begin   //instruction change
if(IRWrite) inst_reg <= mem_out;
if(ALUwrite)
ALUout <= ALUresult;
end

always @(negedge multi_clk) begin   //ALU result get and oprands change
if(~pause) begin
Rdata1 <= A;
Rdata2 <= B;
end
end



always @(negedge multi_clk)  //mem data stored
if(~pause)
memdata_reg <= mem_out;


always@(posedge multi_clk,posedge rst_out) begin //clock cycle count
if(rst_out) clock=0;
else clock = clock + 1;
end

endmodule 

