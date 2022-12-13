`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2022 12:15:23 PM
// Design Name: 
// Module Name: hr_24_clk
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


module hr_24_clk(
    input clk_1kHz,
    input resetn,
    input edit,
    input [1:0] mode,
    
    input BTN_inc_h,
    input BTN_inc_m,
    
    output reg [3:0] k2,
    output reg [3:0] k1,
    output reg [3:0] k0,
    output reg [3:0] s1,
    output reg [3:0] s0,
    output reg [3:0] m1,
    output reg [3:0] m0,
    output reg [3:0] h1,
    output reg [3:0] h0
    );
    
    parameter SIX = 4'b0110;
    parameter TEN = 4'b1010;
    parameter THREE = 4'b0011;
    parameter TWO = 4'b0010;
    parameter FOUR = 4'b0100;
    parameter FIVE = 4'b0101;
    
    reg inc_h, inc_m;
    
    initial begin
        s1 <= 0; s0 <= 0;
        m1 <= 0; m0 <= 0;
        h1 <= 0 ; h0 <= 0;
    end
    
    always@(posedge BTN_inc_h or posedge clk_1kHz)begin
        if(BTN_inc_h)begin
            inc_h <= 1;
        end else begin
            inc_h <= 0;
        end
    end
    
    always@(posedge BTN_inc_m or posedge clk_1kHz)begin
        if(BTN_inc_m)begin
            inc_m <= 1;
        end else begin
            inc_m <= 0;
        end
    end
    
    
    always @ (posedge clk_1kHz or negedge resetn)begin
        if(!resetn && (mode == 2'b00 || mode == 2'b01))begin
            k2 <= 0; k1 <= 0; k0 <= 0;
            s1 <= 0; s0 <= 0;
            m1 <= 0; m0 <= 0;
            h1 <= 0; h0 <= 0;
        end else if(edit && (mode == 2'b00 || mode == 2'b01)) begin
        
            h0 <= h0 + inc_h;
            if(h0 == TEN)begin
                h0 <= 0;
                h1 <= h1 + 1;
            end
            if((h1 == TWO) && (h0 == FOUR))begin
                h1 <= 0;
                h0 <= 0;
            end
            
            m0 <= m0 + inc_m;
            if(m0 == TEN)begin
                m0 <= 0;
                m1 <= m1 + 1;
            end
            if(m1 == SIX)begin
                m1 <= 0;
                m0 <= 0;
            end
            
        end else if(!edit) begin
            k0 <= k0 + 1;
            if(k0 == TEN)begin
                k0 <= 0;
                k1 <= k1 + 1;
            end
            if(k1 == TEN)begin
                k1 <= 1;
                k2 <= k2 + 1;
            end
            if(k2 == TEN)begin
                k2 <= 2;
                s0 <= s0 + 1;
            end
            if(s0 == TEN)begin
                s0 <= 0;
                s1 <= s1 + 1;
            end 
            if(s1 == SIX)begin
                s1 <= 0;
                m0 <= m0 + 1;
            end
            if(m0 == TEN)begin
                m0 <= 0;
                m1 <= m1 + 1;
            end
            if(m1 == SIX)begin
                m1 <= 0;
                h0 <= h0 + 1;
            end
            if(h0 == TEN)begin
                h0 <= 0;
                h1 <= h1 + 1;
            end
            if((h1 == TWO) && (h0 == FOUR))begin
                h1 <= 0;
                h0 <= 0;
            end
        end // always
    end
    
endmodule
       
