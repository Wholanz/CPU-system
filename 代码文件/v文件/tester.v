`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:05:50 08/29/2014
// Design Name:   System
// Module Name:   C:/Users/LK/Desktop/test/multi_OS/tester.v
// Project Name:  multi_OS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: System
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tester;

	// Inputs
	reg clk_in;
	reg rst;
	reg mode;
	reg exec;
	reg [1:0] disp_type;
	reg [4:0] reg_index;
	reg ps2_clk;
	reg ps2_data;

	// Outputs
	wire [7:0] rgb;
	wire hsync;
	wire vsync;
	wire [7:0] led;
	wire [7:0] segment;
	wire [3:0] anode;
	wire [8:0] pixel_x;

	// Instantiate the Unit Under Test (UUT)
	System uut (
		.clk_in(clk_in), 
		.rst(rst), 
		.mode(mode), 
		.exec(exec), 
		.disp_type(disp_type), 
		.reg_index(reg_index), 
		.ps2_clk(ps2_clk), 
		.ps2_data(ps2_data), 
		.rgb(rgb), 
		.hsync(hsync), 
		.vsync(vsync), 
		.led(led), 
		.segment(segment), 
		.anode(anode), 
		.pixel_x(pixel_x)
	);
   initial forever begin
	#1;
	clk_in = ~clk_in;
	end
	initial forever begin
	#400;
	exec=~exec;
	end

	initial begin
		// Initialize Inputs
		clk_in = 0;
		rst = 0;
		mode = 0;
		exec = 0;
		disp_type = 0;
		reg_index = 0;
		ps2_clk = 0;
		ps2_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

