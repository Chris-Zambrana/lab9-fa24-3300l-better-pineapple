`timescale 1ns / 1ps

module calc_7seg(
    input	 clk,
    input [1:0]	 OP,
    input [3:0]	 A, B,
    output [6:0] inv_leds,
    output [7:0] enb_leds,
    output	 cout, ovf 
    );
    
   wire [7:0]	b_calc;     // the 8-bit result from the calculator
   wire [11:0]	b_bcd;      // the binary-coded-decimal 3 digit value from the double-dabble block
   wire [2:0]	sel;        // counts from 0 to 7, to select one 7-segment display at a time
   wire [3:0]	bcd_digit;  // the selected bcd digit to be displayed
   
   calculator u1 (.OP (OP), .A (A), .B (B), .out({ovf, cout, b_calc}));

   doubdab_8bits u2 (.b_in (b_calc), .bcd_out (b_bcd));

   count_3bit_select u3 (.clk(clk), .sel(sel));

   decode_enb_leds u4 (.sel(sel), .enb_leds(enb_leds));

   mux_4in_8to1 u5 (.in0(b_bcd[3:0]), .in1(b_bcd[7:4]), .in2(b_bcd[11:8]), .in3(4'h0), 
		    .in4(4'h0), .in5(4'h0), .in6(4'h0), .in7(4'h0), .sel(sel), .out(bcd_digit) );

   seven_seg_decoder u6 (.b_in(bcd_digit), .inv_leds(inv_leds));
   
endmodule
