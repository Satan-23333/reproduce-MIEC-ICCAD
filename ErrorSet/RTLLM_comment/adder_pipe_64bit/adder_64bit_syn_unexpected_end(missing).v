module adder_pipe_64bit
#(
    parameter DATA_WIDTH = 64,   // Default data width for the adder
    parameter STG_WIDTH = 16     // Width of each pipeline stage
)
(
    input clk,                    // Clock input for synchronizing the pipeline stages
    input rst_n,                  // Active-low reset signal to initialize or reset the pipeline
    input i_en,                   // Input enable signal to start the addition process
    input [DATA_WIDTH-1:0] adda,  // First 64-bit operand for addition
    input [DATA_WIDTH-1:0] addb,  // Second 64-bit operand for addition
    output [DATA_WIDTH:0] result // 65-bit result to accommodate possible overflow
    output reg o_en               // Output enable signal to indicate result validity
);

// Register declarations for pipeline stages
reg stage1, stage2, stage3;

// Wire declarations for partitioning inputs across pipeline stages
wire [STG_WIDTH-1:0] a1, b1, a2, b2, a3, b3, a4, b4;

// Register declarations for holding values across clock cycles in the pipeline
reg [STG_WIDTH-1:0] a2_ff1, b2_ff1, a3_ff1, b3_ff1, a3_ff2, b3_ff2;
reg [STG_WIDTH-1:0] a4_ff1, b4_ff1, a4_ff2, b4_ff2, a4_ff3, b4_ff3;

// Carry and sum registers for each stage
reg c1, c2, c3, c4;
reg [STG_WIDTH-1:0] s1, s2, s3, s4;

// Flip-flops to store intermediate sums for final result assembly
reg [STG_WIDTH-1:0] s1_ff1, s1_ff2, s1_ff3, s2_ff1, s2_ff2, s3_ff1;

// Partitioning the inputs for different pipeline stages
assign a1 = adda[STG_WIDTH-1:0];
assign b1 = addb[STG_WIDTH-1:0];
assign a2 = adda[STG_WIDTH*2-1:STG_WIDTH];
assign b2 = addb[STG_WIDTH*2-1:STG_WIDTH];
assign a3 = adda[STG_WIDTH*3-1:STG_WIDTH*2];
assign b3 = addb[STG_WIDTH*3-1:STG_WIDTH*2];
assign a4 = adda[STG_WIDTH*4-1:STG_WIDTH*3];
assign b4 = addb[STG_WIDTH*4-1:STG_WIDTH*3];

// Pipeline stage control logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 1'b0;
        stage2 <= 1'b0;
        stage3 <= 1'b0;
        o_en <= 1'b0;
    end 
    else begin
        stage1 <= i_en;
        stage2 <= stage1;
        stage3 <= stage2;
        o_en <= stage3;
    end
end

// Pipeline registers for input data staging
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all flip-flops on reset
        a2_ff1 <= 'd0;
        b2_ff1 <= 'd0;
        a3_ff1 <= 'd0;
        b3_ff1 <= 'd0;
        a3_ff2 <= 'd0;
        b3_ff2 <= 'd0;
        a4_ff1 <= 'd0;
        b4_ff1 <= 'd0;
        a4_ff2 <= 'd0;
        b4_ff2 <= 'd0;
        a4_ff3 <= 'd0;
        b4_ff3 <= 'd0;
    end 
    else begin
        // Propagate the data through the pipeline
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

// Pipeline registers for sum staging
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all sum flip-flops on reset
        s1_ff1 <= 'd0;
        s1_ff2 <= 'd0;
        s1_ff3 <= 'd0;
        s2_ff1 <= 'd0;
        s2_ff2 <= 'd0;
        s3_ff1 <= 'd0;
    end 
    else begin
        // Propagate the sums through the pipeline
        s1_ff1 <= s1;
        s1_ff2 <= s1_ff1;
        s1_ff3 <= s1_ff2;
        s2_ff1 <= s2;
        s2_ff2 <= s2_ff1;
        s3_ff1 <= s3;
    end
end

// Arithmetic operations for each pipeline stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        c1 <= 1'b0;
        s1 <= 'd0;
    end 
    else if (i_en) begin
        {c1, s1} <= a1 + b1;
    end 
    else begin
        c1 <= c1;
        s1 <= s1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        c2 <= 1'b0;
        s2 <= 'd0;
    end 
    else if (stage1) begin
        {c2, s2} <= a2_ff1 + b2_ff1 + c1;
    end 
    else begin
        c2 <= c2;
        s2 <= s2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        c3 <= 1'b0;
        s3 <= 'd0;
    end 
    else if (stage2) begin
        {c3, s3} <= a3_ff2 + b3_ff2 + c2;
    end 
    else begin
        c3 <= c3;
        s3 <= s3;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        c4 <= 1'b0;
        s4 <= 'd0;
    end 
    else if (stage3) begin
        {c4, s4} <= a4_ff3 + b4_ff3 + c3;
    end 
    else begin
        c4 <= c4;
        s4 <= s4;
    end
end

// Assemble the final result from the staged sums and carry
assign result = {c4, s4, s3_ff1, s2_ff2, s1_ff3};

endmodule
