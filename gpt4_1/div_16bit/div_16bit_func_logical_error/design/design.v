module	div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
);

reg [15:0] a_reg;
reg [15:0] b_reg;
reg [31:0] tmp_a;
reg [15:0] quotient;
reg [15:0] remainder;
integer i;

always @(*) begin
    a_reg = A;
    b_reg = B;
    tmp_a = {16'b0, a_reg};
    quotient = 16'b0;
    remainder = 16'b0;
    for(i = 15; i >= 0; i = i-1) begin
        remainder = remainder << 1;
        remainder[0] = tmp_a[i];
        if (remainder >= b_reg) begin
            remainder = remainder - b_reg;
            quotient[i] = 1'b1;
        end
    end
end

assign odd = remainder;
assign result = quotient;

endmodule
