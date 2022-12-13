`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2022 09:15:17 PM
// Design Name: 
// Module Name: timer
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


module timer(
    input enable_swt,
    input clock_1kHz,
    input resetn,
    
    input BTN_inc_h,
    input BTN_inc_m,
    
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
    
    parameter FIVE = 4'b0110;
    parameter NINE = 4'b1010;
    parameter TWO = 4'b0011;
    parameter ONE = 4'b0010;
    parameter FOUR = 4'b0101;
    
    reg inc_h, inc_m;
    
    initial begin
        s1 = 0; s0 = 0;
        m1 = 0; m0 = 0;
        h1 = 0 ; h0 = 0;
    end
    
    always@(posedge BTN_inc_h or posedge clock_1kHz)begin
        if(BTN_inc_h)begin
            inc_h <= 1;
        end else begin
            inc_h <= 0;
        end
    end
    
    always@(posedge BTN_inc_m or posedge clock_1kHz)begin
        if(BTN_inc_m)begin
            inc_m <= 1;
        end else begin
            inc_m <= 0;
        end
    end
    
    
    always @ (posedge clock_1kHz or negedge resetn)begin
        if(!resetn) begin
            s1 <= 0; s0 <= 0;
            m1 <= 0; m0 <= 0;
            h1 <= 0; h0 <= 0;
            k0 <= 0; k1 <= 0; k2 <= 0;
        end else if(!enable_swt)begin
            h0 <= h0 + inc_h;
            if(h0 == NINE)begin
                h0 <= 0;
                h1 <= h1 + 1;
            end
            if(h1 == ONE && h0 == 4'b0100)begin
                h1 <= 0;
                h0 <= 0;
            end
            
            m0 <= m0 + inc_m;
            if(m0 == NINE)begin
                m0 <= 0;
                m1 <= m1 + 1;
            end
            if(m1 == FIVE)begin
                m1 <= 0;
                h0 <= h0 + 1;
            end
        end else if(enable_swt) begin
            if({k0, k1, k2, h1, h0, m1, m0, s1, s0} == 0) begin
                k0 <= k0;
            end else begin
                if(!k0)begin
                    k0 <= 4'b1001;
                    k1 <= k1 - 1;
                    if(!k1)begin
                        k1 <= 4'b1001;
                        k2 <= k2 - 1;
                        if(!k2)begin
                            k2 <= 4'b1001;
                            s0 <= s0 - 1;
                            if(!s0)begin
                                s0 <= 4'b1001;
                                s1 <= s1 - 1;
                                if(!s1)begin
                                    s1 <= 4'b0101;
                                    m0 <= m0 - 1;
                                    if(!m0)begin
                                        m0 <= 4'b1001;
                                        m1 <= m1 - 1;
                                        if(!m1)begin
                                            m1 <= 4'b0101;
                                            h0 <= h0 - 1;
                                            if(!h0)begin
                                                h0 <= 4'b1001;
                                                h1 <= h1 - 1;
                                                if(!h1)begin
                                                    h1 <= 4'b1001;
                                                    h1 <= h1 - 1;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                k0 <= k0 - 1;
            end
        end
    end
    
endmodule
