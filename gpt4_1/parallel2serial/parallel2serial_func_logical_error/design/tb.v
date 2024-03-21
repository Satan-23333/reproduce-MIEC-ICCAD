`timescale 1ns/1ns

module tb;
  reg clk;
  reg rst_n;
  reg [3:0] d;
  wire valid_out;
  wire dout;

  // Instantiate the DUT (Design Under Test)
  parallel2serial uut (
    .clk(clk),
    .rst_n(rst_n),
    .d(d),
    .valid_out(valid_out),
    .dout(dout)
  );
  reg [3:0]num[0:39];
  // Generate clock
  always #5 clk = ~clk;
  integer error = 0;
  integer failcase = 0;
  integer i = 0;
  reg d3,d2,d1,d0;
  initial begin
    for (i=0; i<40; i=i+1) begin
        error = 0;
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        d = 4'b0;

        #10;
        rst_n = 1;
        #10;
        d = num[i];
        while (valid_out == 0) begin
            @(posedge clk); // Wait for one clock cycle
        end
        // $display("dout = %b, valid_out = %b", dout, valid_out);
        d3=dout;
        error = (dout == d[3] && valid_out==1) ? error : error+1;
        #10;
       d2=dout;
        // $display("dout = %b, valid_out = %b", dout, valid_out);
        error = (dout == d[2] && valid_out==0) ? error : error+1;
        #10;
        d1=dout;
        // $display("dout = %b, valid_out = %b", dout, valid_out);
        error = (dout == d[1] && valid_out==0) ? error : error+1;
        #10;
        d0=dout;
        // $display("dout = %b, valid_out = %b", dout, valid_out);
        error = (dout == d[0] && valid_out==0) ? error : error+1;
        #10;
        // $display("dout = %b, valid_out = %b", dout, valid_out);
        error = (valid_out==1) ? error : error+1;
        #10;
        failcase = (error==0)? failcase :failcase+1;
        if(failcase!=0)begin
          $display("This is testbench: expected_result=4'b%b, but the result is data_out=4'b%b; please fix the error",num[i],{d3,d2,d1,d0});
          $finish;
        end 

    end
    if(failcase==0) begin
      $display("===========Your Design Passed===========");
    end
    else begin
      $display("===========Test completed with %d /40 failures===========", failcase);
    end
    $finish; 
  end
  initial begin
num[0] = 4'b1010;
num[1] = 4'b1111;
num[2] = 4'b1000;
num[3] = 4'b0100;
num[4] = 4'b0000;
num[5] = 4'b0100;
num[6] = 4'b0010;
num[7] = 4'b0101;
num[8] = 4'b1111;
num[9] = 4'b0011;
num[10] = 4'b1111;
num[11] = 4'b1111;
num[12] = 4'b1100;
num[13] = 4'b0100;
num[14] = 4'b1010;
num[15] = 4'b0101;
num[16] = 4'b1001;
num[17] = 4'b1100;
num[18] = 4'b1110;
num[19] = 4'b1011;
num[20] = 4'b1111;
num[21] = 4'b0101;
num[22] = 4'b1100;
num[23] = 4'b0000;
num[24] = 4'b0000;
num[25] = 4'b0010;
num[26] = 4'b0100;
num[27] = 4'b1110;
num[28] = 4'b1011;
num[29] = 4'b0111;
num[30] = 4'b0110;
num[31] = 4'b0010;
num[32] = 4'b1011;
num[33] = 4'b0110;
num[34] = 4'b1110;
num[35] = 4'b0111;
num[36] = 4'b1001;
num[37] = 4'b1001;
num[38] = 4'b0010;
num[39] = 4'b1010;
  
  end
endmodule

