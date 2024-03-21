module	dual_port_RAM #(parameter DEPTH = 16, parameter WIDTH = 8) 
(
	input wire wclk,
	input wire wenc,
	input wire [$clog2(DEPTH)-1:0] waddr,
	input wire [WIDTH-1:0] wdata,
	input wire rclk,
	input wire renc,
	input wire [$clog2(DEPTH)-1:0] raddr,
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
module	asyn_fifo#(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	input wire wclk,
	input wire rclk,
	input wire wrstn,
	input wire rrstn,
	input wire winc,
	input wire rinc,
	input wire [WIDTH-1:0] wdata,
	output wire wfull,
	output wire rempty,
	output wire [WIDTH-1:0] rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

reg [ADDR_WIDTH-1:0] waddr_bin, raddr_bin;

always @(posedge wclk or negedge wrstn) 
	if(!wrstn)
		waddr_bin <= 'd0;
	else if(winc && !wfull)
		waddr_bin <= waddr_bin + 1'b1;

always @(posedge rclk or negedge rrstn) 
	if(!rrstn)
		raddr_bin <= 'd0;
	else if(rinc && !rempty)
		raddr_bin <= raddr_bin + 1'b1;

wire [ADDR_WIDTH-1:0] waddr_gray, raddr_gray;
reg [ADDR_WIDTH-1:0] wptr, rptr;

assign waddr_gray = waddr_bin ^ (waddr_bin>>1);
assign raddr_gray = raddr_bin ^ (raddr_bin>>1);

always @(posedge wclk or negedge wrstn) 
	if(!wrstn)
		wptr <= 'd0;
	else
		wptr <= waddr_gray;

always @(posedge rclk or negedge rrstn) 
	if(!rrstn)
		rptr <= 'd0;
	else
		rptr <= raddr_gray;

reg [ADDR_WIDTH-1:0] wptr_buff, wptr_syn, rptr_buff, rptr_syn;

always @(posedge wclk or negedge wrstn) 
	begin
		if(!wrstn)
			begin
				rptr_buff <= 'd0;
				rptr_syn <= 'd0;
			end
		else
			begin
				rptr_buff <= rptr;
				rptr_syn <= rptr_buff;
			end
	end

always @(posedge rclk or negedge rrstn) 
	begin
		if(!rrstn)
			begin
				wptr_buff <= 'd0;
				wptr_syn <= 'd0;
			end
		else
			begin
				wptr_buff <= wptr;
				wptr_syn <= wptr_buff;
			end
	end

assign wfull = (wptr == {~rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]});
assign rempty = (rptr == wptr_syn);

wire wen, ren;
wire [ADDR_WIDTH-1:0] waddr, raddr;

assign wen = winc && !wfull;
assign ren = rinc && !rempty;
assign waddr = waddr_bin[ADDR_WIDTH-1:0];
assign raddr = raddr_bin[ADDR_WIDTH-1:0];

dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) dual_port_RAM(
	.wclk (wclk),  
	.wenc (wen),  
	.waddr(waddr),  
	.wdata(wdata),       	
	.rclk (rclk), 
	.renc (ren), 
	.raddr(raddr),   
	.rdata(rdata)  		
);

endmodule
