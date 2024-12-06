`timescale 1ns / 1ps

module decode_enb_leds(
    input [2:0] sel,
    output reg [7:0] enb_leds
    );

always @(*)
begin
    case(sel)
        0: enb_leds = 8'b11111110;
        1: enb_leds = 8'b11111101;
        2: enb_leds = 8'b11111011;
        3: enb_leds = 8'b11110111;
        4: enb_leds = 8'b11101111;
        5: enb_leds = 8'b11011111;
        6: enb_leds = 8'b10111111;
        7: enb_leds = 8'b01111111;
        default: enb_leds = 0;
     endcase
end
endmodule
