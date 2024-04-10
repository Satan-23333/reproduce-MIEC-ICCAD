`timescale 1ns/1ps  // Specifies the time unit and time precision for simulation.

module radix2_div  // Module name
#(
    parameter DATAWIDTH=8  // Parameter for data width, default is 8 bits.
)
(
    // Port declarations
    input                       clk,        // Clock input
    input                       rstn,       // Active low reset signal
    input                       en,         // Enable signal for the operation
    output  wire                ready,      // Output signal indicating ready status
    input  [DATAWIDTH-1:0]      dividend,   // Input dividend
    input  [DATAWIDTH-1:0]      divisor,    // Input divisor
    output wire [DATAWIDTH-1:0] quotient,   // Output quotient
    output wire [DATAWIDTH-1:0] remainder,  // Output remainder
    output wire                 vld_out     // Output signal indicating valid result
);

// State definitions for the state machine
parameter IDLE = 0;
parameter SUB  = 1;
parameter SHIFT = 2;
parameter DONE = 3;

// Extended precision registers for division operation
reg [DATAWIDTH*2-1:0] dividend_e;
reg [DATAWIDTH*2-1:0] divisor_e;
reg [DATAWIDTH-1:0]   quotient_e;
reg [DATAWIDTH-1:0]   remainder_e;

// State registers
reg [1:0] current_state, next_state;

// Counter for the division process
reg [DATAWIDTH-1:0] count;

// State machine for controlling the division operation
always @(posedge clk or negedge rstn) begin
    if (!rstn) curret_state <= IDLE;  // Reset to IDLE state
    else current_state <= next_state;  // Transition to the next state
end

// Logic for next state transition based on current state and conditions
always @(*) begin
    next_state = 2'bx;  // Default undefined state
    case (current_state)
        IDLE: if (en) next_state <= SUB;  // Start division on enable
              else next_state <= IDLE;
        SUB:  next_state <= SHIFT;        // Perform subtraction and shift to SHIFT state
        SHIFT: if (count < DATAWIDTH) next_state <= SUB;  // Loop through SHIFT and SUB states
               else next_state <= DONE;  // Completion of division
        DONE: next_state <= IDLE;        // Reset to IDLE after completion
    endcase
end

// Main division logic implemented in a sequential always block
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin  // Reset all registers
        dividend_e <= 0;
        divisor_e <= 0;
        quotient_e <= 0;
        remainder_e <= 0;
        count <= 0;
    end 
    else begin
        case (current_state)
            IDLE: begin
                // Initialize extended dividend and divisor
                dividend_e <= {{DATAWIDTH{1'b0}}, dividend};
                divisor_e <= {divisor, {DATAWIDTH{1'b0}}};
            end
            SUB: begin
                // Perform subtraction if dividend_e is greater than or equal to divisor_e
                if (dividend_e >= divisor_e) begin
                    dividend_e <= dividend_e - divisor_e + 1'b1;
                end
            end
            SHIFT: begin
                // Shift dividend_e left and increment count
                if (count < DATAWIDTH) begin
                    dividend_e <= dividend_e << 1;
                    count <= count + 1;
                end
                else begin
                    // At the end of division, set quotient and remainder
                    quotient_e <= dividend_e[DATAWIDTH-1:0];
                    remainder_e <= dividend_e[DATAWIDTH*2-1:DATAWIDTH];
                end
            end
            DONE: begin
                count <= 0;  // Reset count in DONE state
            end
        endcase
    end
end

// Output assignments
assign ready = (current_state == DONE);  // Ready signal indicates completion
assign quotient = quotient_e;            // Assign calculated quotient to output
assign remainder = remainder_e;          // Assign calculated remainder to output
assign vld_out = (current_state == DONE); // Valid output signal when division is complete

endmodule
