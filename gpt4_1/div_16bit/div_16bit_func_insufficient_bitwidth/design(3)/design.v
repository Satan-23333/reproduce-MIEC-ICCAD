module	div_16bit(
    input wire [15:0] A,
    input wire [7:0] B,
    output wire [15:0] result,
    output wire [15:0] odd
    );

reg [15:0] a_reg;
reg [15:0] b_reg;
reg [31:0] tmp_a;
reg [15:0] tmp_b;
integer i;

always @(*) begin
    a_reg = A;
    b_reg = B;
end

always @(*) begin
    tmp_a = {a_reg, 16'b0};
    tmp_b = {b_reg, 8'b0}; 
    for(i = 0; i < 16; i = i+1) begin
        tmp_a = tmp_a << 1; 
        if (tmp_a[31:16] >= tmp_b) begin
            tmp_a[31:16] = tmp_a[31:16] - tmp_b;
            tmp_a[15:0] = {tmp_a[14:0], 1'b1};
        end
        else
            tmp_a[15:0] = {tmp_a[14:0], 1'b0};
    end
end

assign odd = tmp_a[31:16];
assign result = tmp_a[15:0];

endmodule
