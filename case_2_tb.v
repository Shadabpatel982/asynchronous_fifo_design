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

    integer i;

    initial begin
        // Initialize
        w_rst = 0;
        r_rst = 0;
        winc  = 0;
        rinc  = 0;
        wdata = 8'd0;

        // Release reset asynchronously
        #15;
        w_rst = 1;
        r_rst = 1;

        // Settle after reset
        @(posedge wclk); #1;

        // Write first 8 values before enabling rinc
        // so FIFO has some data before read starts
        winc  = 1;
        for (i = 1; i <= 8; i = i + 1) begin
            wdata = i;
            @(posedge wclk); #1;
        end

        // Now enable rinc simultaneously
        // write side continues writing 9 to 16
        rinc = 1;
        for (i = 9; i <= 16; i = i + 1) begin
            wdata = i;
            @(posedge wclk); #1;
        end

        // Stop writing
        // wclk faster so FIFO will have filled briefly
        // wfull short pulses visible here
        winc = 0;

        // Let read side drain all remaining data
        // rclk is 50MHz so needs more cycles to finish
        repeat(20) @(posedge rclk); #1;
        rinc = 0;

        // At this point rempty should go high
        // all 16 locations read
        repeat(4) @(posedge rclk); #1;

        #100;
        $finish;
    end

endmodule