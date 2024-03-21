module	asyn_fifo #(parameter WIDTH = 8, DEPTH = 16)
(
    input wclk, rclk, wrstn, rrstn, winc, rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull, rempty,
    output reg [WIDTH-1:0] rdata
);
    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    reg [ADDR_WIDTH:0] wptr, rptr, wptr_bin, rptr_bin;
    reg [ADDR_WIDTH:0] wptr_buff, rptr_buff;
    wire [ADDR_WIDTH:0] waddr, raddr;
    wire wenc, renc;
    
    // Instantiate dual-port RAM
    dual_port_RAM #(DEPTH, WIDTH) RAM (
        .wclk(wclk), .wenc(wenc), .waddr(waddr), .wdata(wdata),
        .rclk(rclk), .renc(renc), .raddr(raddr), .rdata(rdata)
    );
    
    // Write Pointer
    always @(posedge wclk or negedge wrstn)
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1;
    
    // Read Pointer
    always @(posedge rclk or negedge rrstn)
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1;
            
    // Gray Code Conversion for Write Pointer
    assign wptr = wptr_bin ^ (wptr_bin >> 1);

    // Gray Code Conversion for Read Pointer
    assign rptr = rptr_bin ^ (rptr_bin >> 1);
    
    // Write Pointer Buffer
    always @(posedge rclk or negedge rrstn)
        if (!rrstn)
            wptr_buff <= 0;
        else
            wptr_buff <= wptr;
    
    // Read Pointer Buffer
    always @(posedge wclk or negedge wrstn)
        if (!wrstn)
            rptr_buff <= 0;
        else
            rptr_buff <= rptr;
    
    // Full and Empty signals
    assign wfull = (wptr_buff == ({~rptr_buff[ADDR_WIDTH], rptr_buff[ADDR_WIDTH-1:0]}));
    assign rempty = (wptr == rptr_buff);
    
    // Control Signals
    assign wenc = winc && !wfull;
    assign renc = rinc && !rempty;
    
    // Address Signals
    assign waddr = wptr[ADDR_WIDTH-1:0];
    assign raddr = rptr[ADDR_WIDTH-1:0];
    
endmodule
