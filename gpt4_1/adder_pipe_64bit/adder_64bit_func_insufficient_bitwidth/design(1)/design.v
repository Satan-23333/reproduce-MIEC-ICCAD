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

// The remaining part of the code remains the same as before

// The last line should be updated as follows to reflect the changes in the 'result' port size
assign result = {c4, s4, s3_ff1, s2_ff2, s1_ff3};

endmodule
