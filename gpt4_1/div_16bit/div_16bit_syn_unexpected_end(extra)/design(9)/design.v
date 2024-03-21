module	div_16bit (
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );
    
    reg [16:0] a_reg; 
    reg [8:0] b_reg; 
    integer i;

    always @(*)
    begin
        a_reg = {1'b0, A}; 
        b_reg = {1'b0, B}; 
        result = 16'b0;
        odd = 16'b0;

        for(i = 0; i < 16; i = i+1) begin
            a_reg = a_reg << 1;
            if (a_reg[16:8] >= b_reg) begin
                a_reg[16:8] = a_reg[16:8] - b_reg;
                result = (result << 1) | 1'b1; 
            end
            else begin
                result = result << 1;
            end
        end
        odd = a_reg[15:0];
    end
endmodule
