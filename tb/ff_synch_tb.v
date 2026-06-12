`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2026 13:10:21
// Design Name: 
// Module Name: ff_synch_tb
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


module ff_synch_tb;

reg clk;
reg rst;
reg[4:0] ptr_in;
wire[4:0] ptr_out;

ff_synch dut (
.clk(clk),
.rst(rst),
.ptr_in(ptr_in),
.ptr_out(ptr_out)
);

initial clk = 0;
always #5 clk = ~clk;
initial begin 
rst = 0 ;
ptr_in = 0;

@(posedge clk);#1;
rst = 1;
ptr_in = 5'b01101;

@(posedge clk);
@(posedge clk);
@(posedge clk);#1;
ptr_in = 5'b00001;

@(posedge clk);
@(posedge clk);
@(posedge clk);#1;

rst = 0;

#20;
$finish;
end
endmodule
