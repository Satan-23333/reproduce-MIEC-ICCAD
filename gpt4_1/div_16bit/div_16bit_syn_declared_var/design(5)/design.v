module	div_16bit(
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);
    reg [15:0] a_reg;
    reg [7:0] b_reg; // Corrected from [8:0] to [7:0]

    integer i;

    always @(*) begin // Combines the two always blocks into one
        a_reg = A;
        b_reg = B;
        result = 16'b0; 
        odd = 16'b0;

        for(i=15; i>=0; i=i-1) begin
            odd = odd << 1; 
            odd[0] = a_reg[i]; 

            if (i >= 8 && odd[15:8] >= b_reg) begin // Corrected the if condition
                odd[15:8] = odd[15:8] - b_reg;
                result[i] = 1'b1; 
            end
        end
    end
endmodule
