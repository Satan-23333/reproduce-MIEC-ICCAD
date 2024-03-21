module	CLA_16 (
    input [15:0] A, B, 
    input c0, 
    output [15:0] S, 
    output c16
);
    wire [15:0] g, p, c;
    genvar i;

    assign g = A & B;  // Generate
    assign p = A ^ B;  // Propagate

    // Carry calculation
    assign c[0] = c0;
    for (i=0; i<15; i=i+1)
        assign c[i+1] = g[i] | (p[i] & c[i]);

    assign S = p ^ c[15:0]; // Sum
    assign c16 = c[15];     // Carry out
endmodule
