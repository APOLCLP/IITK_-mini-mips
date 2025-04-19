`timescale 1ns / 1ps

// ALU Control Unit with FPControl support
module Giga_AC(
    input [1:0] ALUOp,
    input [5:0] Funct,
    input [5:0] Opcode,
    output reg [2:0] ALUControl,
    output reg [1:0] FPControl,   // New: Floating-point operation type
    output reg FloatRegWrite
);

    always @(*) begin
        // Default
        FPControl = 2'b00; // Normal ALU operation
        FloatRegWrite = 0;

        case (ALUOp)
            2'b00: ALUControl = 3'b010; // lw/sw/addi -> ADD
            2'b01: ALUControl = 3'b110; // beq/bne -> SUB
            2'b10: begin // R-type
                case (Funct)
                    6'b100000: ALUControl = 3'b010; // ADD
                    6'b100010: ALUControl = 3'b110; // SUB
                    6'b100100: ALUControl = 3'b000; // AND
                    6'b100101: ALUControl = 3'b001; // OR
                    6'b101010: ALUControl = 3'b111; // SLT
                    6'b011000: ALUControl = 3'b011; // MUL
                    default:   ALUControl = 3'b000;
                endcase
            end
            2'b11: begin // For ORI, MFC1, MTC1
                ALUControl = 3'b000; // Doesn't matter for MFC1/MTC1
                case (Opcode)
                    6'b010001: begin // Coprocessor1 instructions
                        case (Funct)
                            6'b00000: FPControl = 2'b01; // MFC1
                            6'b00010:begin
                             FPControl = 2'b10; // MTC1
                             FloatRegWrite = 1;
                            end
                            default:  FPControl = 2'b00;
                        endcase
                    end
                    default: FPControl = 2'b00;
                endcase
            end
            default: begin
                ALUControl = 3'b000;
                FPControl = 2'b00;
            end
        endcase
    end
endmodule