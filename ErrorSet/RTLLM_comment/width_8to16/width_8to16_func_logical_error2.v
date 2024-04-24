`timescale 1ns/1ns  // Defines the time unit and precision for the simulation

// Module definition for an 8-to-16 bit width adapter
module width_8to16(
    input clk,             // Clock input
    input rst_n,           // Active-low reset input
    input valid_in,        // Input valid signal
    input [7:0] data_in,   // 8-bit input data

    output reg valid_out,     // Output valid signal
    output reg [15:0] data_out // 16-bit output data
);

reg [7:0] data_lock;  // Buffer to store the first half of the 16-bit data
reg flag;             // Flag to indicate whether the first half of the data has been stored

// Buffer the first 8 bits of data when valid signal is high and flag is not set
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_lock <= 'd0;
    else if (valid_in && !flag)
        data_lock <= data_in;
end

// Toggle the flag with each valid input data
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        flag <= 'd0;
    else if (valid_in)
        flag <= ~flag;
end

// Set the output valid signal when the second half of the data is ready
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        valid_out <= 'd0;
    else if (valid_in && flag)
        valid_out <= 1'd1;
    else
        valid_out <= 'd0;
end

// Combine the two 8-bit data chunks into a 16-bit output when the second chunk is valid
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_out <= 'd0;
    else if (valid_in && flag)
        data_out <= {data_in, data_lock};  // Concatenate buffered data and current data
end

endmodule
