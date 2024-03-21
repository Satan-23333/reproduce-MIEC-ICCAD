module	div_16bit (
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );
    
    reg [16:0] a_reg; // the register to hold A and the remainder
    reg [7:0] b_reg; // the register to hold B
    integer i;

    always @(*)
    begin
        a_reg = {1'b0, A}; // initialize a_reg with A
        b_reg = B; // initialize b_reg with B
        result = 16'b0;
        odd = 16'b0;
        
        for(i = 0; i < 16; i = i+1) begin
            a_reg = {a_reg[15:0],1'b0} << 1; // shift a_reg to the left
            if (a_reg[16:9] >= b_reg) begin
                a_reg[16:9] = a_reg[16:9] - b_reg;
                result = result << 1 | 1'b1; // shift result to the left and set the LSB to 1
            end
            else begin
                result = result << 1; // just shift result to the left, the LSB remains 0
            end
        end
        odd = a_reg[15:0]; // the remaining value in a_reg is the remainder
    end
endmodule
