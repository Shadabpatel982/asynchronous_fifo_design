`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2026 12:43:34
// Design Name: 
// Module Name: ff_synch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ff_synch(
input wire clk,
input wire rst,
input wire[4:0] ptr_in, 
output reg[4:0] ptr_out
);

reg[4:0] synch; // output of first FF

always @(posedge clk or negedge rst)
if(!rst)
synch <= 0;
else 
synch <= ptr_in;

always @(posedge clk or negedge rst)
if(!rst)
ptr_out <= 0;
else
ptr_out <= synch;


endmodule
