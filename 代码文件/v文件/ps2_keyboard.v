`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:20:08 08/26/2014 
// Design Name: 
// Module Name:    ps2_keyboard 
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
module ps2_keyboard (clk,clrn,ps2_clk,ps2_data,rdn,data,data_pre,ready,overflow);
    input        clk, clrn;                    // 50 MHz
    input        ps2_clk;                      // ps2 clock
    input        ps2_data;                     // ps2 data
    input        rdn;                          // read, active low
    output [7:0] data,data_pre;                         // 8-bit code
    output       ready;                        // code ready
    output reg   overflow;                     // fifo overflow
    reg    [9:0] buffer;                       // ps2_data bits
	 reg    [7:0] buffer_pre;
    reg    [7:0] fifo[7:0];                    // circular fifo
    reg    [3:0] count;                        // count ps2_data bits
    reg    [2:0] w_ptr,r_ptr;                  // fifo w/r pointers
    reg    [1:0] ps2_clk_sync;                 // for detecting falling edge
	 
    always @ (posedge clk)
        ps2_clk_sync <= {ps2_clk_sync[0],ps2_clk};
    wire sampling ;
		assign	 sampling = ps2_clk_sync[1] &
                   ~ps2_clk_sync[0];           // had a falling edge
	initial  begin
	count    <= 0;                     // clear count
   w_ptr    <= 0;                     // clear w_ptr
   r_ptr    <= 0;                     // clear r_ptr
   overflow <= 0;                     // clear overflow
	end
	
    always @ (posedge clk) begin
        if (!clrn) begin                       // on reset
            count    <= 0;                     // clear count
            w_ptr    <= 0;                     // clear w_ptr
            r_ptr    <= 0;                     // clear r_ptr
            overflow <= 0;                     // clear overflow
        end else if (sampling) begin           // if sampling
            if (count == 4'd10) begin          // if got one frame
                if ((buffer[0] == 0) && (ps2_data) && (^buffer[9:1])) begin
                    if ((w_ptr + 3'b1) != r_ptr) begin
						      buffer_pre <= fifo[w_ptr-1];
                        fifo[w_ptr] <= buffer[8:1];
                        w_ptr <= w_ptr + 3'b1; // w_ptr++
                    end else begin
                        overflow <= 1;         // overflow
                    end
                end
                count <= 0;                    // for next frame
            end else begin                     // else
                buffer[count] <= ps2_data;     // store ps2_data
                count <= count + 4'b1;         // count++
            end
        end
        if (!rdn && ready) begin               // on cpu read
			
            r_ptr <= r_ptr + 3'b1;             // r_ptr++
            overflow <= 0;                     // clear overflow
				
        end
    end
    assign ready = (w_ptr - r_ptr) != 0 ;           // fifo is not empty
    assign data  = fifo[r_ptr];                // code byte
	 assign data_pre  = fifo[r_ptr - 1];
endmodule
