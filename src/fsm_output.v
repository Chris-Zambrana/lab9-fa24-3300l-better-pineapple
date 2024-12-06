`timescale 1ns / 1ps

module fsm_output(
		  input [2:0] fsm_state,
		  output give_change,
		  output dispense
		  );

   localparam		       WAITSELECTION = 0;
   localparam		       WAITPAYMENT = 1;
   localparam		       GOTQUARTER = 2;
   localparam		       GOTDIME = 3;
   localparam		       DISPENSING = 4;
   localparam		       CHANGERETURN = 5;

   assign dispense = (fsm_state == DISPENSING) ? 1 : 0;
   assign give_change = (fsm_state == CHANGERETURN) ? 1 : 0;
   
endmodule // fsm_output

