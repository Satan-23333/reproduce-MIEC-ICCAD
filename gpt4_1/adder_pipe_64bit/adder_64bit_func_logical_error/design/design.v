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

reg [DATA_WIDTH:0] c2, s2;
reg stage1;
reg [DATA_WIDTH-1:0] a2_ff1, b2_ff1;
reg [DATA_WIDTH:0] c1;

assign result = s2;

// ... keeping the other parts of the code unchanged ...

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        c2 <= 1'b0;
        s2 <= 'd0;
        stage1 <= 1'b0;
        a2_ff1 <= 'd0;
        b2_ff1 <= 'd0;
        c1 <= 1'b0;
    end
    else if (i_en) begin
        stage1 <= 1'b1;
        a2_ff1 <= adda;
        b2_ff1 <= addb;
        {c1, s2} <= adda + addb; 
    end
    else begin
        {c2, s2} <= a2_ff1 + b2_ff1 + c1; 
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) o_en <= 1'b0;
    else if(stage1) o_en <= 1'b1;
    else o_en <= o_en;
end

// ... keeping the other parts of the code unchanged ...

endmodule
