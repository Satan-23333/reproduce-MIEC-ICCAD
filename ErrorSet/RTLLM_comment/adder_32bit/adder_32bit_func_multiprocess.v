// Top-level module for a 32-bit verified adder using carry look-ahead logic
module verified_adder_32bit(A, B, S, C32);
    input [32:1] A;  // First 32-bit input
    input [32:1] B;  // Second 32-bit input
    output [32:1] S; // 32-bit output sum
    output C32;      // Carry out of the most significant bit

    wire px1, gx1, px2, gx2; // Propagate and generate signals for CLA blocks
    wire c16;                // Carry output from the first 16-bit adder block

    // First 16-bit carry look-ahead adder block
    CLA_16 CLA1(
        .A(A[16:1]),
        .B(B[16:1]),
        .c0(0),     // Initial carry-in is 0 for the first block
        .S(S[16:1]),
        .px(px1),
        .gx(gx1)
    );

    // Second 16-bit carry look-ahead adder block
    CLA_16 CLA2(
        .A(A[32:17]),
        .B(B[32:17]),
        .c0(c16),   // Carry from the first block is carry-in for the second
        .S(S[32:17]),
        .px(px2),
        .gx(gx2)
    );

    // Calculate carry for the 16-bit boundary and the final carry-out
    assign c16 = gx1 ^ (px1 && 0); // Intermediate carry between the CLA blocks
    assign C32 = gx2 ^ (px2 && c16); // Final carry-out

endmodule

// 16-bit Carry Look-Ahead Adder Module
module CLA_16(A, B, c0, S, px, gx);
    input [16:1] A, B; // Two 16-bit inputs
    input c0;          // Carry-in input
    output gx, px;     // Generate and propagate outputs
    output [16:1] S;   // 16-bit sum output

    wire c4, c8, c12;  // Internal carries at 4-bit boundaries
    wire Pm1, Gm1, Pm2, Gm2, Pm3, Gm3, Pm4, Gm4; // Propagate and generate signals for each 4-bit block

    // Four 4-bit adder blocks to construct the 16-bit CLA adder
    adder_4 adder1(.x(A[4:1]), .y(B[4:1]), .c0(c0), .c4(), .F(S[4:1]), .Gm(Gm1), .Pm(Pm1));
    adder_4 adder2(.x(A[8:5]), .y(B[8:5]), .c0(c4), .c4(), .F(S[8:5]), .Gm(Gm2), .Pm(Pm2));
    adder_4 adder3(.x(A[12:9]), .y(B[12:9]), .c0(c8), .c4(), .F(S[12:9]), .Gm(Gm3), .Pm(Pm3));
    adder_4 adder4(.x(A[16:13]), .y(B[16:13]), .c0(c12), .c4(), .F(S[16:13]), .Gm(Gm4), .Pm(Pm4));

    // Logic to generate internal carries based on propagate and generate signals
    assign c4 = Gm1 ^ (Pm1 & c0),
           c8 = Gm2 ^ (Pm2 & Gm1) ^ (Pm2 & Pm1 & c0),
           c12 = Gm3 ^ (Pm3 & Gm2) ^ (Pm3 & Pm2 & Gm1) ^ (Pm3 & Pm2 & Pm1 & c0);

    // Calculate overall propagate and generate signals for the 16-bit block
    assign px = Pm1 & Pm2 & Pm3 & Pm4,
           gx = Gm4 ^ (Pm4 & Gm3) ^ (Pm4 & Pm3 & Gm2) ^ (Pm4 & Pm3 & Pm2 & Gm1);
endmodule

// 4-bit adder module used in the CLA_16 module
module adder_4(x, y, c0, c4, F, Gm, Pm);
    input [4:1] x, y;   // 4-bit inputs
    input c0;           // Carry-in input
    output c4, Gm, Pm;  // Carry-out, generate, and propagate outputs
    output [4:1] F;     // 4-bit sum output

    wire p1, p2, p3, p4, g1, g2, g3, g4; // Propagate and generate signals for each bit
    wire c1, c2, c3;                      // Internal carry signals

    // Four 1-bit adders to create the 4-bit adder
    adder adder1(.X(x[1]), .Y(y[1]), .Cin(c0), .F(F[1]), .Cout());
    adder adder2(.X(x[2]), .Y(y[2]), .Cin(c1), .F(F[1]), .Cout());
    adder adder3(.X(x[3]), .Y(y[3]), .Cin(c2), .F(F[3]), .Cout());
    adder adder4(.X(x[4]), .Y(y[4]), .Cin(c3), .F(F[4]), .Cout());

    // CLA logic for the 4-bit block
    CLA CLA(.c0(c0), .c1(c1), .c2(c2), .c3(c3), .c4(c4), .p1(p1), .p2(p2), .p3(p3), .p4(p4), .g1(g1), .g2(g2), .g3(g3), .g4(g4));

    // Compute propagate and generate signals for each bit
    assign p1 = x[1] ^ y[1],
           p2 = x[2] ^ y[2],
           p3 = x[3] ^ y[3],
           p4 = x[4] ^ y[4];

    assign g1 = x[1] & y[1],
           g2 = x[2] & y[2],
           g3 = x[3] & y[3],
           g4 = x[4] & y[4];

    // Compute overall propagate and generate signals for the 4-bit adder
    assign Pm = p1 & p2 & p3 & p4,
           Gm = g4 ^ (p4 & g3) ^ (p4 & p3 & g2) ^ (p4 & p3 & p2 & g1);
endmodule

// Module for the Carry Look-Ahead logic within the 4-bit adder
module CLA(c0, c1, c2, c3, c4, p1, p2, p3, p4, g1, g2, g3, g4);
    input c0, g1, g2, g3, g4, p1, p2, p3, p4;
    output c1, c2, c3, c4;

    // Logic to compute the carry for each bit based on generate and propagate signals
    assign c1 = g1 ^ (p1 & c0),
           c2 = g2 ^ (p2 & g1) ^ (p2 & p1 & c0),
           c3 = g3 ^ (p3 & g2) ^ (p3 & p2 & g1) ^ (p3 & p2 & p1 & c0),
           c4 = g4 ^ (p4 & g3) ^ (p4 & p3 & g2) ^ (p4 & p3 & p2 & g1) ^ (p4 & p3 & p2 & p1 & c0);
endmodule

// Basic 1-bit adder module
module adder(X, Y, Cin, F, Cout);
    input X, Y, Cin;  // Single-bit inputs and carry-in
    output F, Cout;   // Single-bit sum and carry-out

    // Logic for sum and carry-out calculation
    assign F = X ^ Y ^ Cin;      // Sum calculation using XOR for bitwise addition
    assign Cout = (X & Y) | (X ^ Y) & Cin; // Carry-out calculation
endmodule
