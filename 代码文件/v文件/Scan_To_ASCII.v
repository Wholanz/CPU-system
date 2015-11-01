`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:53:14 08/26/2014 
// Design Name: 
// Module Name:    Scan_To_ASCII 
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
module Scan_To_ASCII(
							input wire clk,
							input wire ready,
                     input wire[7:0] scan_code,
							input wire[7:0] data_pre,
							output wire[7:0] ASCII,
							output wire fifo_ready 	
    );
	 

reg[2:0] wptr,rptr;
reg[2:0] clk_count;
reg[7:0] fifo[0:7];
 
	 
parameter 
space = 8'h29,
w = 8'h1d,
a = 8'h1c,
s = 8'h1b,
d = 8'h23, 
q = 8'h15,
e = 8'h24,
r = 8'h2d,
t = 8'h2c,
y = 8'h35,
u = 8'h3c,
i = 8'h43,
o = 8'h44,
p = 8'h4d,
f = 8'h2b,
g = 8'h34,
h = 8'h33,
j = 8'h3b,
k = 8'h42,
l = 8'h4b,
z = 8'h1a,
x = 8'h22,
c = 8'h21,
v = 8'h2a,
b = 8'h32,
n = 8'h31,
m = 8'h3a,

num1 = 8'h16,
num2 = 8'h1e,
num3 = 8'h26,
num4 = 8'h25,
num5 = 8'h2e,
num6 = 8'h36,
num7 = 8'h3d,
num8 = 8'h3e,
num9 = 8'h46,
num0 = 8'h45,

mark1 = 8'h0e,
mark2 = 8'h4e,
mark3 = 8'h55,
mark4 = 8'h54,
mark5 = 8'h5b,
mark6 = 8'h5d,
mark7 = 8'h4c,
mark8 = 8'h52,
mark9 = 8'h41,
mark10 = 8'h49,
mark11 = 8'h4a,

ESC = 8'h76,
Backspace = 8'h66,
Enter = 8'h5a,
  
mis = 8'hf0;

reg[7:0] key;
	
	initial begin
	key <= 8'b0;
	
	wptr <= 3'b0;
	rptr <= 3'b0;
	clk_count <= 3'b0;
	
	fifo[0] <= 8'b0;
	fifo[1] <= 8'b0;
	fifo[2] <= 8'b0;
	fifo[3] <= 8'b0;
	fifo[4] <= 8'b0;
	fifo[5] <= 8'b0;
	fifo[6] <= 8'b0;
	fifo[7] <= 8'b0;
	
	end

   assign fifo_ready = (rptr != wptr); 
	assign ASCII = fifo[rptr]; 
	assign overflow = (wptr + 1) == rptr;

	always@ (posedge clk) begin
	if(~overflow)
	 if((scan_code!=8'hf0)&(data_pre!=8'hf0) & ready) begin
	  wptr <= wptr + 3'b1;
	  
		case(scan_code)	
			
			w: fifo[wptr+3'b1] <= w;
			a: fifo[wptr+3'b1] <= a;
			s: fifo[wptr+3'b1] <= s;
			d: fifo[wptr+3'b1] <= d;
			q: fifo[wptr+3'b1] <= 8'h71;
			e: fifo[wptr+3'b1] <= 8'h65;
			r: fifo[wptr+3'b1] <= 8'h72;
			t: fifo[wptr+3'b1] <= 8'h74;
			y: fifo[wptr+3'b1] <= 8'h79;
			u: fifo[wptr+3'b1] <= 8'h75;
			i: fifo[wptr+3'b1] <= 8'h69;
			o: fifo[wptr+3'b1] <= 8'h6f;
			p: fifo[wptr+3'b1] <= 8'h70;
			f: fifo[wptr+3'b1] <= 8'h66;
			g: fifo[wptr+3'b1] <= 8'h67;
			h: fifo[wptr+3'b1] <= 8'h68;
			j: fifo[wptr+3'b1] <= 8'h6a;
			k: fifo[wptr+3'b1] <= 8'h6b;
			l: fifo[wptr+3'b1] <= 8'h6c;
			z: fifo[wptr+3'b1] <= 8'h7a;
			x: fifo[wptr+3'b1] <= 8'h78;
			c: fifo[wptr+3'b1] <= 8'h63;
			v: fifo[wptr+3'b1] <= 8'h76;
			b: fifo[wptr+3'b1] <= 8'h62;
			n: fifo[wptr+3'b1] <= 8'h6e;
			m: fifo[wptr+3'b1] <= 8'h6d;
			
			num1: fifo[wptr+3'b1] <= 8'h31;
			num2: fifo[wptr+3'b1] <= 8'h32;
			num3: fifo[wptr+3'b1] <= 8'h33;
			num4: fifo[wptr+3'b1] <= 8'h34;
			num5: fifo[wptr+3'b1] <= 8'h35;
			num6: fifo[wptr+3'b1] <= 8'h36;
			num7: fifo[wptr+3'b1] <= 8'h37;
			num8: fifo[wptr+3'b1] <= 8'h38;
			num9: fifo[wptr+3'b1] <= 8'h39;
			num0: fifo[wptr+3'b1] <= 8'h30;
			
			mark1: fifo[wptr+3'b1] <= 8'h60;
			mark2: fifo[wptr+3'b1] <= 8'h2d;
			mark3: fifo[wptr+3'b1] <= 8'h3d;
			mark4: fifo[wptr+3'b1] <= 8'h5b;
			mark5: fifo[wptr+3'b1] <= 8'h5d;
			mark6: fifo[wptr+3'b1] <= 8'h5c;
			mark7: fifo[wptr+3'b1] <= 8'h3b;
			mark8: fifo[wptr+3'b1] <= 8'h27;
			mark9: fifo[wptr+3'b1] <= 8'h2c;
			mark10: fifo[wptr+3'b1] <= 8'h2e;
			mark11: fifo[wptr+3'b1] <= 8'h2f;
			
			space : fifo[wptr+3'b1] <= 8'h20;
			mis:  fifo[wptr+3'b1]<= 8'h7f;
			
			ESC: fifo[wptr+3'b1] <= 8'h76;
			Backspace: fifo[wptr+3'b1] <= 8'h66;
			Enter: fifo[wptr+3'b1] <= Enter;
			
			default :fifo[wptr+3'b1]<= 8'h7f;
		endcase
		
	end
	end
	
		always@(posedge clk) begin
			if(fifo_ready) rptr <= rptr + 3'b1;
		end


endmodule
