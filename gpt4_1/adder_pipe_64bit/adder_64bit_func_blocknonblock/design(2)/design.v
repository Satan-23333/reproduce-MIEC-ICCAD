module	adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)
(
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output wire [DATA_WIDTH:0] result,
    output reg o_en
);

reg [DATA_WIDTH:0] sum[3:0];
reg [DATA_WIDTH-1:0] adda_reg[3:0], addb_reg[3:0];
reg i_en_reg[2:0];

// Split input data into stages and pipeline it
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

// Pipeline the data for addition operation
genvar i;
generate
    for (i=0; i<3; i=i+1) begin : pipe
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

// Perform addition operation at each pipeline stage
generate
    for (i=0; i<4; i=i+1) begin : add
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                sum[i] <= 65'd0;
            end else if (i_en_reg[i]) begin
                sum[i] <= adda_reg[i] + addb_reg[i];
            end
        end
    end
endgenerate

// Output the final result and output enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en <= 1'b0;
        result <= 65'd0;
    end else if (i_en_reg[3]) begin
        o_en <= 1'b1;
        result <= sum[3];
    end else begin
        o_en <= 1'b0;
    end
end

endmodule
