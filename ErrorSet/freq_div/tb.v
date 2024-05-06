module tb ();

reg  clk,rst;

wire out1;
wire out2;
wire out3;

freq_div uut(.CLK_in(clk),.RST(rst),.CLK_50(out1),.CLK_10(out2),.CLK_1(out3));

initial begin
	clk = 0;
	forever #5 clk = ~clk;
end

integer error=0;

initial begin 
	#10;
	rst = 1;
	#35;
	rst = 0;
	// 45, clk: 1, clk50: 0, rclk10: 0, clk1: 0
	error = (out1 != 0 || out2 != 0 || out3 !=0 ) ? error+1 : error;
	if(error!=0)begin
		$display("This is testbench: the expected result out1=0, out2=0, out3=0; but the actual result out1=%b, out2=%b, out3=%b",out1,out2,out3);
		$finish;
	end
	// 55, clk: 1, clk50: 1, rclk10: 0, clk1: 0
	#10;
	error = (out1 != 1 || out2 != 0 || out3 !=0 ) ? error+1 : error;
	if(error!=0)begin
		$display("This is testbench: the expected result out1=1, out2=0, out3=0; but the actual result out1=%b, out2=%b, out3=%b",out1,out2,out3);
		$finish;
	end
	// 95, clk50: 0, rclk10: 1, clk1: 0
	#40;
	error = (out1 != 1 || out2 != 1 || out3 !=0 ) ? error+1 : error;
	if(error!=0)begin
		$display("This is testbench: the expected result out1=1, out2=1, out3=0; but the actual result out1=%b, out2=%b, out3=%b",out1,out2,out3);
		$finish;
	end
	// 225, clk: 1, clk50: 0, rclk10: 1, clk1: 0
	#130;
	error = (out1 != 0 || out2 != 1 || out3 !=0 ) ? error+1 : error;
	if(error!=0)begin
		$display("This is testbench: the expected result out1=0, out2=1, out3=0; but the actual result out1=%b, out2=%b, out3=%b",out1,out2,out3);
		$finish;
	end
	// 625, clk: 1, clk50: 0, rclk10: 1, clk1: 1
	#400;
	error = (out1 != 0 || out2 != 1 || out3 !=1 ) ? error+1 : error;
	if(error!=0)begin
		$display("This is testbench: the expected result out1=0, out2=1, out3=1; but the actual result out1=%b, out2=%b, out3=%b",out1,out2,out3);
		$finish;
	end
	// 1035, clk: 1, clk50: 1, rclk10: 1, clk1: 1
	#410;
	error = (out1 != 1 || out2 != 1 || out3 !=1 ) ? error+1 : error;
	if(error!=0)begin
		$display("This is testbench: the expected result out1=1, out2=1, out3=1; but the actual result out1=%b, out2=%b, out3=%b",out1,out2,out3);
		$finish;
	end
	if (error == 0) begin
            $display("===========Your Design Passed===========");
        end
        else begin
        $display("===========Error===========", error);
        end
	$finish;
end

endmodule