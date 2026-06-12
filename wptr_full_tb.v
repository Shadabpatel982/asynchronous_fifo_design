`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.06.2026 19:06:21
// Design Name: 
// Module Name: wptr_full_tb
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


module wptr_full_tb;
reg wclk;
reg w_rst;
reg winc;
reg[4:0] rptr_synch;
wire wclken;
wire[4:0] wptr;
wire[3:0] waddr;
wire wfull;

wptr_full dut (
.wclk(wclk),
.w_rst(w_rst),
.winc(winc),
.rptr_synch(rptr_synch),
.wclken(wclken),
.wptr(wptr),
.waddr(waddr),
.wfull(wfull)
);

initial wclk = 0;
always #5 wclk = ~wclk;

initial begin 
w_rst = 0;
winc = 0;
rptr_synch = 0;

@(posedge wclk);
w_rst = 1;
@(posedge wclk);
winc = 1;
repeat(14) @(posedge wclk);  

@(posedge wclk); 
winc = 0;
@(posedge wclk);
winc = 1;
@(posedge wclk); 
winc = 1; 
@(posedge wclk);
rptr_synch = 5'b00010;
@(posedge wclk);
w_rst = 0;
#40;
$finish;
end
endmodule
