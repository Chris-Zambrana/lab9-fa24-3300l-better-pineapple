`timescale 1ns / 1ps

module doubdab_8bits(
    input [7:0] b_in,
    output [11:0] bcd_out
    );

//
// Fill in the connections and wires to implement the double-dabble algorithm
//  
//  
    wire [3:0] dd_add_out [6:0];
    assign bcd_out[11:10] = 0;
    
    
    dd_add3 u1 (.i({1'b0,b_in[7:5]}),.o(dd_add_out[0]));
    
    dd_add3 u2 (.i({dd_add_out[0][2:0],b_in[4]}),.o(dd_add_out[1]));

    dd_add3 u3 (.i({dd_add_out[1][2:0],b_in[3]}),.o(dd_add_out[2]));
    
    //top dd_add
    dd_add3 u4 (.i({1'b0,dd_add_out[0][3],dd_add_out[1][3],dd_add_out[2][3]}),.o(dd_add_out[3]));
    // bottom dd add
    dd_add3 u6 (.i({dd_add_out[2][2:0],b_in[2]}),.o(dd_add_out[4]));
    
    // top dd add
    dd_add3 u5 (.i({dd_add_out[3][2:0],dd_add_out[4][3]}),.o(dd_add_out[5]));
    // bottom dd add
    dd_add3 u7 (.i({dd_add_out[4][2:0],b_in[1]}),.o(dd_add_out[6]));
    
    assign bcd_out[9]=dd_add_out[3][3];
    assign bcd_out[8:5]=dd_add_out[5];
    assign bcd_out[4:1]=dd_add_out[6];
    assign bcd_out[0]=b_in[0];
    
endmodule
