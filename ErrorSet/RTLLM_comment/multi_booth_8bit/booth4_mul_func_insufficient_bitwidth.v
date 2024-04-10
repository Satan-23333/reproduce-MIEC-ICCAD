// Set the time scale for simulation - 1ns time precision with 1ps simulation time unit
`timescale 1ns / 1ps

// Define the module for an 8-bit Booth's multiplier
module multi_booth_8bit (p, rdy, clk, reset, a, b);
   // Define the input signals:
   // clk: Clock signal for synchronization
   // reset: Reset signal to initialize the module
   // a, b: 8-bit signed integers to be multiplied
   input clk, reset;
   input [7:0] a, b;

   // Define the output signals:
   // p: 16-bit output product of the multiplication
   // rdy: Signal that indicates the completion of the operation
   output [15:0] p;
   output rdy;
   
   // Internal registers to hold the state and intermediate values
   reg [15:0] p;           // Register to hold the product result
   reg [15:0] multiplier;  // Register to hold the extended version of input a
   reg [15:0] multiplicand; // Register to hold the extended version of input b
   reg rdy;               // Register to indicate the readiness of the output
   reg [3:0] ctr;         // Counter register for controlling the operation loop

// Sequential logic block triggered on the positive edge of clk or reset signals
always @(posedge clk or posedge reset) begin
    // When reset is active, initialize the internal registers
    if (reset) begin
        rdy <= 0;
        p <= 0;
        ctr <= 0;
        multiplier <= {{8{a[7]}}, a}; // Sign-extension of a to 16 bits
        multiplicand <= {{8{b[7]}}, b}; // Sign-extension of b to 16 bits
    end 
    else begin
        // Main multiplication loop controlled by the counter ctr
        if (ctr < 16) begin
            multiplicand <= multiplicand << 1; // Left shift multiplicand each clock cycle
            if (multiplier[ctr] == 1) begin
                p <= p + multiplicand; // Add multiplicand to the product if current bit of multiplier is 1
            end
            ctr <= ctr + 1; // Increment the counter
        end
        else begin
            rdy <= 1; // Set ready signal once multiplication is complete
        end
    end
end // End of always block
    
endmodule // End of module
