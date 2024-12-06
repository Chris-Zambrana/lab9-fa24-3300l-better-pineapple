`timescale 1ns / 1ps
   
module item_cost(
		 input [2:0] item_sel,
		 output reg [7:0] item_cost
		 );
   
   always @(*)
     case (item_sel)
       0: item_cost = 125;
       1: item_cost = 100;
       2: item_cost = 85;
       3: item_cost = 150;
       4: item_cost = 225;
       5: item_cost = 185;
       6: item_cost = 50;
       7: item_cost = 135;
       default: item_cost = 100;
     endcase
endmodule
