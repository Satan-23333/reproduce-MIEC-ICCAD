module	adder_32bit(A,B,S,C32);
    input [31:0] A;
    input [31:0] B;
    output reg [31:0] S;
    output reg C32;

    wire [31:0] carry;
    genvar i;

    assign carry[0] = 1'b0;
    for(i = 0; i < 32; i=i+1) begin
        assign S[i] = A[i] ^ B[i] ^ carry[i];
        assign carry[i+1] = (A[i] & B[i]) | (carry[i] & (A[i] ^ B[i]));
    end

    assign C32 = carry[32];

endmodule
