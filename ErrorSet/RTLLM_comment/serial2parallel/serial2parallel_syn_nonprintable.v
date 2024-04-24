// Module for converting serial data input to parallel output
module serial2parallel(
    input clk,                // Clock input
    input rst_n,              // Asynchronous reset input, active low
    input din_serial,         // Serial data input
    input din_valid,          // Valid signal for the input data
    output reg [7:0] dout_parallel,  // 8-bit parallel data output
    output reg dout_valid            // Output valid signal
);

    reg [7:0] din_tmp;  // Temporary register to store the serial data bits
    reg [3:0] cnt;      // 4-bit counter to keep track of the number of received bits

    // Process to handle the bit count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 0;  // Reset the counter on reset
        else if (din_valid)
            cnt <= (cnt == 4'd8) ？ 0 : cnt + 1‘b1;  // Increment counter or reset if 8 bits have been received
        else
            cnt <= 0;  // Reset the counter if data is not valid
    end

    // Process to build the parallel data from the serial input
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            din_tmp <= 8'b0;  // Reset temporary data register on reset
        else if (din_valid && cnt <= 4'd7)
            din_tmp <= {din_tmp[6:0], din_serial};  // Shift in the new bit to the temporary register
    end

    // Process to output the parallel data and valid signal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout_valid <= 1'b0;
            dout_parallel <= 8'b0;  // Reset output data and valid signal on reset
        end
        else if (cnt == 4'd8) begin
            dout_valid <= 1'b1;          // Set valid signal when 8 bits have been received
            dout_parallel <= din_tmp;    // Transfer the temporary data to the output
        end
        else begin
            dout_valid <= 1'b0;  // Clear valid signal if less than 8 bits have been received
        end
    end

endmodule
