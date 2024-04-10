module adder_8bit(
    input [7:0] a, b,  // Two 8-bit inputs for the adder
    input cin,         // Carry input for cascading adders or extended arithmetic operations
    output [7:0] sum,  // 8-bit output representing the sum of the inputs
    output cout        // Carry output for overflow or cascading into further adder stages
);

    // Internal carry wire to connect the carry between full adder stages
    wire [8:0] c;

    // Instantiation of the full adder modules to perform bit-wise addition
    // Each full adder adds two bits and a carry, outputting a sum bit and a carry
    full_adder FA0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c[0]));
    full_adder FA1 (.a(a[1]), .b(b[1]), .cin(c[0]), .sum(sum[1]), .cout(c[1]));
    full_adder FA2 (.a(a[2]), .b(b[2]), .cin(c[1]), .sum(sum[2]), .cout(c[2]));
    full_adder FA3 (.a(a[3]), .b(b[3]), .cin(c[2]), .sum(sum[3]), .cout(c[3]));
    full_adder FA4 (.a(a[4]), .b(b[4]), .cin(c[3]), .sum(sum[4]), .cout(c[4]));
    full_adder FA5 (.a(a[5]), .b(b[5]), .cin(c[4]), .sum(sum[5]), .cout(c[5]));
    full_adder FA6 (.a(a[6]), .b(b[6]), .cin(c[5]), .sum(sum[6]), .cout(c[6]))
    full_adder FA7 (.a(a[7]), .b(b[7]), .cin(c[6]), .sum(sum[7]), .cout(c[7]));

    // The final carry-out is taken from the last full adder stage
    assign cout = c[7];

endmodule

module full_adder (input a, b, cin, output sum, cout);
    assign {cout, sum} = a + b + cin;
endmodule
