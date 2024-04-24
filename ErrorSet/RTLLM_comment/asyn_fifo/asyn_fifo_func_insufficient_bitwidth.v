`timescale 1ns/1ns  // Defines the simulation time unit and precision

// Define a dual-port RAM module used within the FIFO
module dual_port_RAM #(parameter DEPTH = 16, parameter WIDTH = 8)
(
    input wclk,  // Write clock
    input wenc,  // Write enable signal
    input [$clog2(DEPTH)-1:0] waddr,  // Write address
    input [WIDTH-1:0] wdata,  // Write data
    input rclk,  // Read clock
    input renc,  // Read enable signal
    input [$clog2(DEPTH)-1:0] raddr,  // Read address
    output reg [WIDTH-1:0] rdata  // Read data
);

// Internal RAM storage
reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

// Write logic: write data to RAM on write clock's rising edge if write enable is asserted
always @(posedge wclk) begin
    if (wenc)
        RAM_MEM[waddr] <= wdata;
end

// Read logic: read data from RAM on read clock's rising edge if read enable is asserted
always @(posedge rclk) begin
    if (renc)
        rdata <= RAM_MEM[raddr];
end

endmodule

// Define the asynchronous FIFO module
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,  // Write clock
    input rclk,  // Read clock
    input wrstn,  // Write reset (active low)
    input rrstn,  // Read reset (active low)
    input winc,  // Write increment: signals a write operation
    input rinc,  // Read increment: signals a read operation
    input [WIDTH-1:0] wdata,  // Write data

    output wire wfull,  // Write full signal
    output wire rempty,  // Read empty signal
    output wire [WIDTH-1:0] rdata  // Read data
);

// Address width calculated based on the depth of the FIFO
parameter ADDR_WIDTH = $clog2(DEPTH)-1;

// Binary address pointers for write and read operations
reg [ADDR_WIDTH:0] waddr_bin;
reg [ADDR_WIDTH:0] raddr_bin;

// Write address binary counter logic
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn)
        waddr_bin <= 'd0;
    else if (!wfull && winc)
        waddr_bin <= waddr_bin + 1'd1;
end

// Read address binary counter logic
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn)
        raddr_bin <= 'd0;
    else if (!rempty && rinc)
        raddr_bin <= raddr_bin + 1'd1;
end

// Convert binary addresses to Gray code to ensure synchronization across clock domains
wire [ADDR_WIDTH:0] waddr_gray;
wire [ADDR_WIDTH:0] raddr_gray;
assign waddr_gray = waddr_bin ^ (waddr_bin >> 1);
assign raddr_gray = raddr_bin ^ (raddr_bin >> 1);

// Pointers for tracking the status of the FIFO
reg [ADDR_WIDTH:0] wptr;
reg [ADDR_WIDTH:0] rptr;

// Register updates for the pointers in Gray code format
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn)
        wptr <= 'd0;
    else
        wptr <= waddr_gray;
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn)
        rptr <= 'd0;
    else
        rptr <= raddr_gray;
end

// Synchronization registers to mitigate metastability when crossing clock domains
reg [ADDR_WIDTH:0] wptr_buff, wptr_syn, rptr_buff, rptr_syn;

// Synchronize read pointer to write clock domain
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        rptr_buff <= 'd0;
        rptr_syn <= 'd0;
    end 
    else begin
        rptr_buff <= rptr;
        rptr_syn <= rptr_buff;
    end
end

// Synchronize write pointer to read clock domain
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        wptr_buff <= 'd0;
        wptr_syn <= 'd0;
    end else begin
        wptr_buff <= wptr;
        wptr_syn <= wptr_buff;
    end
end

// Logic to determine if the FIFO is full or empty
assign wfull = (wptr == {~rptr_syn[ADDR_WIDTH:ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]});
assign rempty = (rptr == wptr_syn);

// RAM instance for FIFO storage
dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) dual_port_RAM_inst (
    .wclk(wclk),
    .wenc(winc & !wfull),
    .waddr(waddr_bin[ADDR_WIDTH-1:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc & !rempty),
    .raddr(raddr_bin[ADDR_WIDTH-1:0]),
    .rdata(rdata)
);

endmodule
