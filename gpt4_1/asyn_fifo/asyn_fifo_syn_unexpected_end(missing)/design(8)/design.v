module	and make sure that the rdata output of the asyn_fifo module is connected to a wire type variable.

Here's the corrected code:

```verilog
module	dual_port_RAM #(parameter DEPTH = 16, parameter WIDTH = 8)
(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output wire [WIDTH-1:0] rdata_reg  		
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
