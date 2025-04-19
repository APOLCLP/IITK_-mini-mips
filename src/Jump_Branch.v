module Giga_JB (
    input [31:0] PC,              // Current Program Counter
    input [31:0] Instruction,     // Instruction being decoded
    input Branch,                 // Branch signal
    input Jump,                   // Jump signal
    input Zero,                   // Zero flag from ALU
    output reg [31:0] next_PC     // Next Program Counter to be used
);

    always @(*) begin
        // Default: PC + 4 (next instruction)
        next_PC = PC + 4;

        if (Jump) begin
            // Jump to target address
            next_PC = {PC[31:28], Instruction[25:0], 2'b00};
        end else if (Branch && Zero) begin
            // If branch is taken, calculate target address (PC + offset)
            next_PC = PC + {{14{Instruction[15]}}, Instruction[15:0], 2'b00};
        end
    end
endmodule