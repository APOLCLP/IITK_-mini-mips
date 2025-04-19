`timescale 1ns / 1ps

// Control Unit with floating-point support (MFC1/MTC1)
module Giga_CU(
    input  [5:0] opcode,
    output reg [1:0] ALUOp,
    output reg       ALUSrc,
    output reg       RegWrite,
    output reg       MemRead,
    output reg       MemWrite,
    output reg       MemtoReg,
    output reg       Branch,
    output reg       Jump,
    output reg       RegDst,
    output reg [1:0] FPControl   // NEW: for floating point move detection
);

    initial begin
        ALUOp      = 2'b00;
        ALUSrc     = 1'b0;
        RegWrite   = 1'b0;
        MemRead    = 1'b0;
        MemWrite   = 1'b0;
        MemtoReg   = 1'b0;
        Branch     = 1'b0;
        Jump       = 1'b0;
        RegDst     = 1'b1;
        FPControl  = 2'b00;
    end

    always @(opcode) begin
        // Default
        ALUOp      = 2'b00;
        ALUSrc     = 1'b0;
        RegWrite   = 1'b0;
        MemRead    = 1'b0;
        MemWrite   = 1'b0;
        MemtoReg   = 1'b0;
        Branch     = 1'b0;
        Jump       = 1'b0;
        RegDst     = 1'b1;
        FPControl  = 2'b00;

        case (opcode)
            6'b000000: begin // R-type
                ALUOp    = 2'b10;
                RegWrite = 1'b1;
            end

            6'b100011: begin // lw
                ALUOp     = 2'b00;
                ALUSrc    = 1'b1;
                RegWrite  = 1'b1;
                MemRead   = 1'b1;
                MemtoReg  = 1'b1;
                RegDst    = 1'b0;
            end

            6'b101011: begin // sw
                ALUOp     = 2'b00;
                ALUSrc    = 1'b1;
                MemWrite  = 1'b1;
            end

            6'b000100, 6'b000101: begin // beq or bne
                ALUOp    = 2'b01;
                Branch   = 1'b1;
            end

            6'b001000, 6'b001001: begin // addi / addiu
                ALUOp     = 2'b00;
                ALUSrc    = 1'b1;
                RegWrite  = 1'b1;
                RegDst    = 1'b0;
            end

            6'b001111: begin // lui
                ALUOp     = 2'b00;
                ALUSrc    = 1'b1;
                RegWrite  = 1'b1;
                RegDst    = 1'b0;
            end

            6'b001101: begin // ori
                ALUOp     = 2'b11;
                ALUSrc    = 1'b1;
                RegWrite  = 1'b1;
                RegDst    = 1'b0;
            end

            6'b000010: begin // j
                Jump = 1'b1;
            end

            6'b000011: begin // jal
                Jump     = 1'b1;
                RegWrite = 1'b1;
            end

            6'b010001: begin // Coprocessor 1
                // These will be decoded further by funct in ALUControl unit
                FPControl = 2'b11; // Mark as a COP1 instruction
            end

            default: begin
                // Defaults are already assigned
            end
        endcase
    end
endmodule