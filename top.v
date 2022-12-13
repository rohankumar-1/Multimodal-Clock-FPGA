`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2022 01:24:32 PM
// Design Name: 
// Module Name: top
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


module top(
    input wire CLK,
    
    input wire RST_BTN, //reset screen
    input wire BTN_clock_r, //reset count
    
    input wire BTN_mode,   // mode toggle
    input wire BTN_edit,   // edit only for clock
    
    input wire BTN_inc_h,  //increment hour
    input wire BTN_inc_m,  //increment minute
    
    input wire SWT_t,  //switch for timer
    input wire SWT_s,  //switch for stopwatch
    
    output wire vga_HS_O,       // horizontal sync output
    output wire vga_VS_O,       // vertical sync output
    output wire [3:0] vga_R,    // 4-bit VGA red output
    output wire [3:0] vga_G,    // 4-bit VGA green output
    output wire [3:0] vga_B     // 4-bit VGA blue output
    );
    
    //selecting mode using BTN_0
    wire MODE_switch;
    reg [1:0] MODE;
    
    //selecting edit mode in 12/24h clock and timer
    wire EDIT_BTN;
    reg EDIT = 0;
    
    wire RST_COUNT = ~BTN_clock_r;
    
    wire inc_h, inc_m;
    
    //debouncing buttons
    debouncer db1(.clk(CLK), .reset(RST_COUNT), .button_in(BTN_edit), .button_out(ENABLE_BTN));
    debouncer db2(.clk(CLK), .reset(RST_COUNT), .button_in(BTN_mode), .button_out(MODE_switch));
    debouncer db3(.clk(CLK), .reset(RST_COUNT), .button_in(BTN_inc_h), .button_out(inc_h));
    debouncer db4(.clk(CLK), .reset(RST_COUNT), .button_in(BTN_inc_m), .button_out(inc_m));
    
    
    
    
    always@(posedge ENABLE_BTN)begin
        EDIT = ~EDIT;
    end
    
    
    always@(posedge MODE_switch)begin
        if(MODE==2'b11)begin
            MODE <= 2'b00;
        end else begin
            MODE = MODE + 1'b1;
        end
    end    
    
    //clock divider
    wire clk_1kHz;
    clock_divider_1kHz clkdiv(.clk_i(CLK), .clk_o(clk_1kHz));
    
    //12h clock
    wire [3:0] k0_12, k1_12, k2_12, s0_12, s1_12, m0_12, m1_12, h0_12, h1_12;
    hr_12_clk h12(.clk_1kHz(clk_1kHz),.resetn(RST_COUNT), .edit(EDIT), .BTN_inc_h(inc_h), .BTN_inc_m(inc_m), .mode(MODE),
                  .k0(k0_12), .k1(k1_12), .k2(k2_12), .s0(s0_12), .s1(s1_12), .m0(m0_12), .m1(m1_12), .h0(h0_12), .h1(h1_12)); 
                  
    //24h clock
    wire [3:0] k0_24, k1_24, k2_24, s0_24, s1_24, m0_24, m1_24, h0_24, h1_24;
    hr_24_clk h24(.clk_1kHz(clk_1kHz),.resetn(RST_COUNT), .edit(EDIT), .BTN_inc_h(inc_h), .BTN_inc_m(inc_m), .mode(MODE),
                  .k0(k0_24), .k1(k1_24), .k2(k2_24), .s0(s0_24), .s1(s1_24), .m0(m0_24), .m1(m1_24), .h0(h0_24), .h1(h1_24)); 
                  
    //timer
    wire [3:0] k0_t, k1_t, k2_t, s0_t, s1_t, m0_t, m1_t, h0_t, h1_t;
    timer t(.clock_1kHz(clk_1kHz),.resetn(RST_COUNT), .enable_swt(SWT_t), .BTN_inc_h(inc_h), .BTN_inc_m(inc_m),
                  .k0(k0_t), .k1(k1_t), .k2(k2_t), .s0(s0_t), .s1(s1_t), .m0(m0_t), .m1(m1_t), .h0(h0_t), .h1(h1_t)); 
                  
    //stopwatch
    wire [3:0] k0_s, k1_s, k2_s, s0_s, s1_s, m0_s, m1_s, h0_s, h1_s;
    stopwatch s(.clock_1kHz(clk_1kHz),.resetn(RST_COUNT), .enable_swt(SWT_s),
                  .k0(k0_s), .k1(k1_s), .k2(k2_s), .s0(s0_s), .s1(s1_s), .m0(m0_s), .m1(m1_s), .h0(h0_s), .h1(h1_s));
                  
    
    reg [3:0] k0, k1, k2, s0, s1, m0, m1, h0, h1;  //final outputs to go to BCD converter
                  
                  
    always@(posedge CLK)begin
        case(MODE)
            2'b00:  begin
                        k0 <= k0_12; k1 <= k1_12; k2 <= k2_12;
                        s0 <= s0_12; s1 <= s1_12;
                        m0 <= m0_12; m1 <= m1_12;
                        h0 <= h0_12; h1 <= h1_12;
                    end
            2'b01:  begin
                        k0 <= k0_24; k1 <= k1_24; k2 <= k2_24;
                        s0 <= s0_24; s1 <= s1_24;
                        m0 <= m0_24; m1 <= m1_24;
                        h0 <= h0_24; h1 <= h1_24;
                    end
            2'b10:  begin
                        k0 <= k0_t; k1 <= k1_t; k2 <= k2_t;
                        s0 <= s0_t; s1 <= s1_t;
                        m0 <= m0_t; m1 <= m1_t;
                        h0 <= h0_t; h1 <= h1_t;
                    end
            2'b11:  begin
                        k0 <= k0_s; k1 <= k1_s; k2 <= k2_s;
                        s0 <= s0_s; s1 <= s1_s;
                        m0 <= m0_s; m1 <= m1_s;
                        h0 <= h0_s; h1 <= h1_s;
                    end
        endcase
    end
    
    //output from decoder
    wire [13:0] hours, minutes, seconds; 
    wire [20:0] milliseconds;
    bcd_to_number decoder(.hours0(h0), .hours1(h1), .minutes0(m0), .minutes1(m1), .seconds0(s0), .seconds1(s1), .milliseconds0(k0), .milliseconds1(k1), .milliseconds2(k2),
                          .h(hours), .m(minutes), .s(seconds), .k(milliseconds));
                          
    screen scr(.CLK(CLK), .RST_BTN(RST_BTN), .hourSeg(hours), .minSeg(minutes), .secSeg(seconds), .milliSeg(milliseconds), .SEL(MODE), 
               .VGA_HS_O(vga_HS_O), .VGA_VS_O(vga_VS_O), .VGA_R(vga_R), .VGA_G(vga_G), .VGA_B(vga_B));
    
endmodule
