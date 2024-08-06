/*
 * Copyright (c) 2024 Udi Finkelstein
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  assign uio_out = 0;
  assign uio_oe  = 0;

  wire [9:0]h_count;
  wire [9:0]v_count;

  wire rst = ~rst_n;
  wire x_1 = ( h_count == 10'd1);
  wire y_0 = ( v_count == 10'd0);
  wire x_640 = ( h_count == 10'd640);
  wire y_479 = ( v_count == 10'd479);
  wire white = x_1 | y_0 | x_640 | y_479;
  
  
  assign {uo_out[0], uo_out[4]} = white ? 2'b11 : h_count[7:6]; // R
  assign {uo_out[1], uo_out[5]} = white ? 2'b11 : v_count[7:6]; // G
  assign {uo_out[2], uo_out[6]} = white ? 2'b11 : v_count[5:4]; // B
 
  vgaControl vga_inst(
	.clock(clk),
	.reset(rst),       // action on posedge clock, reset is active low, enable active high
	.h_sync(uo_out[7]),
	.v_sync(uo_out[3]),             // syncs are active low
	.bright(),                   // bright is active high
	.h_count(h_count),
	.v_count(v_count)
);

endmodule
