`timescale 1ns/1ps
`include "src\Program_Counter.v"
`include "src\Instruction_Memory.v"
`include "src\Data_Memory.v"
`include "src\Contol_Unit.v"
`include "src\Register_File.v"
`include "src\ALU.v"
`include "src\ALU_Control.v"
`include "src\Jump_Branch.v"


module Giga_T(
    input clk,
    input rst
);

    // === Internal Wires ===
    wire [31:0] PC, Instruction;
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] ReadData_Float1, ReadData_Float2;
    wire [31:0] ALUResult;
    wire [31:0] Immediate;
    wire [31:0] ReadData;  // From data memory
    wire [31:0] WriteData, WriteData_Float;
    wire [4:0] WriteReg;
    wire [2:0] ALUControl;
    wire [31:0] next_PC;

    wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump,FloatRegWrite;
    wire [1:0] ALUOp,FPControl;
    wire Zero;

    // === Program Counter ===
    Giga_PC pc_inst (
        .clk(clk),
        .reset(rst),
        .next_PC(next_PC),
        .PC(PC)
    );

    // === Instruction Memory ===
    Giga_IM im_inst (
     .a(PC[8:0]),
     .we(0),
     .clk(clk),
     .spo(Instruction),
    .d(0)
//        .PC(PC),
//        .clk(clk),
//        .reset(rst),
//        .Instruction(Instruction)
    );

    // === Control Unit ===
    Giga_CU cu_inst (
        .opcode(Instruction[31:26]),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemToReg),
        .Branch(Branch),
        .Jump(Jump),
        .RegDst(RegDst),
        .FPControl(FPControl)
    );

    // === Jump & Branch ===
    Giga_JB jb_inst (
        .PC(PC),
        .Instruction(Instruction),
        .Branch(Branch),
        .Jump(Jump),
        .Zero(Zero),
        .next_PC(next_PC)
    );

    // === Register File (General + Floating-Point) ===
    Giga_R regfile (
        .clk(clk),
        .reset(rst),
        .RegWrite(RegWrite),
        .FloatRegWrite(FloatRegWrite),
        .read_addr1(Instruction[25:21]),
        .read_addr2(Instruction[20:16]),
        .write_addr(RegDst ? Instruction[15:11] : Instruction[20:16]), // Could also write to $ra (31) for JAL-like logic
        .write_data(WriteData),
        .write_data_float(WriteData_Float),
        .read_data1(ReadData1),
        .read_data2(ReadData2),
        .read_data_float1(ReadData_Float1),
        .read_data_float2(ReadData_Float2)
    );

    // === ALU Control ===
    Giga_AC alu_ctrl (
        .ALUOp(ALUOp),
        .Funct(Instruction[5:0]),
        .Opcode(Instruction[31:26]),
        .ALUControl(ALUControl),
        .FPControl(FPControl),
        .FloatRegWrite(FloatRegWrite)
    );

    // === Immediate Extension ===
    assign Immediate = {{16{Instruction[15]}}, Instruction[15:0]};

    // === ALU ===
    Giga_A alu (
        .A(ReadData1),
        .B(ALUSrc ? Immediate : ReadData2),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    // === Data Memory ===
    Giga_DM dm (
    .a(ALUResult[8:0]),
    .dpra(ALUResult[8:0]),
    .clk(clk),
    .we(MemWrite),
    .dpo(ReadData),
    .d(ReadData)
    
//        .clk(clk),
//        .reset(rst),
//        .Address(ALUResult),
//        .WriteData(ReadData2),
//        .ReadData(ReadData)
    );

    // === Write-Back Muxes ===
    assign WriteData = MemToReg ? ReadData : ALUResult;
    assign WriteData_Float = ReadData_Float2; // Could be updated if float ALU is added

endmodule