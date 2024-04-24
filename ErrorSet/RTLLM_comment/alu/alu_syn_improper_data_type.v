`timescale 1ns / 1ps  // Defines the time unit and time precision

// Module definition for the ALU
module verified_alu(
    input [31:0] a,          // First 32-bit input operand
    input [31:0] b,          // Second 32-bit input operand
    input [5:0] aluc,        // 6-bit ALU control input specifying the operation
    output [31:0] r,         // 32-bit result of the ALU operation
    output zero,             // Flag that is set if the result is zero
    output carry,            // Carry flag (not used in this code, so no logic for it)
    output negative,         // Negative flag (not used in this code, so no logic for it)
    output overflow,         // Overflow flag (not used in this code, so no logic for it)
    output flag              // General purpose flag, used for set-less-than operations
);

// Operation codes for the ALU, defined as parameters
parameter ADD = 6'b100000;
parameter ADDU = 6'b100001;
parameter SUB = 6'b100010;
parameter SUBU = 6'b100011;
parameter AND = 6'b100100;
parameter OR = 6'b100101;
parameter XOR = 6'b100110;
parameter NOR = 6'b100111;
parameter SLT = 6'b101010;  // Set less than (signed)
parameter SLTU = 6'b101011; // Set less than (unsigned)
parameter SLL = 6'b000000;  // Shift left logical
parameter SRL = 6'b000010;  // Shift right logical
parameter SRA = 6'b000011;  // Shift right arithmetic
parameter SLLV = 6'b000100; // Shift left logical variable
parameter SRLV = 6'b000110; // Shift right logical variable
parameter SRAV = 6'b000111; // Shift right arithmetic variable
parameter JR = 6'b001000;
parameter LUI = 6'b001111;  // Load upper immediate

// Internal signed representations of the inputs
reg signed [31:0] a_signed = a;
reg signed [31:0] b_signed = b;

// Internal register for storing the computation result
reg [32:0] res; // Extra bit for carry-out

// Result assignment
assign r = res[31:0];

// Flag logic for set-less-than operations
assign flag = (aluc == SLT || aluc == SLTU) ? ((aluc == SLT) ? (a_signed < b_signed) : (a < b)) : 1'bz;

// Zero flag logic
assign zero = (res == 32'b0) ? 1'b1 : 1'b0;

// ALU operation logic based on the control input
always @(a or b or aluc)
begin
    case(aluc)
        ADD: res <= a_signed + b_signed;          // Signed addition
        ADDU: res <= a + b;                        // Unsigned addition
        SUB: res <= a_signed - b_signed;           // Signed subtraction
        SUBU: res <= a - b;                        // Unsigned subtraction
        AND: res <= a & b;                         // Bitwise AND
        OR: res <= a | b;                          // Bitwise OR
        XOR: res <= a ^ b;                         // Bitwise XOR
        NOR: res <= ~(a | b);                      // Bitwise NOR
        SLT: res <= a_signed < b_signed ? 1 : 0;   // Set less than (signed)
        SLTU: res <= a < b ? 1 : 0;                // Set less than (unsigned)
        SLL: res <= b << a;                        // Shift left logical
        SRL: res <= b >> a;                        // Shift right logical
        SRA: res <= b_signed >>> a_signed;         // Shift right arithmetic
        SLLV: res <= b << a[4:0];                  // Shift left logical variable
        SRLV: res <= b >> a[4:0];                  // Shift right logical variable
        SRAV: res <= b_signed >>> a_signed[4:0];   // Shift right arithmetic variable
        LUI: res <= {a[15:0], 16'h0000};           // Load upper immediate
        default: res <= 32'bz;                     // Default case
    endcase
end

endmodule
