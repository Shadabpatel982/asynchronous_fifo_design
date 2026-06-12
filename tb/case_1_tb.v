`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2026 23:00:20
// Design Name: 
// Module Name: fifo_tb
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


module fifo_tb;

    reg        wclk;
    reg        rclk;
    reg        w_rst;
    reg        r_rst;
    reg        winc;
    reg        rinc;
    reg  [7:0] wdata;
    wire [7:0] rdata;
    wire       wfull;
    wire       rempty;

    // DUT instantiation
    fifo_top dut (
        .wclk  (wclk),
        .rclk  (rclk),
        .w_rst (w_rst),
        .r_rst (r_rst),
        .winc  (winc),
        .rinc  (rinc),
        .wdata (wdata),
        .rdata (rdata),
        .wfull (wfull),
        .rempty(rempty)
    );

    // Clock generation
    initial wclk = 0;
    always #5  wclk = ~wclk;   // 100MHz

    initial rclk = 0;
    always #10 rclk = ~rclk;   // 50MHz

    initial begin
        // Initialize
        w_rst = 0;
        r_rst = 0;
        winc  = 0;
        rinc  = 0;
        wdata = 8'd0;

        // Release reset after one clock each
        @(posedge wclk); #1;
        @(posedge rclk); #1;
        w_rst = 1;
        r_rst = 1;

        // Wait one more cycle to settle
        @(posedge wclk); #1;

        // Write 16 values
        winc = 1;
        wdata = 8'd1;
        @(posedge wclk); #1;
        wdata = 8'd2;
        @(posedge wclk); #1;
        wdata = 8'd3;
        @(posedge wclk); #1;
        wdata = 8'd4;
        @(posedge wclk); #1;
        wdata = 8'd5;
        @(posedge wclk); #1;
        wdata = 8'd6;
        @(posedge wclk); #1;
        wdata = 8'd7;
        @(posedge wclk); #1;
        wdata = 8'd8;
        @(posedge wclk); #1;
        wdata = 8'd9;
        @(posedge wclk); #1;
        wdata = 8'd10;
        @(posedge wclk); #1;
        wdata = 8'd11;
        @(posedge wclk); #1;
        wdata = 8'd12;
        @(posedge wclk); #1;
        wdata = 8'd13;
        @(posedge wclk); #1;
        wdata = 8'd14;
        @(posedge wclk); #1;
        wdata = 8'd15;
        @(posedge wclk); #1;
        wdata = 8'd16;
        @(posedge wclk); #1;
        winc = 0;
        //read from all location 
        rinc = 1;
repeat(18) @(posedge rclk); 
#1;
rinc = 0;
        #400;
        $finish;
    end

endmodule
