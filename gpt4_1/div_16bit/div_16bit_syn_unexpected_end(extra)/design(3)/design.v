module	div_16bit (
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
    );
    
    reg [15:0] a_reg;
    reg [8:0] b_reg;
    reg [17:0] tmp_a;
    reg [17:0] tmp_b;
    integer i;

    always@(*) begin
        a_reg = A;
        b_reg = B;
        result = 16'b0;
        tmp_a = {8'b0, a_reg};
        tmp_b = {8'b0, b_reg};

        for(i = 0; i < 16; i = i+1) begin
            tmp_a = tmp_a << 1;
            if (tmp_a[17:10] >= tmp_b) begin
                tmp_a[17:10] = tmp_a[17:10] - tmp_b;
                result = result << 1 | 1'b1;
            end
            else begin
                result = result << 1;
            end
        end
        odd = tmp_a[15:0];
    end
endmodule
