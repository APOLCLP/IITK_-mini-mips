`timescale 1ps/1ps

// Data Memory
module Giga_D(
    input clk,
    input [31:0] Address,
    input [31:0] WriteData,
    input MemRead,
    input MemWrite,
    output reg [31:0] ReadData
);

    // Memory size
    parameter memDEPTH = 1024; // depth of each instruction
    reg [31:0] DATA_MEMORY[0 : memDEPTH-1]; // 256 words of data memory

    // Initialize memory to zero on reset , this is not needed in the final version
    integer i;
    initial begin
        for (i = 0; i < memDEPTH; i = i + 1) begin
            DATA_MEMORY[i] <= 32'b0;
        end
    end

    // Read data from memory
    always @(*) begin
        if (MemRead) begin
            ReadData = DATA_MEMORY[Address >> 2];
        end else begin
            ReadData = 32'bz; // High impedance when not reading
        end
    end

    // Write data to memory on positive clock edge if MemWrite is enabled
    always @(posedge clk) begin
        if (MemWrite) begin
            DATA_MEMORY[Address >> 2] <= WriteData;
        end
    end

endmodule