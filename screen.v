`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2020 12:29:25 PM
// Design Name: 
// Module Name: top_square
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
//////////////////////////////////////////////////////////////////////////////
module screen(
    input wire CLK,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire RST_BTN,
    
    
    //these three inputs control the "SSD" for each magnitude: 0-6 controls first digit, 7-13 controls second digit
    input wire [13:0] hourSeg,  
    input wire [13:0] minSeg,
    input wire [13:0] secSeg,
    input wire [20:0] milliSeg,  
    
    //this input controls the color of the digits
    input wire [1:0] SEL,
           
    output wire VGA_HS_O,       // horizontal sync output
    output wire VGA_VS_O,       // vertical sync output
    output wire [3:0] VGA_R,    // 4-bit VGA red output
    output wire [3:0] VGA_G,    // 4-bit VGA green output
    output wire [3:0] VGA_B     // 4-bit VGA blue output
    );

    wire rst = ~RST_BTN;    // reset is active low on Arty & Nexys Video

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge CLK)
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511

    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_HS_O), 
        .o_vs(VGA_VS_O), 
        .o_x(x), 
        .o_y(y)
    );

    // Wires to hold regions on FPGA
    wire [13:0] 
    
         h,  // first [6:0] and second [13:7] hour digit
         
         m,  // first [6:0] and second [13:7] minute digit
         
         s;  // first [6:0] and second [13:7] second digit
    
    wire [20:0] k;
         
    wire d0, d1, d2, d3;
         
         
    // Creating Regions on the VGA Display represented as wires (640x480)
    
    // first hours digit
    assign h[0] = ((x >= 158) & (y >= 60) & (x <= 188) & (y <= 68)) ? 1 : 0; // top
    assign h[1] = ((x >= 158) & (y >= 100) & (x <= 188) & (y <= 108)) ? 1 : 0; // middle
    assign h[2] = ((x >= 158) & (y >= 140) & (x <= 188) & (y <= 148)) ? 1 : 0; // bottom
    assign h[3] = ((x > 150) & (y > 68) & (x < 158) & (y < 100)) ? 1 : 0; // side left top
    assign h[4] = ((x > 150) & (y > 108) & (x < 158) & (y < 140)) ? 1 : 0; // side left bottom
    assign h[5] = ((x > 188) & (y > 68) & (x < 196) & (y < 100)) ? 1 : 0; // side right top
    assign h[6] = ((x > 188) & (y > 108) & (x < 196) & (y < 140)) ? 1 : 0; // side right bottom
    
    //second hours digit
    assign h[7] = ((x >= 212) & (y >= 60) & (x <= 242) & (y <= 68)) ? 1 : 0; // top
    assign h[8] = ((x >= 212) & (y >= 100) & (x <= 242) & (y <= 108)) ? 1 : 0; // middle
    assign h[9] = ((x >= 212) & (y >= 140) & (x <= 242) & (y <= 148)) ? 1 : 0; // bottom
    assign h[10] = ((x > 204) & (y > 68) & (x < 212) & (y < 100)) ? 1 : 0; // side left top
    assign h[11] = ((x > 204) & (y > 108) & (x < 212) & (y < 140)) ? 1 : 0; // side left bottom
    assign h[12] = ((x > 242) & (y > 68) & (x < 250) & (y < 100)) ? 1 : 0; // side right top
    assign h[13] = ((x > 242) & (y > 108) & (x < 250) & (y < 140)) ? 1 : 0; // side right bottom
    
    
    //first dot block
    assign d0 = ((x > 257) & (y > 90) & (x < 263) & (y < 106)) ? 1 : 0; // first top dot
    assign d1 = ((x > 257) & (y > 96) & (x < 263) & (y < 112)) ? 1 : 0; // first bottom dot
    
    
	//first minute block
	assign m[0] = ((x >= 278) & (y >= 60) & (x <= 308) & (y <= 68)) ? 1 : 0; // top
    assign m[1] = ((x >= 278) & (y >= 100) & (x <= 308) & (y <= 108)) ? 1 : 0; // middle
    assign m[2] = ((x >= 278) & (y >= 140) & (x <= 308) & (y <= 148)) ? 1 : 0; // bottom
    assign m[3] = ((x > 270) & (y > 68) & (x < 278) & (y < 100)) ? 1 : 0; // side left top
    assign m[4] = ((x > 270) & (y > 108) & (x < 278) & (y < 140)) ? 1 : 0; // side left bottom
    assign m[5] = ((x > 308) & (y > 68) & (x < 316) & (y < 100)) ? 1 : 0; // side right top
    assign m[6] = ((x > 308) & (y > 108) & (x < 316) & (y < 140)) ? 1 : 0; // side right bottom
    
    //second minute block
    assign m[7] = ((x >= 332) & (y >= 60) & (x <= 362) & (y <= 68)) ? 1 : 0; // top
    assign m[8] = ((x >= 332) & (y >= 100) & (x <= 362) & (y <= 108)) ? 1 : 0; // middle
    assign m[9] = ((x >= 332) & (y >= 140) & (x <= 362) & (y <= 148)) ? 1 : 0; // bottom
    assign m[10] = ((x > 324) & (y > 68) & (x < 332) & (y < 100)) ? 1 : 0; // side left top
    assign m[11] = ((x > 324) & (y > 108) & (x < 332) & (y < 140)) ? 1 : 0; // side left bottom
    assign m[12] = ((x > 362) & (y > 68) & (x < 370) & (y < 100)) ? 1 : 0; // side right top
    assign m[13] = ((x > 362) & (y > 108) & (x < 370) & (y < 140)) ? 1 : 0; // side right bottom
    
    
    //second dot block
    assign d2 = ((x > 377) & (y > 90) & (x < 383) & (y < 106)) ? 1 : 0; // second top dot
    assign d3 = ((x > 377) & (y > 96) & (x < 383) & (y < 112)) ? 1 : 0; // second bottom dot
    
    
    //first second block
    assign s[0] = ((x >= 398) & (y >= 60) & (x <= 428) & (y <= 68)) ? 1 : 0; // top
    assign s[1] = ((x >= 398) & (y >= 100) & (x <= 428) & (y <= 108)) ? 1 : 0; // middle
    assign s[2] = ((x >= 398) & (y >= 140) & (x <= 428) & (y <= 148)) ? 1 : 0; // bottom
    assign s[3] = ((x > 390) & (y > 68) & (x < 398) & (y < 100)) ? 1 : 0; // side left top
    assign s[4] = ((x > 390) & (y > 108) & (x < 398) & (y < 140)) ? 1 : 0; // side left bottom
    assign s[5] = ((x > 428) & (y > 68) & (x < 436) & (y < 100)) ? 1 : 0; // side right top
    assign s[6] = ((x > 428) & (y > 108) & (x < 436) & (y < 140)) ? 1 : 0; // side right bottom
    
    //second second block
    assign s[7] = ((x >= 452) & (y >= 60) & (x <= 482) & (y <= 68)) ? 1 : 0; // top
    assign s[8] = ((x >= 452) & (y >= 100) & (x <= 482) & (y <= 108)) ? 1 : 0; // middle
    assign s[9] = ((x >= 452) & (y >= 140) & (x <= 482) & (y <= 148)) ? 1 : 0; // bottom
    assign s[10] = ((x > 444) & (y > 68) & (x < 452) & (y < 100)) ? 1 : 0; // side left top
    assign s[11] = ((x > 444) & (y > 108) & (x < 452) & (y < 140)) ? 1 : 0; // side left bottom
    assign s[12] = ((x > 482) & (y > 68) & (x < 490) & (y < 100)) ? 1 : 0; // side right top
    assign s[13] = ((x > 482) & (y > 108) & (x < 490) & (y < 140)) ? 1 : 0; // side right bottom
    
    //first millisecond block
    assign k[0] = ((x >= 251) & (y >= 170) & (x <= 281) & (y <= 178)) ? 1 : 0; // top
    assign k[1] = ((x >= 251) & (y >= 208) & (x <= 281) & (y <= 216)) ? 1 : 0; // middle
    assign k[2] = ((x >= 251) & (y >= 246) & (x <= 281) & (y <= 254)) ? 1 : 0; // bottom
    assign k[3] = ((x > 243) & (y > 178) & (x < 251) & (y < 208)) ? 1 : 0; // side left top
    assign k[4] = ((x > 243) & (y > 216) & (x < 251) & (y < 246)) ? 1 : 0; // side left bottom
    assign k[5] = ((x > 281) & (y > 178) & (x < 289) & (y < 208)) ? 1 : 0; // side right top
    assign k[6] = ((x > 281) & (y > 216) & (x < 289) & (y < 246)) ? 1 : 0; // side right bottom
    
    
    //second millisecond block
    assign k[7] = ((x >= 305) & (y >= 170) & (x <= 335) & (y <= 178)) ? 1 : 0; // top
    assign k[8] = ((x >= 305) & (y >= 208) & (x <= 335) & (y <= 216)) ? 1 : 0; // middle
    assign k[9] = ((x >= 305) & (y >= 246) & (x <= 335) & (y <= 254)) ? 1 : 0; // bottom
    assign k[10] = ((x > 297) & (y > 178) & (x < 305) & (y < 208)) ? 1 : 0; // side left top
    assign k[11] = ((x > 297) & (y > 216) & (x < 305) & (y < 246)) ? 1 : 0; // side left bottom
    assign k[12] = ((x > 335) & (y > 178) & (x < 343) & (y < 208)) ? 1 : 0; // side right top
    assign k[13] = ((x > 335) & (y > 216) & (x < 343) & (y < 246)) ? 1 : 0; // side right bottom
    
    
    //third millisecond block
    assign k[14] = ((x >= 359) & (y >= 170) & (x <= 389) & (y <= 178)) ? 1 : 0; // top
    assign k[15] = ((x >= 359) & (y >= 208) & (x <= 389) & (y <= 216)) ? 1 : 0; // middle
    assign k[16] = ((x >= 359) & (y >= 246) & (x <= 389) & (y <= 254)) ? 1 : 0; // bottom
    assign k[17] = ((x > 351) & (y > 178) & (x < 359) & (y < 208)) ? 1 : 0; // side left top
    assign k[18] = ((x > 351) & (y > 216) & (x < 359) & (y < 246)) ? 1 : 0; // side left bottom
    assign k[19] = ((x > 389) & (y > 178) & (x < 397) & (y < 208)) ? 1 : 0; // side right top
    assign k[20] = ((x > 389) & (y > 216) & (x < 397) & (y < 246)) ? 1 : 0; // side right bottom
    
    
    reg red, green, blue;
    reg ON;
    
    assign VGA_R[3] = red;
    assign VGA_G[3] = green;
    assign VGA_B[3] = blue;
    
    
    always @ (*) begin
    
        ON = 0;
        
        red = 0;
        green = 0;
        blue = 0;
        
        if(h[0] & hourSeg[0])
            ON = 1;
        if(h[1] & hourSeg[1])
            ON = 1;
        if(h[2] & hourSeg[2])
            ON = 1;
        if(h[3] & hourSeg[3])
            ON = 1;
        if(h[4] & hourSeg[4])
            ON = 1;
        if(h[5] & hourSeg[5])
            ON = 1;
        if(h[6] & hourSeg[6])
            ON = 1;
        if(h[7] & hourSeg[7])
            ON = 1;
        if(h[8] & hourSeg[8])
            ON = 1;
        if(h[9] & hourSeg[9])
            ON = 1;
        if(h[10] & hourSeg[10])
            ON = 1;
        if(h[11] & hourSeg[11])
            ON = 1;
        if(h[12] & hourSeg[12])
            ON = 1;
        if(h[13] & hourSeg[13])
            ON = 1;
            
            
            
        if(m[0] & minSeg[0])
            ON = 1;
        if(m[1] & minSeg[1])
            ON = 1;
        if(m[2] & minSeg[2])
            ON = 1;
        if(m[3] & minSeg[3])
            ON = 1;
        if(m[4] & minSeg[4])
            ON = 1;
        if(m[5] & minSeg[5])
            ON = 1;
        if(m[6] & minSeg[6])
            ON = 1;
        if(m[7] & minSeg[7])
            ON = 1;
        if(m[8] & minSeg[8])
            ON = 1;
        if(m[9] & minSeg[9])
            ON = 1;
        if(m[10] & minSeg[10])
            ON = 1;
        if(m[11] & minSeg[11])
            ON = 1;
        if(m[12] & minSeg[12])
            ON = 1;
        if(m[13] & minSeg[13])
            ON = 1;
            
            
        if(s[0] & secSeg[0])
            ON = 1;
        if(s[1] & secSeg[1])
            ON = 1;
        if(s[2] & secSeg[2])
            ON = 1;
        if(s[3] & secSeg[3])
            ON = 1;
        if(s[4] & secSeg[4])
            ON = 1;
        if(s[5] & secSeg[5])
            ON = 1;
        if(s[6] & secSeg[6])
            ON = 1;
        if(s[7] & secSeg[7])
            ON = 1;
        if(s[8] & secSeg[8])
            ON = 1;
        if(s[9] & secSeg[9])
            ON = 1;
        if(s[10] & secSeg[10])
            ON = 1;
        if(s[11] & secSeg[11])
            ON = 1;
        if(s[12] & secSeg[12])
            ON = 1;
        if(s[13] & secSeg[13])
            ON = 1;
            
        if(k[0] & milliSeg[0])
            ON = 1;
        if(k[1] & milliSeg[1])
            ON = 1;
        if(k[2] & milliSeg[2])
            ON = 1;
        if(k[3] & milliSeg[3])
            ON = 1;
        if(k[4] & milliSeg[4])
            ON = 1;
        if(k[5] & milliSeg[5])
            ON = 1;
        if(k[6] & milliSeg[6])
            ON = 1;
        if(k[7] & milliSeg[7])
            ON = 1;
        if(k[8] & milliSeg[8])
            ON = 1;
        if(k[9] & milliSeg[9])
            ON = 1;
        if(k[10] & milliSeg[10])
            ON = 1;
        if(k[11] & milliSeg[11])
            ON = 1;
        if(k[12] & milliSeg[12])
            ON = 1;
        if(k[13] & milliSeg[13])
            ON = 1;
        if(k[14] & milliSeg[14])
            ON = 1;
        if(k[15] & milliSeg[15])
            ON = 1;
        if(k[16] & milliSeg[16])
            ON = 1;
        if(k[17] & milliSeg[17])
            ON = 1;
        if(k[18] & milliSeg[18])
            ON = 1;
        if(k[19] & milliSeg[19])
            ON = 1;
        if(k[20] & milliSeg[20])
            ON = 1;
                

        ON = ON + d0 + d1 + d2 + d3;
            
        //set color of digits
        if(ON)begin
            case(SEL)
                2'b00: begin
                            red = 1; 
                            blue = 1;
                       end
                2'b01: begin
                            red = 1; 
                            green = 1;
                       end
                2'b10: begin
                            red = 1;
                       end
                2'b11: begin
                            //red <= 1; 
                            //blue <= 1;
                            green = 1;
                       end
             endcase
         end
               
    end
    
    
endmodule

