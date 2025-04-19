`timescale 1ns / 1ps

// Instruction Memory with reset and optional file loading
module Giga_IM(
    input [8:0] a,
    input we,
    input clk,
    output [31:0] spo,
    input [31:0] d
);

     
    dist_mem_gen_1 im (
  .a(a),        // input wire [8 : 0] a , data write address
  .d(d),        // input wire [31 : 0] d  // input wire [8 : 0] dpra, data read address
  .clk(clk),    // input wire clk
  .we(we),      // input wire we
  .spo(spo)    // output wire [31 : 0] dpo
);
endmodule