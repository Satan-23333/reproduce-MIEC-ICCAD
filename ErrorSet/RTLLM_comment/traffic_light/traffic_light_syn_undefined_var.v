`timescale 1ns/1ns  // Time unit and precision definition

// Module definition for a traffic light controller
module traffic_light(
    input rst_n,             // Active-low reset
    input clk,               // Clock input
    input pass_request,      // Input signal, possibly for requesting a pass or pedestrian signal
    output wire[7:0] clock,  // 8-bit clock output, perhaps for timing display
    output reg red,          // Red light control
    output reg yellow,       // Yellow light control
    output reg green         // Green light control
);

// State parameter definitions for the finite state machine
parameter idle = 2'd0,
          s1_red = 2'd1,
          s2_yellow = 2'd2,
          s3_green = 2'd3;

reg [7:0] cnt;     // Counter used for timing the light changes
reg [1:0] state;   // State register for the finite state machine
reg p_red, p_yellow, p_green;  // Previous state registers for the lights

// State machine for controlling traffic light sequence
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset condition
        state <= idle;
        p_red <= 1'b0;
        p_green <= 1'b0;
        p_yellow <= 1'b0;
    end else case (state)
        idle: begin  // Initial state
            p_red <= 1'b0;
            p_green <= 1'b0;
            p_yellow <= 1'b0;
            state <= s1_red;
        end
        s1_red: begin  // Red light state
            p_red <= 1'b1;
            p_green <= 1'b0;
            p_yellow <= 1'b0;
            if (cnt == 3) 
                state <= s3_green;
            else
                state <= s1_red;
        end
        s2_yellow: begin  // Yellow light state
            p_red <= 1'b0;
            p_green <= 1'b0;
            p_yellow <= 1'b1;
            if (cnt == 3) 
                state <= s1_red;
            else
                state <= s2_yellow;
        end
        s3_green: begin  // Green light state
            p_red <= 1'b0;
            p_green <= 1'b1;
            p_yellow <= 1'b0;
            if (count == 3) 
				state <= s2_yellow;
			else
				state <= s3_green;
        end
    endcase
end

// Counter logic to manage timing and state transitions
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt <= 7'd10;  // Initialize with a default value
    else if (pass_request && green && (cnt > 10))
        cnt <= 7'd10;  // Reset counter if pass requested and light is green
    else if (!green && p_green)
        cnt <= 7'd60;  // Long delay for green light
    else if (!yellow && p_yellow)
        cnt <= 7'd5;   // Short delay for yellow light
    else if (!red && p_red)
        cnt <= 7'd10;  // Standard delay for red light
    else
        cnt <= cnt - 1;  // Decrement counter
end
assign clock = cnt;  // Output the counter value to the clock output

// Update the actual light outputs based on the current state
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        yellow <= 1'd0;
        red <= 1'd0;
        green <= 1'd0;
        end 
    else begin
        yellow <= p_yellow;
        red <= p_red;
        green <= p_green;
        end
end

endmodule
