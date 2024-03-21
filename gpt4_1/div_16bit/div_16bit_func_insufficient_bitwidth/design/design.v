module	div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );

integer i;
reg [15:0] dividend;
reg [7:0] divisor;
reg [15:0] remainder;
reg [15:0] quotient;

always @(*) begin
    dividend = A;
    divisor = B;
    remainder = 0;
    quotient = 0;
    for(i = 15; i >= 0; i = i - 1) begin
        remainder = remainder << 1;
        remainder[0] = dividend[i];
        if (remainder >= divisor) begin
            remainder = remainder - divisor;
            quotient[i] = 1;
        end
    end
    result = quotient;
    odd = remainder;
end
endmodule
