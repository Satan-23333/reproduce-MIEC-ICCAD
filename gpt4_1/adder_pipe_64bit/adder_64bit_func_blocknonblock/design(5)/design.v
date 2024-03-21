module	adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 4
)
(
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

reg [DATA_WIDTH:0] sum[STG_WIDTH:0];
reg [DATA_WIDTH-1:0] adda_reg[STG_WIDTH:0], addb_reg[STG_WIDTH:0];
reg i_en_reg[STG_WIDTH:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg[0] <= 64'd0;
        addb_reg[0] <= 64'd0;
        i_en_reg[0] <= 1'b0;
    end else if (i_en) begin
        adda_reg[0] <= adda;
        addb_reg[0] <= addb;
        i_en_reg[0] <= i_en;
    end
end

genvar i;
generate
    for (i=0; i<STG_WIDTH; i=i+1) begin : pipe
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                adda_reg[i+1] <= 64'd0;
                addb_reg[i+1] <= 64'd0;
                i_en_reg[i+1] <= 1'b0;
            end else if (i_en_reg[i]) begin
                adda_reg[i+1] <= adda_reg[i];
                addb_reg[i+1] <= addb_reg[i];
                i_en_reg[i+1] <= i_en_reg[i];
            end
        end
    end
endgenerate

generate
    for (i=0; i<=STG_WIDTH; i=i+1) begin : add
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                sum[i] <= 65'd0;
            end else if (i_en_reg[i]) begin
                sum[i] <= adda_reg[i] + addb_reg[i];
            end
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en <= 1'b0;
        result <= 65'd0;
    end else if (i_en_reg[STG_WIDTH]) begin
        o_en <= 1'b1;
        result <= sum[STG_WIDTH];
    end else begin
        o_en <= 1'b0;
    end
end

endmodule
