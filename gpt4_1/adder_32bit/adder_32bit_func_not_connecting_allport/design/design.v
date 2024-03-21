module	adder_32bit(
  input [31:0] A,
  input [31:0] B,
  output [31:0] S,
  output C32
);
  wire c16;

  CLA_16 CLA1(
    .A(A[15:0]),
    .B(B[15:0]),
    .C_in(1'b0),
    .S(S[15:0]),
    .C_out(c16)
  );

  CLA_16 CLA2(
    .A(A[31:16]),
    .B(B[31:16]),
    .C_in(c16),
    .S(S[31:16]),
    .C_out(C32)
  );
endmodule
