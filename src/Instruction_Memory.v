`timescale 1ns / 1ps


// Instruction Memory
module Giga_I(
    input reg [31:0] PC,
    input clk,
    output reg [31:0] Instruction
);

    parameter memDEPTH = 256; // depth of each instruction
    reg [31:0] INSTRUCTION_MEMORY[0 : memDEPTH-1]; // 256 words of instruction memory

    // Set the instruction memory
    integer i;
    initial begin
        for (i = 0; i < memDEPTH; i = i + 1) begin
        INSTRUCTION_MEMORY[i] = 32'b0;
        end
    end


    // Read the instruction memory
    assign Instruction = INSTRUCTION_MEMORY[PC >> 2];

    // Jump to next PC address
    always @(posedge clk) begin
            PC <= PC + 4;
    end

endmodule
