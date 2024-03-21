module	CLA_16 (input [15:0] A, B, input c0, output [15:0] S, output c16);
    wire [15:0] g, p;
    wire [16:0] c;
    assign g = A & B;
    assign p = A ^ B;
    assign c = {g[15], (g[14:0] | (p[14:0] & c[15:1]))};
    assign c[0] = c0;
    assign S = p ^ c[15:0];
    assign c16 = c[16];
endmodule
module	adder_32bit(input [31:0] A, B, output [31:0] S, output C32);
    wire c16_1, c16_2;

    CLA_16 CLA1(
        .A(A[15:0]),
        .B(B[15:0]),
        .c0(1'b0),
        .S(S[15:0]),
        .c16(c16_1)
    );

    CLA_16 CLA2(
        .A(A[31:16]),
        .B(B[31:16]),
        .c0(c16_1),
        .S(S[31:16]),
        .c16(c16_2)
    );

    assign C32 = c16_2;
endmodule
