module	parallel2serial(
	input wire clk  ,
	input wire rst_n  ,
	input wire [3:0]d ,
	output wire valid_out ,
	output wire dout
	);


reg [3:0] data = 4'b0;
reg [1:0]cnt;
reg valid;
assign dout = data[3];
assign valid_out =valid;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        data<= 4'b0;
        cnt <= 2'b0;
        valid <= 1'b0;
    end
    else  begin                
		if (cnt == 2'b11) begin
			data <= {1'b0, d};
			cnt <= 2'b0;
			valid <= 1'b1;
		end
		else begin
			cnt <= cnt + 2'b1;
			valid <= 1'b0;
			data  <= {1'b0, data[3:1]};
		end
    end
end
endmodule
