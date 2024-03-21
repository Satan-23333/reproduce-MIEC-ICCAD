module	div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);
    reg [15:0] a_reg;
    reg [7:0] b_reg;
    integer i;

    always @(*) begin
        a_reg = A;
        b_reg = B;
        result = 16'b0;
        odd = a_reg;

        for(i=15; i>=8; i=i-1) begin
            if (odd[15:8] >= b_reg) begin
                odd[15:8] = odd[15:8] - b_reg;
                result[i] = 1'b1;
            end
            odd = odd << 1;
            odd[0] = a_reg[i-8];
        end
    end
endmodule
