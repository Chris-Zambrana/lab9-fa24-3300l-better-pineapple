`timescale 1ns / 1ps

module rxparse(
   input clk,
   input reset, 
   input rx_dv,
   input [7:0] rx_byte, 
   output reg select, 
   output reg q25, 
   output reg d10,
   output reg [2:0] item,
   output reg [7:0] dout,
   output reg note_start
   );

    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
 	    item <= 0;
            select <= 0;
            q25 <= 0;
            d10 <= 0;
            note_start <= 0;
        end 
        else begin
            note_start <=0;
            if(rx_dv) begin
               
               if (rx_byte >= 8'h30 && rx_byte <= 8'h37) begin
                   item <= rx_byte[2:0]; 
               end

               
               case (rx_byte)
                   8'h51: q25 <= 1'b1; 
                   8'h44: d10 <= 1'b1; 
                   8'h53: select <= 1'b1; 
                   default: begin
                       q25 <= 1'b0;
                       d10 <= 1'b0;
                       select <= 1'b0;
                   end
               endcase
               dout <= rx_byte;
               note_start <= 1;
           end 
           else begin
               select <= 1'b0;
               q25 <= 1'b0;
               d10 <= 1'b0;
           end
        end
    end

endmodule
