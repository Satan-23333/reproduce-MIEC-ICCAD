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

// Define internal signals
reg [DATA_WIDTH:0] sum;
reg [STG_WIDTH-1:0] s1_ff1, s2_ff2, s3_ff3, s4_ff4;

// Define pipeline registers
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        s1_ff1 <= 0;
        s2_ff2 <= 0;
        s3_ff3 <= 0;
        s4_ff4 <= 0;
    end
    else if(i_en)
    begin
        s1_ff1 <= adda[STG_WIDTH-1:0] + addb[STG_WIDTH-1:0];
        s2_ff2 <= adda[2*STG_WIDTH-1:STG_WIDTH] + addb[2*STG_WIDTH-1:STG_WIDTH] + s1_ff1[STG_WIDTH];
        s3_ff3 <= adda[3*STG_WIDTH-1:2*STG_WIDTH] + addb[3*STG_WIDTH-1:2*STG_WIDTH] + s2_ff2[STG_WIDTH];
        s4_ff4 <= adda[DATA_WIDTH-1:3*STG_WIDTH] + addb[DATA_WIDTH-1:3*STG_WIDTH] + s3_ff3[STG_WIDTH];
    end
end

// Addition operation and output assignment
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        sum <= 0;
        o_en <= 0;
    end
    else if(i_en)
    begin
        sum <= {s4_ff4[STG_WIDTH:0], s3_ff3[STG_WIDTH-1:0], s2_ff2[STG_WIDTH-1:0], s1_ff1[STG_WIDTH-1:0]};
        o_en <= 1;
    end
    else
    begin
        o_en <= 0;
    end
end

// Assign result
assign result = sum;

endmodule
