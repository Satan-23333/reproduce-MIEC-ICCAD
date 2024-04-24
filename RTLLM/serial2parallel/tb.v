module tb();
	reg clk,rst_n;
	reg din_serial,din_valid;
	wire dout_valid;
	wire[7:0]dout_parallel;
 
	always #5 clk = ~clk;

  integer i;
  integer error = 0;
  reg [7:0]num[0:39];
  reg [7:0]expected_result;
	initial begin
		clk  <= 1'b0;
		rst_n <= 1'b0;
		#12
		rst_n <= 1'b1;
		din_valid  <= 1'b1;

		din_serial <= 1'b1; #10;
		din_serial <= 1'b1; #10;
		din_serial <= 1'b1; #10;
		din_serial <= 1'b1; #10;
    error = (dout_valid == 0) ?error:error+1;
		din_serial <= 1'b0; #10;
    din_serial <= 1'b0; #10;
    din_serial <= 1'b0; #10;
    din_serial <= 1'b0; #10;
    while(dout_valid == 0) begin
      #5;
    end
    // $display("%b",dout_parallel);
    error = (dout_parallel == 8'b11110000) ?error:error+1;
    for(i=0;i<40;i=i+1)begin

      expected_result<=num[i];
      din_valid  <= 1'b0; 
		  #30;
		  din_valid  <= 1'b1;

      din_serial <= expected_result[7]; #10
      din_serial <= expected_result[6]; #10
      din_serial <= expected_result[5]; #10
		  din_serial <= expected_result[4]; #10
      error = (dout_valid == 0) ?error:error+1;
		  din_serial <= expected_result[3]; #10
		  din_serial <= expected_result[2]; #10
		  din_serial <= expected_result[1]; #10
		  din_serial <= expected_result[0]; #20
		  din_valid  <= 1'b0;
      while(dout_valid == 0) begin
        #5;
      end
      // $display("%b",dout_parallel);
      error = (dout_parallel == expected_result) ?error:error+1;
		  #10
      error = (dout_valid == 0) ?error:error+1;
    end
    
    #10
    if (error == 0) begin
      $display("===========Your Design Passed===========");
    end
    else begin
    $display("===========Error===========");
    end
		$finish;
  end
  
	verified_serial2parallel u0(
    .clk           (clk)           ,
    .rst_n          (rst_n)          ,
    .din_serial    (din_serial)    ,
    .dout_parallel (dout_parallel) ,
    .din_valid     (din_valid)     ,
    .dout_valid    (dout_valid)
	);  

initial begin
num[0] = 8'b10100101;
num[1] = 8'b00101111;
num[2] = 8'b00011101;
num[3] = 8'b11100100;
num[4] = 8'b00101001;
num[5] = 8'b11101111;
num[6] = 8'b01111001;
num[7] = 8'b01111001;
num[8] = 8'b11011111;
num[9] = 8'b11010101;
num[10] = 8'b11111001;
num[11] = 8'b11000010;
num[12] = 8'b11000001;
num[13] = 8'b00000010;
num[14] = 8'b01110100;
num[15] = 8'b10111010;
num[16] = 8'b01001010;
num[17] = 8'b01001110;
num[18] = 8'b11001000;
num[19] = 8'b01011011;
num[20] = 8'b01100110;
num[21] = 8'b11101101;
num[22] = 8'b10100101;
num[23] = 8'b11100101;
num[24] = 8'b11011101;
num[25] = 8'b00100010;
num[26] = 8'b11011000;
num[27] = 8'b01111100;
num[28] = 8'b01011110;
num[29] = 8'b00101111;
num[30] = 8'b00110111;
num[31] = 8'b11011000;
num[32] = 8'b11011100;
num[33] = 8'b11111001;
num[34] = 8'b01010111;
num[35] = 8'b00101101;
num[36] = 8'b11111001;
num[37] = 8'b11010101;
num[38] = 8'b00011100;
num[39] = 8'b00000011;
  
end

endmodule
