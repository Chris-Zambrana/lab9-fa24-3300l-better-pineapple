`timescale 1ns / 1ps

module seven_seg_decoder(
    input [3:0] b_in,
    output [6:0] inv_leds
    );
    
    wire [6:0] leds;

    bin_to_leds u1 (.b_in(b_in), .leds(leds));
    invert7 u2 (.a(leds), .x(inv_leds));
endmodule


