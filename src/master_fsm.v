`timescale 1ns / 1ps

module master_fsm(
		  input		   clk,
		  input		   reset,
		  input [7:0]	   item_cost,
		  input		   select,
		  input		   q25,
		  input		   d10,
		  input		   sending,
		  output reg [2:0] fsm_state,
		  output reg [7:0] amount
		  );

   localparam		       WAITSELECTION = 0;
   localparam		       WAITPAYMENT = 1;
   localparam		       GOTQUARTER = 2;
   localparam		       GOTDIME = 3;
   localparam		       DISPENSING = 4;
   localparam		       CHANGERETURN = 5;

   reg [2:0]		       next_state;
   reg [7:0]		       new_amount;

   always @(posedge clk or posedge reset)
     if (reset) begin
	fsm_state <= WAITSELECTION;
	amount <= 0;
     end else begin
	fsm_state <= next_state;
	amount <= new_amount;
     end

   always @(*)
     begin

   new_amount = amount;
   next_state = fsm_state;
	case (fsm_state)

    WAITSELECTION: begin
            new_amount = item_cost;
            if (select) 
            begin
                next_state = WAITPAYMENT;
            end
        else 
            begin
                next_state = WAITSELECTION;
            end
                
    end

    WAITPAYMENT: 
    begin
            if (q25) begin
                next_state = GOTQUARTER;
            end else if (d10) begin
                next_state = GOTDIME;
            end
            else begin
                next_state = WAITPAYMENT;
            end
    end
    
    GOTQUARTER:
    begin

        if (amount > 25)
                begin
                    new_amount = amount - 25;
                    next_state = WAITPAYMENT;
                end
        else
        begin
        new_amount = 25 - amount;
        next_state = DISPENSING;
        end
    end
    
    GOTDIME: 
    begin

         if (amount > 10)
                begin
                    new_amount = amount - 10;
                    next_state = WAITPAYMENT;
                end

                else 
                begin
                new_amount = 10 - amount;
                next_state = DISPENSING;
                end
    end
    
    DISPENSING: begin
            if (new_amount > 0)
            begin
               if (!sending) 
                next_state = CHANGERETURN;
               else 
                next_state = DISPENSING;
            end
            else
            begin
                next_state = WAITSELECTION;
            end
    end
    
    CHANGERETURN: begin
           if (!sending) 
                next_state = WAITSELECTION;
               else 
                next_state = CHANGERETURN;
    end
    
    default: 
        begin
            next_state = WAITSELECTION;
        end
    
	endcase // case (fsm_state)
     end
endmodule

//`timescale 1ns / 1ps

//module master_fsm(
//		  input		   clk,
//		  input		   reset,
//		  input [7:0]	   item_cost,
//		  input		   select,
//		  input		   q25,
//		  input		   d10,
//		  input		   sending,
//		  output reg [2:0] fsm_state,
//		  output reg [7:0] amount
//		  );

//   localparam		       WAITSELECTION = 0;
//   localparam		       WAITPAYMENT = 1;
//   localparam		       GOTQUARTER = 2;
//   localparam		       GOTDIME = 3;
//   localparam		       DISPENSING = 4;
//   localparam		       CHANGERETURN = 5;

//   reg [2:0]		       next_state;
//   reg [7:0]		       new_amount;

//   always @(posedge clk or posedge reset)
//     if (reset) begin
//	fsm_state <= WAITSELECTION;
//	amount <= 0;
//     end else begin
//	fsm_state <= next_state;
//	amount <= new_amount;
//     end

//   always @(*)
//     begin

//   new_amount = amount;
//   next_state = fsm_state;
//	case (fsm_state)

//    WAITSELECTION: begin
//            new_amount = item_cost;
//            if (select) 
//            begin
//                next_state = WAITPAYMENT;
//            end
//        else 
//            begin
//                next_state = WAITSELECTION;
//            end
                
//    end

//    WAITPAYMENT: 
//    begin
//            if (q25) begin
//                next_state = GOTQUARTER;
//            end else if (d10) begin
//                next_state = GOTDIME;
//            end
//            else begin
//                next_state = WAITPAYMENT;
//            end
//    end
    
//    GOTQUARTER:
//    begin

//        new_amount = amount - 25;
//        if (new_amount <= 0) begin
//            next_state = DISPENSING;
//        end else begin
//            next_state = WAITPAYMENT;
//        end
//    end
    
//    GOTDIME: 
//    begin

//            new_amount = amount - 10;
//            if (new_amount <= 0) begin
//                next_state = DISPENSING;
//            end else begin
//                next_state = WAITPAYMENT;
//        end
        
//    end
    
//    DISPENSING: begin
//        if (new_amount < 0) begin
//            next_state = CHANGERETURN;
//        end else begin
//            next_state = WAITSELECTION;
//            new_amount = 0;
//        end
//    end
    
//    CHANGERETURN: begin
//        new_amount = -new_amount;
//        next_state = WAITSELECTION;
//    end
    
//    default: 
//        begin
//            next_state = WAITSELECTION;
//        end
    
//	endcase // case (fsm_state)
//     end
//endmodule
   
