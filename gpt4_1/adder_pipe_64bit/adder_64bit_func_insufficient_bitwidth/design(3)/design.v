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
    output [DATA_WIDTH:0] result,  // Output size increased to 65 bit
    output reg o_en
);

// Define internal signals
reg [DATA_WIDTH:0] c4;
reg [DATA_WIDTH:0] s4;
reg [STG_WIDTH-1:0] s3_ff1, s2_ff2, s1_ff3;

// Define pipeline registers
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        s1_ff3 <= 0;
        s2_ff2 <= 0;
        s3_ff1 <= 0;
    end
    else if(i_en)
    begin
        s1_ff3 <= adda[STG_WIDTH-1:0] + addb[STG_WIDTH-1:0];
        s2_ff2 <= adda[2*STG_WIDTH-1:STG_WIDTH] + addb[2*STG_WIDTH-1:STG_WIDTH];
        s3_ff1 <= adda[3*STG_WIDTH-1:2*STG_WIDTH] + addb[3*STG_WIDTH-1:2*STG_WIDTH];
    end
end

// Addition operation
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        c4 <= 0;
        s4 <= 0;
    end
    else if(i_en)
    begin
        {c4, s4} <= s1_ff3 + s2_ff2 + s3_ff1 + adda[DATA_WIDTH-1:3*STG_WIDTH] + addb[DATA_WIDTH-1:3*STG_WIDTH];
    end
end

// Output enable signal
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
        o_en <= 0;
    else if(i_en)
        o_en <= 1;
    else
        o_en <= 0;
end

// Assign result
assign result = {c4, s4};

endmodule
