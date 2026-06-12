`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2026 21:40:56
// Design Name: 
// Module Name: rptr_empty_tb
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


module rptr_empty_tb;

    reg        rclk;
    reg        r_rst;
    reg        rinc;
    reg  [4:0] wptr_synch;
    wire [4:0] rptr;
    wire [3:0] raddr;
    wire       rempty;

    // DUT instantiation
    rptr_empty dut (
        .rclk      (rclk),
        .r_rst     (r_rst),
        .rinc      (rinc),
        .wptr_synch(wptr_synch),
        .rptr      (rptr),
        .raddr     (raddr),
        .rempty    (rempty)
    );

    // Clock generation
    initial rclk = 0;
    always #5 rclk = ~rclk;

    initial begin
        // Initialize - reset active (active low so r_rst=0)
        r_rst      = 0;
        rinc       = 0;
        wptr_synch = 5'b00000;

        // Release reset after 2 cycles
        @(posedge rclk); #1;
        @(posedge rclk); #1;
        r_rst = 1;

        // FIFO empty, try reading - rempty should stay 1
        @(posedge rclk); #1;
        rinc = 1;

        // Simulate wptr advancing - FIFO has data now
        @(posedge rclk); #1;
        wptr_synch = 5'b00001;

        // Read one location
        @(posedge rclk); #1;
        rinc = 0;

        // Advance wptr more
        @(posedge rclk); #1;
        wptr_synch = 5'b00011;

        // Read again
        @(posedge rclk); #1;
        rinc = 1;

        @(posedge rclk); #1;
        rinc = 1;

        @(posedge rclk); #1;
        rinc = 0;

        #20;
        $finish;
    end

endmodule
