`timescale 1ns / 1ps
   
module combo_lock(
	    input	 clk,
	    input reset,
	    output	 led1_r,
	    output	 led1_g,
	    output	 led1_b,
	    input 	 prog_sw,
	    input	 clr_button, 
	    input	 up_button, 
	    input	 dn_button,
	    input	 lf_button,
	    input	 rt_button,
	    output [3:0] fsm_state,
	    output ampPWM,
	    output ampSD
	    );

   wire [1:0]		 color;
   wire [3:0]		 combo_1;
   wire [3:0]		 combo_2;
   wire [3:0]		 combo_3;
   wire [3:0]		 combo_4;
   wire [3:0]		 combo_press;
   wire [1:0]		 location;
   wire			 clr, up_press, down_press, right_press, pressed;
   wire			 enable_store;
   
   //music
   wire [7:0] sinpos1, envout;
   wire	      pwm;
   wire [10:0] freq;
   wire [7:0] note_out;

   wire [7:0]	  dout;

   assign ampPWM = (pwm) ? 1'bz : 1'b0;
   assign ampSD = env_run;
   
   //music note
   
   
   button_pulse u_db0 (clk, clr_button, clr);

   button_pulse u_db1 (clk, up_button, up_press);
   button_pulse u_db2 (clk, dn_button, down_press);
   button_pulse u_db3 (clk, lf_button, left_press);
   button_pulse u_db4 (clk, rt_button, right_press);

   assign combo_press = {up_press, down_press, left_press, right_press};
   assign pressed = |combo_press;

   fsm_outputs u_fout0 (
			// Outputs
			.enable_store	(enable_store),
			.location	(location[1:0]),
			.color_out	(color[1:0]),
			// Inputs
			.state		(fsm_state[3:0]));

   store_combo u2 (
		   // Outputs
		   .combo_1		(combo_1[3:0]),
		   .combo_2		(combo_2[3:0]),
		   .combo_3		(combo_3[3:0]),
		   .combo_4		(combo_4[3:0]),
		   // Inputs
		   .clk			(clk),
		   .combo_press		(combo_press[3:0]),
		   .pressed		(pressed),
		   .enable_store	(enable_store),
		   .location		(location[1:0]));
   
   led_color_rygb u1 (
		 // Outputs
		 .led_r			(led1_r),
		 .led_g			(led1_g),
		 .led_b			(led1_b),
		 // Inputs
		 .clk			(clk),
		 .color			(color[1:0]));
		 
   master_fsm u_fsm0 (
		      // Outputs
		      .state_out	(fsm_state[3:0]),
		      // Inputs
		      .clk		(clk),
		      .prog_sw		(prog_sw),
		      .clr		(clr),
		      .combo_1		(combo_1[3:0]),
		      .combo_2		(combo_2[3:0]),
		      .combo_3		(combo_3[3:0]),
		      .combo_4		(combo_4[3:0]),
		      .combo_press	(combo_press[3:0]),
		      .pressed		(pressed),
		      .note_start (note_start),
		      .envdone (envdone),
		      .note_out (note_out[7:0])
		      );
   
   envel_gen egen (clk, reset, 11'h180, 11'h1f0, note_start, envout[7:0], env_run, envdone);

   read_music rmus (note_out[7:0], freq[10:0]);
    
   sine_gen sigen(clk, reset, freq[10:0], envout[7:0], sinpos1[7:0]);
   
   pwm_gen2 pwmg(clk, reset, sinpos1[7:0], pwm);

endmodule	

