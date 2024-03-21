module	dual_port_RAM #(parameter DEPTH = 16, parameter WIDTH = 8)
(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata_reg  		
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

always @(posedge wclk) begin
    if(wenc)
        RAM_MEM[waddr] <= wdata;
end 

always @(posedge rclk) begin
    if(renc)
        rdata_reg <= RAM_MEM[raddr];
end 

endmodule
module	asyn_fifo #(parameter WIDTH = 8, parameter DEPTH = 16)
(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

// Instantiate dual-port RAM
dual_port_RAM #(DEPTH, WIDTH) RAM (
    .wclk(wclk),
    .wenc(winc & ~wfull),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc & ~rempty),
    .raddr(raddr_bin),
    .rdata_reg(rdata)
);

// Other code for the asyn_fifo module

endmodule
