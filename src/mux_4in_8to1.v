`timescale 1ns / 1ps

module mux_4in_8to1 (
	       input [3:0] in0, in1, in2, in3, in4, in5, in6, in7,
	       input [2:0] sel,
	       output reg [3:0] out
	       );
	       
always @(*)
begin 
    case(sel)
        0: out = in0;
        1: out = in1;
        2: out = in2;    
        default: out = 0;
    endcase
end
endmodule
