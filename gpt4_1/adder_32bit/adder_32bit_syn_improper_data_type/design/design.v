module	CLA_16 (input [15:0] A, input [15:0] B, input c0, output [15:0] S, output gx, output px);
    wire [15:0] G, P, C;
    genvar i;
    generate
        for (i = 0; i < 16; i=i+1) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] ^ B[i];
            if (i == 0)
                assign C[i] = G[i] | (P[i] & c0);
            else
                assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate
    assign S = P ^ C;
    assign gx = G[15];
    assign px = P[15] & C[14];
endmodule
module	adder_32bit(input [31:0] A, input [31:0] B, output [31:0] S, output C32);
    wire px1, gx1, px2, gx2, c16;

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
        .c0(gx1 | (px1 & 1'b1)),
        .S(S[31:16]),
        .px(px2),
        .gx(gx2)
    );

    assign C32 = gx2 | (px2 & (gx1 | (px1 & 1'b1)));
endmodule
