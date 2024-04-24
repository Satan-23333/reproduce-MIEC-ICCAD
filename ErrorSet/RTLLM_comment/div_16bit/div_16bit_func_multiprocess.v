// Module definition for a 16-bit divider
module div_16bit(
    input wire [15:0] A,       // 16-bit dividend input
    input wire [7:0] B,        // 8-bit divisor input
    output wire [15:0] result, // 16-bit quotient output
    output wire [15:0] odd     // 16-bit remainder output
);

// Registers for operands, extended for calculation
reg [15:0] a_reg;      // Register to hold the dividend
reg [15:0] b_reg;      // Register to hold the divisor
reg [31:0] tmp_a;      // Temporary register for dividend in calculation
reg [31:0] tmp_b;      // Temporary register for divisor in calculation
integer i;             // Loop counter for division algorithm

// Assign input values to internal registers
always@(*) begin
    tmp_a = A;
    tmp_b = B;
end

// Division algorithm implemented in combinational logic
always@(*) begin
    tmp_a = {16'b0, a_reg}; // Extend dividend to 32 bits for the calculation
    tmp_b = {b_reg, 16'b0}; // Align divisor to the high order for subtraction

    // Perform division through repeated subtraction and shifting
    for(i = 0; i < 16; i = i + 1) begin
        tmp_a = tmp_a << 1; // Left shift dividend for next bit of quotient

        // Subtract divisor from the shifted dividend if it is greater or equal
        if (tmp_a >= tmp_b) begin
            tmp_a = tmp_a - tmp_b + 1;
        end
    end
end

// Assign outputs: high part for remainder, low part for quotient
assign odd = tmp_a[31:16];   // Upper 16 bits for the remainder
assign result = tmp_a[15:0]; // Lower 16 bits for the quotient

endmodule
