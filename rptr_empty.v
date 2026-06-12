`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2026 21:09:52
// Design Name: 
// Module Name: rptr_empty
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


module rptr_empty(
input wire rclk,
input wire r_rst,
input wire rinc,
input wire[4:0] wptr_synch,
output reg[4:0] rptr,
output reg[3:0] raddr,
output reg rempty
);

reg[4:0] rbin;
reg[4:0] rbin_nxt;
reg[4:0] rptr_nxt;
reg rempty_val; 

always @ (posedge rclk or negedge r_rst)
if (!r_rst) begin
rbin <= 0;
rptr <= 0;
end else begin
rbin <= rbin_nxt;
rptr <= rptr_nxt;
end

always @(*) begin
    rbin_nxt = rbin + (rinc & ~rempty);
    rptr_nxt = (rbin_nxt >> 1) ^ rbin_nxt;
    raddr    = rbin[3:0];
end

always @(posedge rclk or negedge r_rst)
if (!r_rst) begin
rempty <= 1;
end else begin
rempty <= rempty_val;
end

always @(*) begin
rempty_val = rptr_nxt == wptr_synch;
end

endmodule
