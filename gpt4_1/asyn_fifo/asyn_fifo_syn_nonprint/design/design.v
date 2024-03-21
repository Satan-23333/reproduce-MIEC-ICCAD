module	asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
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

    // Declare the write and read addresses
    reg [$clog2(DEPTH)-1:0] waddr, raddr;

    // Dual-port RAM instantiation
    dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) RAM (
        .wclk(wclk),
        .wenc(winc && !wfull),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc && !rempty),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Pointer logic
    reg [$clog2(DEPTH):0] wptr, rptr;
    reg [$clog2(DEPTH):0] wptr_buff, rptr_buff;
    reg [$clog2(DEPTH):0] rptr_syn;

    // Write address increment
    always @(posedge wclk or negedge wrstn) begin
        if(!wrstn)
            waddr <= 0;
        else if(winc && !wfull)
            waddr <= waddr + 1;
    end

    // Read address increment
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn)
            raddr <= 0;
        else if(rinc && !rempty)
            raddr <= raddr + 1;
    end

    // FIFO write pointer increment
    always @(posedge wclk or negedge wrstn) begin
        if(!wrstn)
            wptr <= 0;
        else if(winc && !wfull)
            wptr <= wptr + 1;
    end

    // FIFO read pointer increment
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn)
            rptr <= 0;
        else if(rinc && !rempty)
            rptr <= rptr + 1;
    end

    // Write pointer buffer update
    always @(posedge wclk or negedge wrstn) begin
        if(!wrstn)
            wptr_buff <= 0;
        else
            wptr_buff <= wptr;
    end

    // Read pointer buffer update
    always @(posedge rclk or negedge rrstn) begin
        if(!rrstn)
            rptr_buff <= 0;
        else
            rptr_buff <= rptr;
    end

    // Sync read pointer with write buffer
    always @(posedge rclk)
        rptr_syn <= wptr_buff;

    // FIFO full and empty condition
    assign wfull = (wptr[DEPTH:$clog2(DEPTH)] == ~rptr_syn[DEPTH:$clog2(DEPTH)]) && 
        (wptr[$clog2(DEPTH)-1:0] == rptr_syn[$clog2(DEPTH)-1:0]);
    assign rempty = (wptr == rptr_syn);

endmodule
