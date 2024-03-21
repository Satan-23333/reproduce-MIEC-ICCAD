module	cannot be declared as 'reg' if it is connected to the output of another module.

To fix the error, change the 'output reg' declaration of 'rdata' to 'output' in the 'asyn_fifo' module. Here is the corrected code:

```verilog
module	dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input wclk,
    input rclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];
    
    always @(posedge wclk)
        if(wenc)
            RAM_MEM[waddr] <= wdata;

    always @(posedge rclk)
        if(renc)
            rdata <= RAM_MEM[raddr];
endmodule
