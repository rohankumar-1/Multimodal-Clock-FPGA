`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2022 08:49:06 PM
// Design Name: 
// Module Name: clock_divider_1kHz
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_divider_1kHz(
    input clk_i,
    output reg clk_o
    );
    
    reg [17:0] divcount;
    
    parameter CHANGE = 'd50000;
    
    initial begin
        clk_o = 0;
        divcount = 0;
    end
    
    always @ (posedge clk_i) begin
        if(divcount == CHANGE)begin
            clk_o <= ~clk_o;
            divcount <= 0;
        end else begin
            divcount <= divcount + 1'b1;
        end
    end
endmodule
