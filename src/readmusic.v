`timescale 1ns / 1ps

module readmusic(
   input [7:0] note, 
   output reg [10:0] freq
   );

    always @(*)
      begin
	 case (note)
           "0": freq = 500;
           "1": freq = 550;
           "2": freq = 600;
           "3": freq = 650;
           "4": freq = 700;
           "5": freq = 750;
           "6": freq = 800;
           "7": freq = 850;
           "Q": freq = 1000;
           "D": freq = 1250;
           "S": freq = 2000;
	 endcase 
      end 
endmodule
