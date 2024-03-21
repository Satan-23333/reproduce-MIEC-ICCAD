module	div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);
    reg [15:0] a_reg;
    reg [8:0] b_reg; // Increase the size to 9 bits to handle left shift operation
    integer i;

    always @(A, B) begin
        a_reg = A;
        b_reg = B;
        result = 16'b0; // Reset result and odd at the beginning of each computation
        odd = 16'b0;

        for(i=15; i>=0; i=i-1) begin
            odd = odd << 1; // Shift left the odd (remainder)
            odd[0] = a_reg[i]; // Set the least significant bit of odd with the i-th bit of a_reg
            if (odd[15:8] >= b_reg) begin
                odd[15:8] = odd[15:8] - b_reg;
                result[i] = 1'b1; // If odd >= b_reg, then set the i-th bit of result to 1
            end
        end
    end
endmodule
