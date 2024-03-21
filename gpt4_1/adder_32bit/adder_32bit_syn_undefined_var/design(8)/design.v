module	CLA_16 (input [15:0] A, B, input c0, output [15:0] S, output px, gx);
    wire [15:0] g, p, c;
    assign g = A & B;
    assign p = A ^ B;
    assign c = {c0, g[14:0]} | {p, g[14:0]} & {c0, g[14:0]};
    assign S = p ^ c[15:0];
    assign px = p[15] & c[15];
    assign gx = g[15] | p[15] & c[15];
endmodule
module	adder_32bit(input [31:0] A, B, output [31:0] S, output C32);
    wire px1,gx1,px2,gx2;
    wire c16;

    CLA_16 CLA1(
        .A(A[15:0]),
        .B(B[15:0]),
        .c0(1'b0),
        .S(S[15:0]),
        .px(px1),
        .gx(gx1)
    );

    CLA_16 CLA2(
        .A(A[31:16]),
        .B(B[31:16]),
        .c0(c16),
        .S(S[31:16]),
        .px(px2),
        .gx(gx2)
    );

    assign c16 = gx1 | px1 & 1'b1; //c0 = 1
    assign C32 = gx2 | px2 & c16;
endmodule
