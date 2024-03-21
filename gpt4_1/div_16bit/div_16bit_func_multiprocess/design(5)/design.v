module	div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

reg [31:0] tmp_a;
reg [31:0] tmp_b;
integer i;

always@(A, B) begin
    tmp_a = {16'b0, A};
    tmp_b = {B, 16'b0};
    result = 16'b0;
    for(i = 16; i > 0; i = i-1) begin
        tmp_b = tmp_b << 1;
        if (tmp_a >= tmp_b) begin
            tmp_a = tmp_a - tmp_b;
            result = result << 1;
            result[0] = 1;
        end
        else begin
            result = result << 1;
        end
    end
    odd = tmp_a[15:0];
end

endmodule
