module	div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);
    reg [31:0] tmp_a;
    reg [15:0] tmp_b;
    integer i;

    always @(*) begin
        tmp_a = {16'b0, A};
        tmp_b = {8'b0, B};
        result = 16'b0;
        odd = 16'b0;

        for(i = 15; i >= 0; i = i-1) begin
            if (tmp_a[31:16] >= tmp_b) begin
                tmp_a[31:16] = tmp_a[31:16] - tmp_b;
                result = result << 1;
                result[0] = 1;
            end
            else begin
                result = result << 1;
            end
            tmp_a = {tmp_a[30:0], odd[15]};
        end
        odd = tmp_a[15:0];
    end
endmodule
