module	dual_port_RAM #(parameter DEPTH = 16, parameter WIDTH = 8)
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

assign rdata = RAM_MEM[raddr];

endmodule
module	asyn_fifo #(parameter DEPTH = 16, parameter WIDTH = 8)
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
    output wire [WIDTH-1:0] rdata
);

integer i;
reg [$clog2(DEPTH)-1:0] waddr, raddr;
reg [WIDTH-1:0] wptr, rptr, wptr_buff, rptr_buff;

initial begin
    for(i=0; i<DEPTH; i=i+1)
        RAM_MEM[i] = 0;
    waddr = 0;
    raddr = 0;
    wptr = 0;
    rptr = 0;
    wptr_buff = 0;
    rptr_buff = 0;
    wfull = 0;
    rempty = 1;
end

dual_port_RAM #(DEPTH, WIDTH) RAM (
    .wclk(wclk),
    .wenc(winc && !wfull),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc && !rempty),
    .raddr(raddr),
    .rdata(rdata)
);

always @(posedge wclk or negedge wrstn) begin
    if(!wrstn) begin
        wptr <= 0;
        wptr_buff <= 0;
    end
    else if(winc && !wfull) begin
        wptr <= wptr + 1;
        wptr_buff <= wptr;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if(!rrstn) begin
        rptr <= 0;
        rptr_buff <= 0;
    end
    else if(rinc && !rempty) begin
        rptr <= rptr + 1;
        rptr_buff <= rptr;
    end
end

always @(posedge wclk or posedge rclk or negedge wrstn) begin
    if(!wrstn)
        wfull <= 0;
    else if(wclk && rclk)
        wfull <= (wptr_buff == (~rptr_buff[WIDTH-1],rptr_buff[WIDTH-2:0]));
end

always @(posedge wclk or posedge rclk or negedge rrstn) begin
    if(!rrstn)
        rempty <= 1;
    else if(wclk && rclk)
        rempty <= (wptr == rptr);
end

endmodule
