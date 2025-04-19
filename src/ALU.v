`timescale 1ns / 1ps

module Giga_A(
    input [31:0] A,               // Operand A (GPR or FPR)
    input [31:0] B,               // Operand B (GPR or FPR)
    input [2:0] ALUControl,       // ALU operation control
    input [1:0] FPControl,        // Floating-point control signals
    output reg [31:0] ALUResult,  // Result (GPR)
    output reg [31:0] FPResult,   // Result for FPR if needed
    output reg Zero
);
    // ALUControl:
    // 000: AND, 001: OR, 010: ADD, 110: SUB, 111: SLT, 011: MUL
    // FPControl:
    // 00: Normal, 01: MFC1, 10: MTC1

    always @(*) begin
        // Default results
        ALUResult = 32'b0;
        FPResult = 32'b0;
        Zero = 1'b0;

        if (FPControl == 2'b01) begin
            // MFC1: Move from Float Register to General Register
            ALUResult = B;  // B is treated as float reg content → to ALUResult (GPR)
        end
        else if (FPControl == 2'b10) begin
            // MTC1: Move from General Register to Float Register
            FPResult = A;   // A is GPR value → to FPResult (FPR)
        end
        else begin
            // Normal ALU operations
            case (ALUControl)
                3'b000: ALUResult = A & B;
                3'b001: ALUResult = A | B;
                3'b010: ALUResult = A + B;
                3'b110: ALUResult = A - B;
                3'b111: ALUResult = (A < B) ? 32'd1 : 32'd0;
                3'b011: ALUResult = A * B;
                default: ALUResult = 32'b0;
            endcase
            Zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;
        end
    end

endmodule