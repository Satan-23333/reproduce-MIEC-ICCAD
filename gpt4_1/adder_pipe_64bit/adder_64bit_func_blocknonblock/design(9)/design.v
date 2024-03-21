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
reg [DATA_WIDTH:0] carry[STG_WIDTH:0];
reg [DATA_WIDTH-1:0] adda_reg[STG_WIDTH:0], addb_reg[STG_WIDTH:0];
reg i_en_reg[STG_WIDTH:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg[0] <= 0;
        addb_reg[0] <= 0;
        i_en_reg[0] <= 0;
        carry[0] <= 0;
    end else if (i_en) begin
        adda_reg[0] <= adda;
        addb_reg[0] <= addb;
        i_en_reg[0] <= i_en;
    end
end

genvar i;
generate
    for (i=0; i<STG_WIDTH-1; i=i+1) begin : pipe
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                adda_reg[i+1] <= 0;
                addb_reg[i+1] <= 0;
                i_en_reg[i+1] <= 0;
            end else if (i_en_reg[i]) begin
                adda_reg[i+1] <= adda_reg[i];
                addb_reg[i+1] <= addb_reg[i];
                i_en_reg[i+1] <= i_en_reg[i];
            end
        end
    end
endgenerate

generate
    for (i=0; i<STG_WIDTH; i=i+1) begin : add
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                sum[i] <= 0;
                carry[i] <= 0;
            end else if (i_en_reg[i]) begin
                {carry[i+1], sum[i]} <= adda_reg[i] + addb_reg[i] + carry[i];
            end
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en <= 0;
        result <= 0;
    end else if (i_en_reg[STG_WIDTH-1]) begin
        o_en <= 1'b1;
        result <= {carry[STG_WIDTH], sum[STG_WIDTH-1]};
    end else begin
        o_en <= 0;
    end
end

endmodule
