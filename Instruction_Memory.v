/**
 * Copyright 2026 Jordan Nzokou
 * Project: Nexvantis
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

`timescale 1ns/1ps
`default_nettype none

// Asynchronous instruction memory. A is byte-addressed; bits [1:0] are
// discarded to select a 32-bit word.
module Instruction_Memory #(
    parameter DEPTH      = 256,
    parameter ADDR_WIDTH = 8,
    parameter MEMFILE    = "program.hex"
)(
    input  wire        rst_n,
    input  wire [31:0] A,
    output wire [31:0] RD
);

    reg [31:0] mem [0:DEPTH-1];
    integer i;

    initial begin
        // Fill unused locations with the RV32I NOP encoding before loading the
        // program image. This prevents X propagation beyond the program end.
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = 32'h00000013;

        $readmemh(MEMFILE, mem);
    end

    assign RD = (!rst_n) ? 32'h00000013 : mem[A[ADDR_WIDTH+1:2]];

endmodule

`default_nettype wire
