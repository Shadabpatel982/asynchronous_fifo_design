`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2026 20:45:52
// Design Name: 
// Module Name: fifo
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


module fifo(
input wire wclk,
input wire [3:0] waddr,
input wire [7:0] wdata,
input wire wclken,
input wire [3:0] raddr,
output wire [7:0] rdata
);
reg [7:0] mem[15:0] ; // 16 x 8 FIFO buffer width = 8 depth = 16
always@(posedge wclk)
if (wclken)        // when wclken is high whatever at wdata line is written to waddr at posedge clk
mem[waddr] <= wdata;
assign rdata = mem [raddr]; // when read domain request whatever at raddr comes out

endmodule
