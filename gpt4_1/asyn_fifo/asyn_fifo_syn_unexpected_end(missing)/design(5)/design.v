module	and the asyn_fifo module from 'output reg' to 'output' and use an internal register to store the value before assigning it to 'rdata'. Here is the corrected code:

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
    output [WIDTH-1:0] rdata 		
);

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];
reg [WIDTH-1:0] rdata_reg;

always @(posedge wclk) begin
    if(wenc)
        RAM_MEM[waddr] <= wdata;
end 

always @(posedge rclk) begin
    if(renc)
        rdata_reg <= RAM_MEM[raddr];
end 

assign rdata = rdata_reg;

endmodule
