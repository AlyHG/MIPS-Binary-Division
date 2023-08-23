`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aly Ghallab
// 
// Create Date: 02/25/2023 05:39:35 AM
// Design Name: Lab for Division Algorithm
// Module Name: Divider
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
// "Subtractor" that takes two 17-bit inputs (a and b) and outputs a 17-bit result (s)
module Subtractor(
    input [16:0] a,  // 17-bit input operand a
    input [16:0] b,  // 17-bit input operand b
    output reg [16:0] s  // 17-bit output s
);
    always @(*) begin
        s = a-b;  // subtract b from a and store the result in s
    end
endmodule


module Divider(
    input clk, // clock input
    input start, // start signal input
    input [31:00] a, // dividend input
    input [15:00] b, // divisor input
    
   // quotient and remainder output
    output reg [31:0] quotient,
    output reg [31:0] remainder,
    output reg busy, // busy signal output
    output reg ready, // ready signal output
    output reg [8:00] count // register for keeping track of iteration count
);
    reg [15:00] regB; // register for storing divisor
    reg [31:00] regQ; // register for storing quotient
    reg [31:00] regR; // register for storing remainder
    reg done; // signal indicating division is complete
    
    
    // wires for connecting to Subtractor module
    wire [16:0] subtractorA = {regR, regQ[31]};
    wire [16:0] subtractorB = {1'b0, regB};
    wire [16:0] subOut;
    
    // instantiate Subtractor module to perform subtraction
    Subtractor sub(
        .a(subtractorA),
        .b(subtractorB),
        .s(subOut)
    );

    always @(posedge clk) begin
        if (start == 1) begin
            busy <= 1; // set busy signal high
            ready <= 0; // clear ready signal
            regB <= b; // store divisor in register
            regQ <= a; // store dividend in register
            regR <= 0; // clear remainder register
            count <= 0; // clear iteration count
        end else if (busy == 1) begin
            // perform subtraction and store result in remainder register
            if (subOut[16] == 1) begin
                regR[15:1] <= regR[14:0];
                regR[0] <= regQ[31];
            end else begin
                regR <= subOut[15:00];
            end
            
            // shift quotient and append subtraction borrow flag
            regQ[31:1] <= regQ[30:0];
            regQ[0] <= ~subOut[16];
            
            // update quotient and remainder registers
            quotient <= regQ;
            remainder <= regR;
            
            // check if quotient is zero and set ready signal high if it is
            if (regQ == 0) begin
                busy <= 0; // clear busy signal
                ready <= 1; // set ready signal high
            end
            
            // increment iteration count
            count <= count + 1;
        end
    end
endmodule


