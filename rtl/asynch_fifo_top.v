`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2026 13:21:19
// Design Name: 
// Module Name: asynch_fifo_top
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


module asynch_fifo_top(
input wire wclk,
input wire rclk,
input wire w_rst,
input wire r_rst,
input wire winc,
input wire rinc,
input wire[7:0] wdata,
output wire[7:0] rdata,
output wire wfull,
output wire rempty
);

// internal signals declarations 
wire[4:0] wptr;
wire[4:0] rptr;
wire[4:0] wptr_synch;
wire[4:0] rptr_synch;
wire wclken;
wire[3:0] waddr;
wire[3:0] raddr;

// instantiating wptr_full module
wptr_full wptr_inst (
.wclk(wclk),
.w_rst(w_rst),
.winc(winc),
.rptr_synch(rptr_synch),
.wfull(wfull),
.wclken(wclken),
.wptr(wptr),
.waddr(waddr)
);

// instantiating rptr_empty module
rptr_empty rptr_inst (
.rclk(rclk),
.r_rst(r_rst),
.rinc(rinc),
.rptr(rptr),
.wptr_synch(wptr_synch),
.raddr(raddr),
.rempty(rempty)
);

// instantiating 2_ff_synch module to transfer wptr to read clk domain
ff_synch wptr_synch_ins (
.clk(rclk),
.rst(r_rst),
.ptr_in(wptr),
.ptr_out(wptr_synch)
);

// instantiating 2_ff_synch module to transfer rptr to write clk domain
ff_synch rptr_synch_ins (
.clk(wclk),
.rst(w_rst),
.ptr_in(rptr),
.ptr_out(rptr_synch)
);

// instantiating fifo_mem module
fifo mem_inst (
.wclk(wclk),
.waddr(waddr),
.raddr(raddr),
.wdata(wdata),
.rdata(rdata),
.wclken(wclken)
);


endmodule
