module	multi_pipe_8bit(
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    reg [2:0] mul_en_out_reg;
    always@(posedge clk or negedge rst_n)
        if(!rst_n) begin
            mul_en_out_reg <= 3'd0;
        end
        else begin
            mul_en_out_reg <= {mul_en_out_reg[1:0], mul_en_in};
        end

    assign mul_en_out = mul_en_out_reg[2];
    
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    always @(posedge clk or negedge rst_n)
        if(!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end
        else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

    wire [15:0] temp [7:0];
    genvar i;
    generate
        for(i=0; i<8; i=i+1)
            assign temp[i] = mul_b_reg[i]? (mul_a_reg << i) : 16'd0;
    endgenerate

    reg [15:0] sum [7:0];
    generate
        for(i=0; i<8; i=i+1)
            always @(posedge clk or negedge rst_n) 
                if(!rst_n) 
                    sum[i] <= 16'd0;
                else if(mul_en_in)
                    sum[i] <= temp[i];
    endgenerate

    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) 
        if(!rst_n)
            mul_out_reg <= 16'd0;
        else if(mul_en_in)
            mul_out_reg <= sum[0] + sum[1] + sum[2] + sum[3] + sum[4] + sum[5] + sum[6] + sum[7];

    always @(posedge clk or negedge rst_n) 
        if(!rst_n)
            mul_out <= 16'd0;
        else if(mul_en_out)
            mul_out <= mul_out_reg;
        else
            mul_out <= 16'd0;

endmodule
