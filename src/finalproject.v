`timescale 1ns / 1ps


module finalproject(
        input clk,
        input reset,
        input UART_RX,
        output [6:0] inv_leds,
        output [7:0] enb_leds,
        output [2:0] fsm_state,
        output UART_TX,
        output ampPWM,
        output ampSD
	    );

   wire [11:0]		    amount_bcd;
   wire [7:0]		    amount;
   wire [7:0]		    item_cost;
   wire			    rx_dv;
   wire [7:0]		    rx_byte;
   wire			    tx_dv;
   wire [7:0]		    tx_byte;
   wire [(6*8)-1:0]	    message;
   wire [2:0]		    item;
   wire			    select, q25, d10, sending, give_change, dispense;
   wire [2:0]		    sel;
   wire [3:0]		    bcd_digit;
   
   wire [7:0] sinpos1, envout;
   wire pwm;
   wire [10:0] freq;
   wire note_start;
   wire env_run;
   wire [7:0] dout;
        
    assign ampPWM = (pwm) ? 1'bz : 1'b0;
    assign ampSD = env_run;
   
  readmusic rmus (dout[7:0], freq[10:0]);
   
  rxparse rxp (
     // Outputs
     .select		(select),
     .q25			(q25),
     .d10			(d10),
     .item			(item[2:0]),
     .dout          (dout[7:0]),
     .note_start    (note_start),
     // Inputs
     .clk			(clk),
     .reset			(reset),
     .rx_dv			(rx_dv),
     .rx_byte		(rx_byte[7:0]));
     
     
   // unchanged
   
   uart_rx_vlog rx0 (clk, UART_RX, rx_dv, rx_byte);

   uart_tx_vlog tx0 (clk, tx_dv, tx_byte, UART_TX, tx_done, tx_ready);


   tx_parse txp (
		 // Outputs
		 .tx_dv			(tx_dv),
		 .tx_byte		(tx_byte[7:0]),
		 .sending		(sending),
		 // Inputs
		 .clk			(clk),
		 .reset			(reset),
		 .tx_ready		(tx_ready),
		 .message		(message[(6*8)-1:0]));

  master_fsm u_fsm0 (
          // Outputs
          .fsm_state	(fsm_state[2:0]),
          .amount		(amount[7:0]),
          // Inputs
          .clk		(clk),
          .reset		(reset),
          .item_cost	(item_cost[7:0]),
          .select		(select),
          .q25		(q25),
          .d10		(d10),
          .sending		(sending));
		      
   item_cost u_ic0 (item, item_cost);

   bcd_to_ascii u_asc (
		       // Outputs
		       .message		(message[(6*8)-1:0]),
		       // Inputs
		       .give_change	(give_change),
		       .amount_bcd	(amount_bcd[11:0]),
		       .dispense	(dispense));
   
   fsm_output u_fsm1 (
		      // Outputs
		      .give_change	(give_change),
		      .dispense		(dispense),
		      // Inputs
		      .fsm_state	(fsm_state[2:0]));

   doubdab_8bits u2 (.b_in (amount[7:0]), .bcd_out (amount_bcd));

   count_3bit_select u3 (.clk(clk), .sel(sel));

   decode_enb_leds u4 (.sel(sel), .enb_leds(enb_leds));

   mux_4in_8to1 u5 (.in0(amount_bcd[3:0]), .in1(amount_bcd[7:4]), .in2(amount_bcd[11:8]), .in3(4'h0), 
		    .in4(4'h0), .in5(4'h0), .in6(4'h0), .in7(4'h0), .sel(sel), .out(bcd_digit) );

   seven_seg_decoder u6 (.b_in(bcd_digit), .inv_leds(inv_leds));
   
   envel_gen egen (clk, reset, 11'h180, 11'h1f0, note_start, envout[7:0], env_run, env_done);
   sine_gen sigen (clk, reset, freq[10:0], envout[7:0], sinpos1[7:0]);
   pwm_gen pwmg (clk, reset, sinpos1[7:0], pwm);
   
endmodule
