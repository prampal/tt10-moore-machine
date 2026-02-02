/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_prampal_moore (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

     // input
    wire x1 = ui_in[0];
    // output
    wire z1;
    reg [1:3] y;
    reg [1:3] next_state;

    parameter state_a=3'b000,
        state_b=3'b010,
        state_c=3'b110,
        state_d=3'b100,
        state_e=3'b011;

    always@(posedge clk)
    begin
        if(~rst_n)
            y<=state_a;
        else
            y<=next_state;
        end
    assign z1 = ~clk & y[3];
always@(y or x1)
begin
case(y)
state_a:
if(x1==0)
next_state=state_a;
else
next_state=state_b;
state_b:
if(x1==0)
next_state=state_a;
else
next_state=state_c;
state_c:
if(x1==0)
next_state=state_d;
else
next_state=state_c;
state_d:
if(x1==0)
next_state=state_a;
else
next_state=state_e;
state_e:
if(x1==0)
next_state=state_a;
else
next_state=state_c;
default:next_state=state_a;
endcase
end

// All output pins must be assigned. If not used, assign to 0.
assign uo_out[0] = y[1];
assign uo_out[1] = y[2];
assign uo_out[2] = y[3];
assign uo_out[3] = z1;
assign uo_out[4] = 1'b0;
assign uo_out[5] = 1'b0;
assign uo_out[6] = 1'b0;
assign uo_out[7] = 1'b0;
assign uio_out = 0;
assign uio_oe = 0;    
    
  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in[7:1], uio_in, 1'b0};

endmodule
