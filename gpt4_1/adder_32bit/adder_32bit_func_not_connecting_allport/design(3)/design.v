module	adder_32bit(A,B,S,C32);
     input [31:0] A;
     input [31:0] B;
     output [31:0] S;
     output C32;

     wire [15:0] px1,gx1,px2,gx2;
     wire c16;

  CLA_16 CLA1(
      .A(A[15:0]),
        .B(B[15:0]),
        .C_in(1'b0),
        .S(S[15:0]),
        .P_out(px1),
        .G_out(gx1)
    );

  CLA_16 CLA2(
        .A(A[31:16]),
          .B(B[31:16]),
          .C_in(c16),
          .S(S[31:16]),
          .P_out(px2),
          .G_out(gx2)
    );

  assign c16 = gx1 | (px1 & 1'b0); //C0 = 0
  assign C32 = gx2 | (px2 & c16);
endmodule
