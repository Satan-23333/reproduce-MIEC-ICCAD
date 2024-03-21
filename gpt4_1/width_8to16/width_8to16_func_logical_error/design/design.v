module	width_8to16(
	input 			clk 	,   
	input 			rst_n	,
	input			valid_in	,
	input	[7:0]	data_in	,
 
 	output	reg		valid_out,
	output reg [15:0]	data_out
);
reg 	[7:0]		data_lock;  //data buffer
reg 				flag	   ;
//input data buff in data_lock
always @(posedge clk or negedge rst_n ) begin
	if(!rst_n) begin
		data_lock <= 'd0;
		flag <= 'd0;
	end
	else if(valid_in) begin
		if (flag == 0) begin
			data_lock <= data_in;
			flag <= 1'b1;
		end else begin
			data_out <= {data_lock, data_in};
			valid_out <= 1'b1;
			flag <= 1'b0;
		end
	end else if (flag == 1) begin
		valid_out <= 1'b0;
	end
end
endmodule
