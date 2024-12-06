`timescale 1ns / 1ps

module sim_8x7seg(
    input	 clk,
    input [6:0] inv_leds,
    input [7:0] enb_leds
    );

   integer i;
   reg [6:0] ledsave[0:7];

   initial
     begin
	for (i=0;i<8;i=i+1) ledsave[i] = 7'h7f;
     end
   
   always @(negedge clk)
     begin
	for (i=0;i<8;i=i+1)
	  if (~enb_leds[i]) ledsave[i] = inv_leds;
     end
   
   always @(ledsave[0],ledsave[1],ledsave[2],ledsave[3],ledsave[4],ledsave[5],ledsave[6],ledsave[7])
     begin
	for (i=7;i>=0;i=i-1) begin
	   if (~ledsave[i][0]) $write(" - "); else $write("   ");
	   $write("   ");
	end
	$display(" ");
	
	for (i=7;i>=0;i=i-1) begin
	   if (~ledsave[i][5]) $write("|"); else $write(" ");
	   $write(" ");
	   if (~ledsave[i][1]) $write("|"); else $write(" ");
	   $write("   ");
	end
	$display(" ");
	
	for (i=7;i>=0;i=i-1) begin
	   if (~ledsave[i][6]) $write(" - "); else $write("   ");
	   $write("   ");
	end
	$display(" ");
	
	for (i=7;i>=0;i=i-1) begin
	   if (~ledsave[i][4]) $write("|"); else $write(" ");
	   $write(" ");
	   if (~ledsave[i][2]) $write("|"); else $write(" ");
	   $write("   ");
	end
	$display(" ");

	for (i=7;i>=0;i=i-1) begin
	   if (~ledsave[i][3]) $write(" - "); else $write("   ");
	   $write("   ");
	end
	$display(" ");
	$display(" ");
     end
   
endmodule
