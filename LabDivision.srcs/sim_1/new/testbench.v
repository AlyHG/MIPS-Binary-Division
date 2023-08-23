`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2023 05:44:28 AM
// Design Name: 
// Module Name: testbench
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
module Divider_tb();

    reg clk;
    reg start;
    reg [31:0] a;
    reg [15:0] b;
    wire [31:0] quotient;
    wire [31:0] remainder;
    wire busy;
    wire ready;
    wire [8:0] count;

    Divider dut(
        .clk(clk),
        .start(start),
        .a(a),
        .b(b),
        .quotient(quotient),
        .remainder(remainder),
        .busy(busy),
        .ready(ready),
        .count(count)
    );

    initial begin
        clk = 0;
        start = 0;
        a = 32'h4c7f228a;
        b = 16'h6a0e;
        #10 start = 1;
        repeat(50) @(posedge clk);
        start = 0;
        repeat(1000) @(posedge clk);
        $display("Quotient: %h", quotient);
        $display("Remainder: %h", remainder);
        $display("Iteration count: %d", count);
        $finish;
    end

    always begin
        #5 clk = ~clk;
    end

endmodule







