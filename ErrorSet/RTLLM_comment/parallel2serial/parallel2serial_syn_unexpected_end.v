`timescale 1ns/1ns

// Module declaration for converting parallel data to serial format
module parallel2serial(
    input wire clk,         // Clock input
    input wire rst_n,       // Asynchronous reset input, active low
    input wire [3:0] d,     // 4-bit parallel data input
    output wire valid_out,  // Output signal indicating valid serial data
    output wire dout        // Serial data output
);

    reg [3:0] data = 'd0;  // Internal register to hold the parallel data
    reg [1:0] cnt;         // 2-bit counter to track the serial conversion process
    reg valid;             // Internal signal to indicate valid output

    // Assign the MSB of data to dout and valid signal to valid_out
    assign dout = data[3];
    assign valid_out = valid;

    // Sequential logic for parallel to serial conversion
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 'd0;  // Reset internal data and counter on reset
            cnt <= 'd0;
            valid <= 'd0
        end
        else begin
            if (cnt == 'd3) begin
                data <= d;    // Load new parallel data into the internal register
                cnt <= 'd0;   // Reset counter after 4 clock cycles
                valid <= 1;   // Indicate valid serial data is available
            end
            else begin
                cnt <= cnt + 'd1;        // Increment counter
                valid <= 0;              // Clear valid signal
                data <= {data[2:0], data[3]}; // Rotate data to the right
            end
        end
    end

endmodule
