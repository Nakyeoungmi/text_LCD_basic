`timescale 1ns / 1ps

module text_LCD_basic_tb;

    reg clk;
    reg rst;

    wire LCD_E;
    wire LCD_RS;
    wire LCD_RW;
    wire [7:0] LCD_DATA;
    wire [7:0] LED_out;

    text_LCD_basic uut (
        .rst(rst),
        .clk(clk),
        .LCD_E(LCD_E),
        .LCD_RS(LCD_RS),
        .LCD_RW(LCD_RW),
        .LCD_DATA(LCD_DATA),
        .LED_out(LED_out)
    );

    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    initial begin
        rst = 0;
        #200;
        rst = 1;
        #10_000_000;
        $stop;
    end

    initial begin
        $display("Time\t\tRST\tSTATE\tLED_out\tLCD_RS\tLCD_RW\tLCD_DATA");
        $monitor("%t\t%b\t%h\t%b\t%b\t%b\t%h", 
                 $time, rst, uut.state, LED_out, LCD_RS, LCD_RW, LCD_DATA);
    end

endmodule
