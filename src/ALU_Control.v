`timescale 1ns / 1ps

// ALU Control Unit

module Giga_AC(
    input [1:0] ALUOp,
    input [5:0] funct,
    output reg [2:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b010; // lw/sw -> ADD
            2'b01: ALUControl = 3'b110; // beq -> SUBTRACT
            2'b10: begin // R-type instructions
                case (funct)
                    6'b100000: ALUControl = 3'b010; // ADD
                    6'b100010: ALUControl = 3'b110; // SUBTRACT
                    6'b100100: ALUControl = 3'b000; // AND
                    6'b100101: ALUControl = 3'b001; // OR
                    6'b101010: ALUControl = 3'b111; // SLT
                    default:   ALUControl = 3'b000; // Default to AND for unknown funct codes
                endcase
            end
            default: ALUControl = 3'b000; // Default to AND for unknown ALUOp codes
        endcase
    end
endmodule
