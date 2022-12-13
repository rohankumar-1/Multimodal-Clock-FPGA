`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2022 10:25:02 AM
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input clk,
    input reset,
    input button_in,
    output reg button_out
    );
    reg [20:0] counter;
    
    reg out_exist;
    parameter MAX=21'b111111111111111111111;
   // reg [6:0] counter;
    //parameter MAX=7'b1111111;
    always @ (posedge clk or negedge reset)begin
        if(!reset)begin 
            button_out<=0;
            counter<=0;
            out_exist<=0;
        end else if(!button_in)begin
            counter<=0;
            out_exist<=0;
        end
        else if(out_exist)begin
            button_out<=0;
        end else begin
            counter<=counter+1;
            
            if(counter==MAX)begin
                button_out<=1;
                counter<=0;
                out_exist<=1;
            end
        
        end
    end // always
  
endmodule