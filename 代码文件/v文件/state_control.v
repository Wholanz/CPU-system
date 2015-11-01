`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:54:23 08/24/2014 
// Design Name: 
// Module Name:    state_control 
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
module state_control(
                     input wire clk,
                     input wire[5:0] instruction,
                     input wire[3:0] current_state,
							output reg[3:0] next_state
    );


always @* begin

case(current_state)

4'b0000 : begin
next_state<= 4'b0001;
end

4'b0001 : begin 
case(instruction)
6'd35: begin 
next_state<= 4'b0010;
end

6'd43: begin
next_state<= 4'b0010;
end

6'd0: begin
 next_state<= 4'b0110;
end

6'd4: begin
 next_state<= 4'b1000;
end

6'd2:begin
  next_state<= 4'b1001;
end

6'd8: begin
  next_state<= 4'b1100;
end

6'd15: begin
  next_state<= 4'b1011;
end

endcase
end

4'b0010 : begin
if(instruction==6'd35)
next_state<= 4'b0011;
else if(instruction==6'd43)
next_state<= 4'b0101;
else if(instruction==6'd8)
next_state<= 4'b1010;
end

4'b0011 : next_state<= 4'b0100;
4'b0100 : begin 
next_state<= 4'b0000;

end
4'b0101 :begin
 next_state<= 4'b0000;

 end
4'b0110 : next_state<= 4'b0111;
4'b0111 :begin
 next_state<= 4'b0000;

 end
4'b1000 :begin
 next_state<= 4'b0000;

 end
4'b1001 : begin
 next_state<= 4'b0000;
 end
4'b1010 : begin
 next_state<= 4'b0000;
end
4'b1011 : begin
 next_state<= 4'b1010;
end
4'b1100 : begin
 next_state<= 4'b1010;
end
4'b1111 : begin
 next_state<= 4'b0000;
end

endcase
end

endmodule