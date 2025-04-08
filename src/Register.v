`timescale 1ps/1ps

// Register File
module Giga_R(
    input clk,
    input rst,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    input RegWrite,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2
);

    // Register file with 32 registers, each 32 bits wide
    reg [31:0] registers[0:31];

    // Initialize registers to zero on reset
    integer i;
    always @(posedge rst) begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'b0;
        end
    end

    // Read data from registers
    always @(*) begin
        ReadData1 = registers[ReadReg1];
        ReadData2 = registers[ReadReg2];
    end

    // Write data to register on positive clock edge if RegWrite is enabled
    always @(posedge clk) begin
        if (RegWrite) begin
            registers[WriteReg] <= WriteData;
        end
    end
endmodule
