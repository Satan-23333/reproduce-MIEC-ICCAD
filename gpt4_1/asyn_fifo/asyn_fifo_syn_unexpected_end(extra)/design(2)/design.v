module	dual_port_RAM #(parameter DEPTH = 16,  parameter WIDTH = 8)
(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    always @(posedge wclk) begin
        if(wenc)
            RAM_MEM[waddr] <= wdata;
    end 

    always @(posedge rclk) begin
        if(renc)
            rdata <= RAM_MEM[raddr];
    end 

endmodule
module	asyn_fifo#(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,

    output wire wfull,
    output wire rempty,
    output wire [WIDTH-1:0] rdata
);

    // Internal signal definitions
    reg [$clog2(DEPTH)-1:0] waddr, raddr;
    wire [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
    reg [$clog2(DEPTH)-1:0] waddr_gray, raddr_gray;
    reg [$clog2(DEPTH)-1:0] waddr_gray_next, raddr_gray_next;
    reg [$clog2(DEPTH)-1:0] wptr, rptr;
    reg [$clog2(DEPTH)-1:0] wptr_buff1, wptr_buff2, rptr_buff1, rptr_buff2;
    reg [$clog2(DEPTH)-1:0] wptr_syn, rptr_syn;
    wire [$clog2(DEPTH)-1:0] wptr_bin, rptr_bin;
    wire [$clog2(DEPTH)-1:0] wptr_bin_next, rptr_bin_next;
    wire winc_next, rinc_next;

    // Module instantiation
    dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) RAM(
        .wclk(wclk),
        .wenc(winc),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc),
        .raddr(raddr_bin),
        .rdata(rdata)
    );

    // Rest of the codes remains the same

endmodule
