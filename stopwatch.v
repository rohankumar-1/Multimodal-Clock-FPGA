`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2022 06:52:25 PM
// Design Name: 
// Module Name: counter_with_enable
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

module stopwatch(
    input enable_swt,
    //input increment,
    input clock_1kHz,
    input resetn,
    output reg [3:0] s0,
    output reg [3:0] s1,
    output reg [3:0] m0,
    output reg [3:0] m1,
    output reg [3:0] h0,
    output reg [3:0] h1,
    output reg [3:0] k2,
    output reg [3:0] k1,
    output reg [3:0] k0
    );
    
    parameter SIX = 4'b0110;
    parameter TEN = 4'b1010;
    parameter THREE = 4'b0011;
    parameter TWO = 4'b0010;
    
    // 60 can be represented in binary in 6 bits binary
    // binary should be converted to BCD -> seven-segment/VGA

    
    initial begin
         s0 = 0; s1 = 0;
         m0 = 0; m1 = 0;
         h0 = 0; h1 = 0;
         k0 = 0; k1 = 0; k2 = 0;
    end

     
    always@(posedge clock_1kHz or negedge resetn)begin
        if(!resetn) begin
            s0 <= 0; s1 <= 0; 
            m0 <= 0; m1 <= 0; 
            h0 <= 0; h1 <= 0;
            k0 <= 0; k1 <= 0; k2 <= 0;
        end 
        else if(enable_swt) begin
            k0 <= k0 + 1;
            if(k0==TEN) begin
                k1<=k1+1;
                k0<=0;
            end
            if(k1==TEN) begin
                k2<=k2+1;
                k1<=0;
            end
            if(k2==TEN) begin
                s0<=s0+1;
                k2<=0;
            end
            if(s0==TEN) begin
                s1<= s1+1;
                s0<=0;
            end
            if(s1==SIX) begin
                m0<=m0+1;
                s1<=0;
            end
            if(m0==TEN) begin
                m1<=m1+1;
                m0<=0;         
            end
            if(m1==SIX) begin
                h0<=h0+1;
                m1<=0;
            end
            if(h0==THREE) begin
                h1<=h1+1;
                h0<=0;
            end
            if(h1==TWO)
                h1<=0;
            end
    end
endmodule