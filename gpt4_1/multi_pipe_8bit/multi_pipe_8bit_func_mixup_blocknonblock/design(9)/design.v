module	multi_pipe_8bit#(
    parameter size = 8
)(
    input wire clk,
    input wire rst_n,
    input wire [size-1:0] mul_a,
    input wire [size-1:0] mul_b,
    input wire mul_en_in,
    output reg mul_en_out,
    output reg [size*2-1:0] mul_out
);

    reg [2:0] mul_en_out_reg;
    reg [size-1:0] mul_a_reg;
    reg [size-1:0] mul_b_reg;
    wire [size*2-1:0] temp [size-1:0];
    reg [size*2-1:0] sum [size-1:0];
    reg [size*2-1:0] mul_out_reg;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            mul_en_out_reg <= 3'b0;
            mul_en_out     <= 1'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            mul_out_reg <= 16'b0;
            mul_out <= 16'b0;
            for (integer i=0; i<size; i=i+1)
                sum[i] <= 16'b0;
        end else begin
            mul_en_out_reg <= {mul_en_out_reg[1:0],mul_en_in};
            mul_en_out     <= mul_en_out_reg[2];
            if(mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    genvar i;
    generate
        for (i = 0; i < size; i=i+1) begin : partial_product_gen
            assign temp[i] = mul_b_reg[i] ? ({size{mul_a_reg}} << i) : {size*2{1'b0}};
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for (integer i=0; i<size; i=i+1)
                sum[i] <= 16'b0;
        end else begin
            for (integer i=0; i<size; i=i+1)
                sum[i] <= temp[i];
            mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3] + sum[4] + sum[5] + sum[6] + sum[7];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            mul_out <= 16'b0;
        else if(mul_en_out)
            mul_out <= mul_out_reg;
        else
            mul_out <= 16'b0;
    end

endmodule
