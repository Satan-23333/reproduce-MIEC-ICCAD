`timescale 1ns/1ns
module right_shifter_tb;
  reg clk;
  reg d;
  wire [7:0] q;

  // Instantiate the DUT (Design Under Test)
  verified_right_shifter dut (
    .clk(clk),
    .d(d),
    .q(q)
  );

  // Generate clock
  always #5 clk = ~clk;
  integer i;
  integer error=0;
  reg [7:0]org;
  reg [7:0]num[0:39];
  reg num_d[0:39];


  initial begin
    // Initialize inputs
    clk = 0;
    d = org[0];
    #20;
    d = org[1];
    #10;
    d = org[2];
    #10;
    d = org[3];
    #10;
    d = org[4];
    #10;
    d = org[5];
    #10;
    d = org[6];
    #10;
    d = org[7];
    #10;
    error = (q == org) ?error:error+1;
    for(i=0;i<40;i=i+1)begin
      d=num_d[i];
      #10
      error = (q == num[i]) ?error:error+1;
    end
    // Check the output
    if(error==0) begin
      $display("===========Your Design Passed===========");
    end
    else begin
      $display("===========Failed===========");
    end
    // Finish simulation
    $finish;
  end
initial begin
org = 8'b10010010;
num_d[0] = 1'b0;
num[0] = 8'b01001001;
num_d[1] = 1'b1;
num[1] = 8'b10100100;
num_d[2] = 1'b0;
num[2] = 8'b01010010;
num_d[3] = 1'b1;
num[3] = 8'b10101001;
num_d[4] = 1'b1;
num[4] = 8'b11010100;
num_d[5] = 1'b1;
num[5] = 8'b11101010;
num_d[6] = 1'b1;
num[6] = 8'b11110101;
num_d[7] = 1'b1;
num[7] = 8'b11111010;
num_d[8] = 1'b0;
num[8] = 8'b01111101;
num_d[9] = 1'b0;
num[9] = 8'b00111110;
num_d[10] = 1'b0;
num[10] = 8'b00011111;
num_d[11] = 1'b1;
num[11] = 8'b10001111;
num_d[12] = 1'b0;
num[12] = 8'b01000111;
num_d[13] = 1'b1;
num[13] = 8'b10100011;
num_d[14] = 1'b1;
num[14] = 8'b11010001;
num_d[15] = 1'b0;
num[15] = 8'b01101000;
num_d[16] = 1'b1;
num[16] = 8'b10110100;
num_d[17] = 1'b0;
num[17] = 8'b01011010;
num_d[18] = 1'b0;
num[18] = 8'b00101101;
num_d[19] = 1'b0;
num[19] = 8'b00010110;
num_d[20] = 1'b0;
num[20] = 8'b00001011;
num_d[21] = 1'b1;
num[21] = 8'b10000101;
num_d[22] = 1'b1;
num[22] = 8'b11000010;
num_d[23] = 1'b1;
num[23] = 8'b11100001;
num_d[24] = 1'b0;
num[24] = 8'b01110000;
num_d[25] = 1'b1;
num[25] = 8'b10111000;
num_d[26] = 1'b0;
num[26] = 8'b01011100;
num_d[27] = 1'b0;
num[27] = 8'b00101110;
num_d[28] = 1'b1;
num[28] = 8'b10010111;
num_d[29] = 1'b1;
num[29] = 8'b11001011;
num_d[30] = 1'b1;
num[30] = 8'b11100101;
num_d[31] = 1'b1;
num[31] = 8'b11110010;
num_d[32] = 1'b0;
num[32] = 8'b01111001;
num_d[33] = 1'b1;
num[33] = 8'b10111100;
num_d[34] = 1'b0;
num[34] = 8'b01011110;
num_d[35] = 1'b1;
num[35] = 8'b10101111;
num_d[36] = 1'b1;
num[36] = 8'b11010111;
num_d[37] = 1'b0;
num[37] = 8'b01101011;
num_d[38] = 1'b1;
num[38] = 8'b10110101;
num_d[39] = 1'b0;
num[39] = 8'b01011010;


end
endmodule
