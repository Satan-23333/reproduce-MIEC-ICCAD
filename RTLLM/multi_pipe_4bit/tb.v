`timescale 1ns/1ns

module multi_pipe_tb;
  reg clk;
  reg rst_n;
  reg [3:0] mul_a;
  reg [3:0] mul_b;
  wire [7:0] mul_out;

  // Instantiate the DUT (Design Under Test)
  verified_multi_pipe #(.size(4)) dut (
    .clk(clk),
    .rst_n(rst_n),
    .mul_a(mul_a),
    .mul_b(mul_b),
    .mul_out(mul_out)
  );
  reg [3:0]num_a[0:39];
  reg [3:0]num_b[0:39];
  reg [7:0]result[0:39];

  // Generate clock
  always #5 clk = ~clk;

  integer fail_count =0;
  integer i=0;
  initial begin
    // Initialize inputs
    clk = 0;
    rst_n = 0;
    mul_a = 4'b0;
    mul_b = 4'b0;

    // Wait for a few clock cycles for reset to settle
    #10;

    // Apply reset
    rst_n = 1;
  
    // Perform test case
    for (i = 0; i < 40; i = i + 1) begin
      mul_a =  num_a[i];
      mul_b =  num_b[i];
      // without pipeline

      #20;  //如果有问题改这里

      fail_count = (result[i] == mul_out)? fail_count:fail_count+1;
    end

    if (fail_count == 0) begin
        $display("===========Your Design Passed===========");
    end
    else begin
    $display("===========Test completed with %d / 100 failures===========", fail_count);
    end
    $finish;
  end

  initial begin
num_a[0] = 4'H2;
num_b[0] = 4'H0;
result[0] = 8'H00;
num_a[1] = 4'HD;
num_b[1] = 4'H2;
result[1] = 8'H1A;
num_a[2] = 4'HF;
num_b[2] = 4'HF;
result[2] = 8'HE1;
num_a[3] = 4'HA;
num_b[3] = 4'H0;
result[3] = 8'H00;
num_a[4] = 4'HB;
num_b[4] = 4'H9;
result[4] = 8'H63;
num_a[5] = 4'HF;
num_b[5] = 4'H6;
result[5] = 8'H5A;
num_a[6] = 4'H8;
num_b[6] = 4'HF;
result[6] = 8'H78;
num_a[7] = 4'H3;
num_b[7] = 4'H1;
result[7] = 8'H03;
num_a[8] = 4'H0;
num_b[8] = 4'H5;
result[8] = 8'H00;
num_a[9] = 4'H7;
num_b[9] = 4'H1;
result[9] = 8'H07;
num_a[10] = 4'H7;
num_b[10] = 4'H9;
result[10] = 8'H3F;
num_a[11] = 4'H4;
num_b[11] = 4'HA;
result[11] = 8'H28;
num_a[12] = 4'H6;
num_b[12] = 4'HF;
result[12] = 8'H5A;
num_a[13] = 4'H4;
num_b[13] = 4'H9;
result[13] = 8'H24;
num_a[14] = 4'H3;
num_b[14] = 4'HC;
result[14] = 8'H24;
num_a[15] = 4'H5;
num_b[15] = 4'H2;
result[15] = 8'H0A;
num_a[16] = 4'HC;
num_b[16] = 4'HE;
result[16] = 8'HA8;
num_a[17] = 4'HA;
num_b[17] = 4'HC;
result[17] = 8'H78;
num_a[18] = 4'H5;
num_b[18] = 4'HF;
result[18] = 8'H4B;
num_a[19] = 4'H1;
num_b[19] = 4'HB;
result[19] = 8'H0B;
num_a[20] = 4'H2;
num_b[20] = 4'H8;
result[20] = 8'H10;
num_a[21] = 4'HA;
num_b[21] = 4'HB;
result[21] = 8'H6E;
num_a[22] = 4'H0;
num_b[22] = 4'H0;
result[22] = 8'H00;
num_a[23] = 4'H6;
num_b[23] = 4'HF;
result[23] = 8'H5A;
num_a[24] = 4'HE;
num_b[24] = 4'HE;
result[24] = 8'HC4;
num_a[25] = 4'HD;
num_b[25] = 4'HF;
result[25] = 8'HC3;
num_a[26] = 4'HD;
num_b[26] = 4'HA;
result[26] = 8'H82;
num_a[27] = 4'H5;
num_b[27] = 4'HF;
result[27] = 8'H4B;
num_a[28] = 4'H1;
num_b[28] = 4'H9;
result[28] = 8'H09;
num_a[29] = 4'H7;
num_b[29] = 4'HC;
result[29] = 8'H54;
num_a[30] = 4'H1;
num_b[30] = 4'H7;
result[30] = 8'H07;
num_a[31] = 4'HA;
num_b[31] = 4'H4;
result[31] = 8'H28;
num_a[32] = 4'HA;
num_b[32] = 4'HB;
result[32] = 8'H6E;
num_a[33] = 4'HB;
num_b[33] = 4'H0;
result[33] = 8'H00;
num_a[34] = 4'H9;
num_b[34] = 4'H4;
result[34] = 8'H24;
num_a[35] = 4'H8;
num_b[35] = 4'HA;
result[35] = 8'H50;
num_a[36] = 4'HD;
num_b[36] = 4'H5;
result[36] = 8'H41;
num_a[37] = 4'HD;
num_b[37] = 4'H1;
result[37] = 8'H0D;
num_a[38] = 4'H5;
num_b[38] = 4'HF;
result[38] = 8'H4B;
num_a[39] = 4'H9;
num_b[39] = 4'HD;
result[39] = 8'H75;
 
  end
endmodule