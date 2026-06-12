`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.06.2026 11:38:09
// Design Name: 
// Module Name: wptr_full
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


module wptr_full(
input wire wclk,
input wire w_rst,
input wire winc,
input wire[4:0] rptr_synch,
output reg wclken,
output reg wfull,
output reg[4:0] wptr,
output reg[3:0] waddr
);

reg[4:0] wbin;
reg[4:0] wbin_nxt;
reg[4:0] wptr_nxt;
reg wfull_val;

always @ (posedge wclk or negedge w_rst)
if(!w_rst) begin
wbin <= 0;
wptr <= 0;
end else begin
wbin <= wbin_nxt;
wptr <= wptr_nxt;
end

always @(*) begin
wbin_nxt = wbin + (winc & ~wfull);
wptr_nxt = (wbin_nxt >> 1) ^ wbin_nxt;
waddr    = wbin[3:0];
wclken   = winc & ~wfull;
end

always @ (posedge wclk or negedge w_rst)
if(!w_rst) begin
wfull <= 0;
end else begin 
wfull <= wfull_val;
end

always @ (*) begin
wfull_val = ( wptr_nxt == {~rptr_synch[4:3] , rptr_synch[2:0]});
end

endmodule
