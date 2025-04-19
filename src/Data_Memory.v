`timescale 1ps/1ps

// Data Memory with Reset and FPU compatibility
module Giga_DM(
    input [8:0] a,
    input [8:0] dpra,
    input clk,
    input we,
    output [31:0] dpo,
    input [31:0] d 
    
);


     
    dist_mem_gen_0 dm (
  .a(a),        // input wire [8 : 0] a , data write address
  .d(d),        // input wire [31 : 0] d
  .dpra(dpra),  // input wire [8 : 0] dpra, data read address
  .clk(clk),    // input wire clk
  .we(we),      // input wire we
  .dpo(dpo)    // output wire [31 : 0] dpo
    );
endmodule