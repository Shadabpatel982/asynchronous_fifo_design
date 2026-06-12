`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2026 20:03:57
// Design Name: 
// Module Name: fifo_mem_tb
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


module fifo_mem_tb;
reg wclk;
reg wclken;
reg[7:0] wdata;
reg[3:0] waddr;
reg[3:0] raddr;
wire[7:0] rdata;

fifo dut(
.wclk(wclk),
.wclken(wclken),
.wdata(wdata),
.waddr(waddr),
.raddr(raddr),
.rdata(rdata)
);

initial wclk = 0;
always #5 wclk = ~wclk;

initial begin
        // Initialize all inputs
        wclken = 0;
        waddr  = 4'd0;
        wdata  = 8'd0;
        raddr  = 4'd0;

@(posedge wclk);
wclken = 1;
waddr = 4'd12;
wdata = 8'd13;

@(posedge wclk);
wclken = 1;
waddr = 4'd8;
wdata = 8'd12;

#5 
raddr = 4'd12;
#5
raddr = 4'd8;

@(posedge wclk);
wclken = 0;

$finish;
end
endmodule
