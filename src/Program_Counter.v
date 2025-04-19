`timescale 1ns/ 1ps

// Program Counter with Reset
module Giga_PC(
    input clk,
    input reset,       // Reset signal
    input [31:0] next_PC,
    output reg [31:0] PC
);
    // Initialize the program counter to 0 on reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the program counter to 0 when reset is high
            PC <= 32'b0;
        end else begin
            // Update the program counter with next_PC on clock edge
            PC <= next_PC;
        end
    end
endmodule