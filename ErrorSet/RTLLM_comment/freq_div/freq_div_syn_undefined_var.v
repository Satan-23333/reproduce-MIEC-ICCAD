// Module definition for a frequency divider.
// This module takes an input clock (CLK_in) and a reset signal (RST),
// and outputs three divided clock signals (CLK_50, CLK_10, CLK_1).
module freq_div (CLK_in, CLK_50, CLK_10, CLK_1, RST);

    // Input and Output declarations
    input CLK_in;  // Input clock signal
    input RST;     // Reset signal, active high
    output reg CLK_50; // Output clock divided by 2
    output reg CLK_10; // Output clock divided by 10
    output reg CLK_1;  // Output clock divided by 100

    // Internal counters for clock division
    reg [3:0] cnt_10;  // 4-bit counter for CLK_10 division
    reg [6:0] cnt_100; // 7-bit counter for CLK_1 division

    // CLK_50 generation: Toggle every clock cycle to divide by 2
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset CLK_50 to 0 on reset
            CLK_50 <= 1'b0;
        end else begin
            // Toggle CLK_50 every clock cycle
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation: Divide by 10 using cnt_10
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset CLK_10 and cnt_10 on reset
            CLK_10 <= 1'b0;
            cnt_10 <= 0;
        end else if (cnt_10 == 4) begin
            // Toggle CLK_10 and reset counter when it reaches 4
            CLK_10 <= ~CLK_10;
            cnt_10 <= 0;
        end else begin
            // Increment cnt_10 otherwise
            cnt10 <= cnt_10 + 1;
        end
    end

    // CLK_1 generation: Divide by 100 using cnt_100
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset CLK_1 and cnt_100 on reset
            CLK_1 <= 1'b0;
            cnt_100 <= 0;
        end else if (cnt_100 == 49) begin
            // Toggle CLK_1 and reset counter when it reaches 49
            CLK_1 <= ~CLK_1;
            cnt_100 <= 0;
        end else begin
            // Increment cnt_100 otherwise
            cnt_100 <= cnt_100 + 1;
        end
    end

endmodule