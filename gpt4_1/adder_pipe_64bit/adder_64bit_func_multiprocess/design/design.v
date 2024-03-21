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

// use of reg [DATA_WIDTH-1:0] for stage variables instead of reg
reg [DATA_WIDTH-1:0] stage1, stage2, stage3;

wire [STG_WIDTH-1:0] a1, a2, a3, a4;
wire [STG_WIDTH-1:0] b1, b2, b3, b4;

reg [STG_WIDTH-1:0] a2_ff1, b2_ff1;
reg [STG_WIDTH-1:0] a3_ff1, b3_ff1, a3_ff2, b3_ff2;
reg [STG_WIDTH-1:0] a4_ff1, b4_ff1, a4_ff2, b4_ff2, a4_ff3, b4_ff3;

reg c1, c2, c3, c4;

reg [STG_WIDTH-1:0] s1, s2, s3, s4;
reg [STG_WIDTH-1:0] s1_ff1, s1_ff2, s1_ff3;
reg [STG_WIDTH-1:0] s2_ff1, s2_ff2;
reg [STG_WIDTH-1:0] s3_ff1;

assign a1 = adda[STG_WIDTH-1:0];
assign b1 = addb[STG_WIDTH-1:0];
assign a2 = adda[2*STG_WIDTH-1:STG_WIDTH];
assign b2 = addb[2*STG_WIDTH-1:STG_WIDTH];
assign a3 = adda[3*STG_WIDTH-1:2*STG_WIDTH];
assign b3 = addb[3*STG_WIDTH-1:2*STG_WIDTH];
assign a4 = adda[DATA_WIDTH-1:3*STG_WIDTH];
assign b4 = addb[DATA_WIDTH-1:3*STG_WIDTH];

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 0;
        stage2 <= 0;
        stage3 <= 0;
        o_en <= 0;
    end
    else begin
        stage1 <= i_en;
        stage2 <= stage1;
        stage3 <= stage2;
        o_en <= stage3;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        a2_ff1 <= 0;
        b2_ff1 <= 0;
        a3_ff1 <= 0;
        b3_ff1 <= 0;
        a3_ff2 <= 0;
        b3_ff2 <= 0;
        a4_ff1 <= 0;
        b4_ff1 <= 0;
        a4_ff2 <= 0;
        b4_ff2 <= 0;
        a4_ff3 <= 0;
        b4_ff3 <= 0;
    end
    else begin
        a2_ff1 <= a2;
        b2_ff1 <= b2;
        a3_ff1 <= a3;
        b3_ff1 <= b3;
        a3_ff2 <= a3_ff1;
        b3_ff2 <= b3_ff1;
        a4_ff1 <= a4;
        b4_ff1 <= b4;
        a4_ff2 <= a4_ff1;
        b4_ff2<= b4_ff1;
        a4_ff3 <= a4_ff2;
        b4_ff3 <= b4_ff2;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        s1_ff1 <= 0;
        s1_ff2 <= 0;
        s1_ff3 <= 0;
        s2_ff1 <= 0;
        s2_ff2 <= 0;
        s3_ff1 <= 0;
    end
    else begin
        s1_ff1 <= s1;
        s1_ff2 <= s1_ff1;
        s1_ff3 <= s1_ff2;
        s2_ff1 <= s2;
        s2_ff2 <= s2_ff1;
        s3_ff1 <= s3;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        c1 <= 0;
        s1 <= 0;
    end
    else if (i_en) begin
        {c1, s1} <= a1 + b1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        c2 <= 0;
        s2 <= 0;
    end
    else if (stage1) begin
        {c2, s2} <= a2_ff1 + b2_ff1 + c1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        c3 <= 0;
        s3 <= 0;
    end
    else if (stage2) begin
        {c3, s3} <= a3_ff2 + b3_ff2 + c2;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        c4 <= 0;
        s4 <= 0;
    end
    else if (stage3) begin
        {c4, s4} <= a4_ff3 + b4_ff3 + c3;
    end
end

assign result = {c4, s4, s3_ff1, s2_ff2, s1_ff3};

endmodule
