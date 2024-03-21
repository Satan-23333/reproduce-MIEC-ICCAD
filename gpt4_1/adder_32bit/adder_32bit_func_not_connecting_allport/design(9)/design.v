module	CLA_16(
  input [15:0] A,
  input [15:0] B,
  input C_in,
  output [15:0] S,
  output C_out
);
  wire [16:0] G, P, C;
  assign G = {1'b0,A} & {1'b0,B};  // Generate
  assign P = {1'b0,A} ^ {1'b0,B};  // Propagate

  // Carry calculation
  assign C[0] = G[0] | (P[0] & C_in);
  genvar i;
  generate 
    for (i=1; i<=16; i=i+1) 
    begin : Carry_Generate
      assign C[i] = G[i] | (P[i] & C[i-1]);
    end
  endgenerate

  // Sum calculation
  assign S = P[15:0] ^ C[15:0];
  assign C_out = C[16];
endmodule
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
