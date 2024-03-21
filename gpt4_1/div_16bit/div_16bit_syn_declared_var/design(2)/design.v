module	div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [15:0] a_reg;
reg [7:0] b_reg;
reg [23:0] tmp_a;
reg [15:0] tmp_b;
integer i;

always @(A, B) begin
    a_reg = A;
    b_reg = B;
end

always @(a_reg, b_reg) begin
    tmp_a = {8'b0, a_reg};
    tmp_b = {8'b0, b_reg};
    for(i=0; i<16; i=i+1) begin
        tmp_a = tmp_a << 1;
        if (tmp_a[23:8] >= tmp_b) begin
            tmp_a[23:8] = tmp_a[23:8] - tmp_b;
            tmp_a[7] = 1;
        end
    end
    result = tmp_a[15:0];
    odd = tmp_a[23:8];
end

endmodule
