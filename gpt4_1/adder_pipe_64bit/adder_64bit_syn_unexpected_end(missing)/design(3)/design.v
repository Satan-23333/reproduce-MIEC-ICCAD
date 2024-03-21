module	adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)
(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] adda,
    input [DATA_WIDTH-1:0] addb,
    output [DATA_WIDTH:0] result,
    output reg o_en
);

reg [DATA_WIDTH-1:0] rega [0:STG_WIDTH-1];
reg [DATA_WIDTH-1:0] regb [0:STG_WIDTH-1];
reg [DATA_WIDTH:0] sum [0:STG_WIDTH-1];
reg o_en_reg [0:STG_WIDTH-1];
reg [STG_WIDTH-1:0] i_en_reg;

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
        i_en_reg <= 0;
        o_en_reg[0] <= 0;
    end else begin 
        i_en_reg <= {i_en_reg[STG_WIDTH-2:0], i_en};
        o_en_reg[0] <= i_en_reg[STG_WIDTH-1];
        if (i_en) begin
            rega[0] <= adda;
            regb[0] <= addb;
        end
    end
end

genvar i;
generate
    for (i=0; i<STG_WIDTH-1; i=i+1) begin : STAGE
        always @(posedge clk or negedge rst_n)
        begin
            if (~rst_n) begin
                sum[i] <= 0;
                o_en_reg[i+1] <= 0;
            end else begin
                sum[i] <= rega[i] + regb[i];
                o_en_reg[i+1] <= o_en_reg[i];
                if (o_en_reg[i]) begin
                    rega[i+1] <= sum[i][DATA_WIDTH-1:0];
                    regb[i+1] <= sum[i+1][DATA_WIDTH-1:0];
                end
            end
        end
    end
endgenerate

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n) begin
        result <= 0;
        o_en <= 0;
    end else begin
        result <= sum[STG_WIDTH-1];
        o_en <= o_en_reg[STG_WIDTH-1];
    end
end

endmodule
