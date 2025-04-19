module Giga_R (
    input clk,
    input reset,
    input RegWrite,
    input FloatRegWrite,  // Control signal for floating-point write
    input [4:0] read_addr1,
    input [4:0] read_addr2,
    input [4:0] write_addr,
    input [31:0] write_data,
    input [31:0] write_data_float, // Data to write to floating-point registers
    output reg [31:0] read_data1,
    output reg [31:0] read_data2,
    output reg [31:0] read_data_float1, // Read from floating-point registers
    output reg [31:0] read_data_float2  // Read from floating-point registers
);

    reg [31:0] registers [0:31];      // 32 general-purpose registers (GPRs)
    reg [31:0] float_registers [0:31]; // 32 floating-point registers (FPRs)
    integer i;
    always @(posedge clk) begin
        if (reset) begin
            // Reset general-purpose registers
            registers[0] <= 32'b0;  // $zero is always zero
            
            for ( i = 1; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
            // Reset floating-point registers
            for ( i = 0; i < 32; i = i + 1) begin
                float_registers[i] <= 32'b0;
            end
        end
        else if (RegWrite) begin
            registers[write_addr] <= write_data; // Write to general-purpose registers
        end
        if (FloatRegWrite) begin
            float_registers[write_addr] <= write_data_float; // Write to floating-point registers
        end
    end

    always @(*) begin
        // Read general-purpose registers
        read_data1 = registers[read_addr1];
        read_data2 = registers[read_addr2];

        // Read floating-point registers
        read_data_float1 = float_registers[read_addr1];
        read_data_float2 = float_registers[read_addr2];
    end
endmodule