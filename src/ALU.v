`timescale 1ns / 1ps

// Arthimetic Logic Unit (ALU) module
module Giga_A(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg Zero
);
    // ALU Operations
    always @(*) begin
        case (ALUControl)
            3'b000: ALUResult = A & B; // AND
            3'b001: ALUResult = A | B; // OR
            3'b010: ALUResult = A + B; // ADD
            3'b110: ALUResult = A - B; // SUBTRACT
            3'b111: ALUResult = (A < B) ? 1 : 0; // SLT
            default: ALUResult = 32'b0;
        endcase

        // Set Zero flag
        Zero = (ALUResult == 32'b0) ? 1 : 0;
    end

endmodule;