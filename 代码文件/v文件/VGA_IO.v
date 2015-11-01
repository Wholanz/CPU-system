`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:00:10 08/26/2014 
// Design Name: 
// Module Name:    VGA_IO 
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
module VGA_IO(
              input wire clk_in,
              input wire rst_out,
				  input wire rdn,
				  input wire VGA_we,
				  input wire fifo_ready,
				  input wire[12:0] write_addr,
				  input wire[23:0] ASCII,
              output wire hsync,vsync,
			     output wire [7:0] rgb

    );
wire clk;

reg vga_clk;
wire[9:0] pixel_x;
wire[8:0] pixel_y;
wire[2:0] red;
wire[2:0] green;
wire[1:0] blue;
wire[7:0] bit_color;
wire[7:0] color;
wire[7:0] bgcolor;

wire[8:0] font_addr; //font read
wire[63:0] bitmap;    //bitmap get
wire[23:0]  ASCII_out;
wire[12:0] read_addr ;// write_addr;
wire[5:0] row;
wire[6:0] col;
wire[5:0] current_bit;


	 initial begin
		vga_clk <= 0;
	 end
	 
	  clk_div div2(clk_in,clk);
	 
	 assign rgb = {red,green,blue};
	 
    assign font_addr = ASCII_out[7:0] - 8'h20 ;
	 
	 
    vgac v1(
	         .vga_clk(vga_clk),
				.clrn(~rst_out),
				.d_in(bit_color),
				.row_addr(pixel_y),
				.col_addr(pixel_x),
				.rdn(rdn),
				.r(red),.g(green),.b(blue),
				.hs(hsync),
				.vs(vsync)
				);

				
    font_table f1(
						.clka(clk_in),
						.addra(font_addr),
						.douta(bitmap)
						);
	 
	
	 assign row = pixel_y[8:3];
	 assign col = pixel_x[9:3];
	 assign read_addr = 80 * row + col ; 
	 
	 Scan_out scan0(
				 .clka(clk_in),
				 .wea(VGA_we),
				 .addra(write_addr),
				 .dina(ASCII),
				 .clkb(clk_in),
				 .addrb(read_addr),
				 .doutb(ASCII_out)
				 );
				 			 
	 
	 
	 assign current_bit = 6'd64 - (8 * ( pixel_y - row * 8 ) + ( pixel_x - col * 8 ));
	 
	 assign color = ASCII_out[15:8];
	 
	 assign bgcolor = ASCII_out[23:16];
	 
	 assign bit_color = (bitmap[current_bit])?color:bgcolor;
	 
	 
    always @(posedge clk) vga_clk <= ~vga_clk;
	 

endmodule
