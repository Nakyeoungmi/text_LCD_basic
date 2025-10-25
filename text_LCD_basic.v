`timescale 1ns / 1ps

module text_LCD_basic(
    input rst, clk,
    output LCD_E, LCD_RS, LCD_RW,
    output reg [7:0] LCD_DATA,
    output reg [7:0] LED_out
);

    wire LCD_E;
    reg LCD_RS, LCD_RW;
    reg [2:0] state;
    integer cnt;

    parameter DELAY        = 3'b000,
              FUNCTION_SET = 3'b001,
              ENTRY_MODE   = 3'b010,
              DISP_ONOFF   = 3'b011,
              LINE1        = 3'b100,
              LINE2        = 3'b101,
              DELAY_T      = 3'b110,
              CLEAR_DISP   = 3'b111;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= DELAY;
            cnt <= 0;
            LED_out <= 8'b0000_0000;
        end 
        else begin
            case (state)
                DELAY: begin
                    LED_out <= 8'b1000_0000;
                    if (cnt >= 70) begin
                        cnt <= 0;
                        state <= FUNCTION_SET;
                    end else cnt <= cnt + 1;
                end

                FUNCTION_SET: begin
                    LED_out <= 8'b0100_0000;
                    if (cnt >= 30) begin
                        cnt <= 0;
                        state <= DISP_ONOFF;
                    end else cnt <= cnt + 1;
                end

                DISP_ONOFF: begin
                    LED_out <= 8'b0010_0000;
                    if (cnt >= 30) begin
                        cnt <= 0;
                        state <= ENTRY_MODE;
                    end else cnt <= cnt + 1;
                end

                ENTRY_MODE: begin
                    LED_out <= 8'b0001_0000;
                    if (cnt >= 30) begin
                        cnt <= 0;
                        state <= LINE1;
                    end else cnt <= cnt + 1;
                end

                LINE1: begin
                    LED_out <= 8'b0000_1000;
                    if (cnt >= 17) begin
                        cnt <= 0;
                        state <= LINE2;
                    end else cnt <= cnt + 1;
                end

                LINE2: begin
                    LED_out <= 8'b0000_0100;
                    if (cnt >= 17) begin
                        cnt <= 0;
                        state <= DELAY_T;
                    end else cnt <= cnt + 1;
                end

                DELAY_T: begin
                    LED_out <= 8'b0000_0010;
                    if (cnt >= 5) begin
                        cnt <= 0;
                        state <= CLEAR_DISP;
                    end else cnt <= cnt + 1;
                end

                CLEAR_DISP: begin
                    LED_out <= 8'b0000_0001;
                    if (cnt >= 5) begin
                        cnt <= 0;
                        state <= LINE1;
                    end else cnt <= cnt + 1;
                end

                default: begin
                    state <= DELAY;
                    cnt <= 0;
                end
            endcase
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst)
            {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_1_00000000;
        else begin
            case (state)
                FUNCTION_SET :
                    {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0011_1000;
                DISP_ONOFF :
                    {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1100;
                ENTRY_MODE :
                    {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0110;

                LINE1: begin
                    case (cnt)
                        0  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_1000_0000;
                        1  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000; 
                        2  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1000;
                        3  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_0101;
                        4  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1100;
                        5  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1100;
                        6  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1111;
                        7  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000;
                        8  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0101_0111;
                        9  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1111;
                        10 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0101_0101;
                        11 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1100;
                        12 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_0100;
                        13 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0001;
                        default : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000;
                    endcase
                end

                LINE2: begin
                    case (cnt)
                        0  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_1100_0000;
                        1  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0010; //2
                        2  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0000; //0
                        3  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0010; //2
                        4  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0100; //4
                        5  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0100; //4
                        6  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0100; //4
                        7  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0000; //0
                        8  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0000; //0
                        9  : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0100; //4
                        10 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0110; //6
                        11 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000;
                        12 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1110;
                        13 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1011;
                        14 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1101;
                        default : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000;
                    endcase
                end

                DELAY_T :
                    {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0010;
                CLEAR_DISP :
                    {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0001;
                default :
                    {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_1_0000_0000;
            endcase
        end
    end

    assign LCD_E = clk;

endmodule
