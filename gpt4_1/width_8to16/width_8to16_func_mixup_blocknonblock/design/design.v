module	width_8to16(
	input 				   clk 		,   
	input 				   rst_n		,
	input				      valid_in	,
	input	   [7:0]		   data_in	,
 
 	output	reg			valid_out,
	output   reg [15:0]	data_out
);
reg 	[7:0]		data_lock;  //data buffer
reg 				flag	   ;
//input data buff in data_lock
always @(posedge clk or negedge rst_n ) begin
	if(!rst_n) 
		data_lock <= 8'b0;
	else if(valid_in && !flag)
		data_lock <= data_in;
end
//generate flag
always @(posedge clk or negedge rst_n ) begin
	if(!rst_n) 
		flag <= 1'b0;
	else if(valid_in)
		flag <= ~flag;
end
//generate valid_out
always @(posedge clk or negedge rst_n ) begin
	if(!rst_n) 
		valid_out <= 1'b0;
	else if(valid_in && flag)
		valid_out <= 1'b1;
	else
		valid_out <= 1'b0;
end
//data stitching 
always @(posedge clk or negedge rst_n ) begin
	if(!rst_n) 
		data_out <= 16'b0;
	else if(valid_in && flag)
		data_out <= {data_lock, data_in};
end

endmodule
