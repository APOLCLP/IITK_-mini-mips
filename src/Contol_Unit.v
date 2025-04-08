`timescale 1ns / 1ps

// Control Unit 
module Giga_C(
    input  [5:0] opcode,
    output reg [1:0] ALUOp,
    output reg ALUSrc,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg,
    output reg Branch,
    output reg Jump
);   
    
    initial begin
        ALUOp = 2'b00;
        ALUSrc = 0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        MemtoReg = 0;
        Branch = 0;
        Jump = 0;
    end

// for now i will be using only the codes which are in the pdf , so that i can test the ALU and the control unit,
 // later i will add the others as per bucket sort.
    always @(opcode) begin
        case (opcode)
            6'b000000: begin // R-type instructions
                ALUOp = 2'b10;
                ALUSrc = 0;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch = 0;
                Jump = 0;
            end

            6'b100011: begin // lw instruction
                ALUOp = 2'b00;
                ALUSrc = 1;
                RegWrite = 1;
                MemRead = 1;
                MemWrite = 0;
                MemtoReg = 1;
                Branch = 0;
                Jump = 0;
            end
            6'b101011: begin // sw instruction
                ALUOp = 2'b00;
                ALUSrc = 1;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 1;
                MemtoReg = 0;
                Branch = 0;
                Jump = 0;
            end
            
            6'b000100: begin // beq instruction
                ALUOp = 2'b01;
                ALUSrc = 0;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch = 1;
                Jump = 0;
            end
            6'b000101: begin // bne instruction
                ALUOp = 2'b01;
                ALUSrc = 0;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch = 1;
                Jump = 0;
            end

            6'b001000: begin // addi instruction
                ALUOp = 2'b00;
                ALUSrc = 1;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch = 0;
                Jump = 0;
            end 
            6'b001100: begin // andi instruction
                ALUOp = 2'b00;
                ALUSrc = 1;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch = 0;
                Jump = 0;
            end
            6'b001101: begin // ori instruction
                ALUOp = 2'b00;
                ALUSrc = 1;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch = 0;
                Jump = 0;
            end
            6'b001110: begin // xori instruction
                ALUOp = 2'b00;
                ALUSrc = 1;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch = 0;
                Jump = 0;
            end
            6'b001111: begin // lui instruction
                ALUOp = 2'b00;
                ALUSrc = 1;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch = 0;
                Jump = 0;
            end

            6'b001010: begin // slti instruction
                ALUOp = 2'b00;
                ALUSrc = 1;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch = 0;
                Jump = 0;
            end
            6'b001011: begin // sltiu instruction
                ALUOp = 2'b00;
                ALUSrc = 1;
                RegWrite = 1;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch = 0;
                Jump = 0;
            end

            6'b000010: begin // j instruction
                ALUOp = 2'b00;
                ALUSrc = 0;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch = 0;
                Jump = 1;
            end
            
            default: begin
                ALUOp = 2'b00; // Default case
                ALUSrc = 0;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                Branch = 0;
                Jump = 0;
            end
        endcase
    end 
endmodule;