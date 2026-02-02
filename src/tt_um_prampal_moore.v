/*
 * Copyright (c) 2024
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_prampal_moore (
    input  wire [7:0] ui_in,    // inputs
    output wire [7:0] uo_out,   // outputs
    input  wire [7:0] uio_in,   // bidir inputs
    output wire [7:0] uio_out,  // bidir outputs
    output wire [7:0] uio_oe,   // bidir enables
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // Input
    wire x1 = ui_in[0];

    // State registers
    reg [2:0] state;
    reg [2:0] next_state;

    // State encoding
    localparam STATE_A = 3'b000;
    localparam STATE_B = 3'b001;
    localparam STATE_C = 3'b010;
    localparam STATE_D = 3'b011;
    localparam STATE_E = 3'b100;

    // Sequential logic
    always @(posedge clk) begin
        if (!rst_n)
            state <= STATE_A;
        else
            state <= next_state;
    end

    // Next-state logic (combinational)
    always @(*) begin
        case (state)
            STATE_A: next_state = x1 ? STATE_B : STATE_A;
            STATE_B: next_state = x1 ? STATE_C : STATE_A;
            STATE_C: next_state = x1 ? STATE_C : STATE_D;
            STATE_D: next_state = x1 ? STATE_E : STATE_A;
            STATE_E: next_state = x1 ? STATE_C : STATE_A;
            default: next_state = STATE_A;
        endcase
    end

    // Moore output (depends ONLY on state)
    wire z1 = (state == STATE_E);

    // Output mapping
    assign uo_out[2:0] = state;
    assign uo_out[3]   = z1;
    assign uo_out[7:4] = 4'b0000;

    // Unused bidirectional pins
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    // Prevent unused warnings
    wire _unused = &{ena, ui_in[7:1], uio_in, 1'b0};

endmodule
