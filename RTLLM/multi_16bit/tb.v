module tb_multi_16bit;
  
  reg clk;
  reg rst_n;
  reg start;
  reg [15:0] ain;
  reg [15:0] bin;
  wire [31:0] yout;
  wire done;

  integer i; // Declare the loop variable here
  integer fail_count = 0; // Declare a variable to count the failures
  integer timeout; // Declare a timeout counter here

  // Instantiate the module
  verified_multi_16bit uut (
    .clk(clk), 
    .rst_n(rst_n),
    .start(start),
    .ain(ain), 
    .bin(bin), 
    .yout(yout),
    .done(done)
  );
  
  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  reg [15:0]num_a[0:39];
  reg [15:0]num_b[0:39];
  reg [31:0]result[0:39];

  // Randomize inputs and check output
  initial begin
    clk = 0; // Initialize clock
    rst_n = 1; // De-assert reset
    start = 0; // Initialize start

    // Perform reset
    rst_n = 0;
    for (i = 0; i < 40; i = i + 1) begin
      #100;
      rst_n = 1;
      #50;
      ain = num_a[i];
      bin = num_b[i];
      #50;
      start = 1; // Start the operation
      while(done !== 1) begin
        #10;
      end
      
      
      if (done == 1) begin
        fail_count = (yout == result[i])? fail_count:fail_count+1;
      end
      start = 0; // Stop the operation
      rst_n = 0;
      #100;
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
    #50000;
    $finish;
  end

  initial begin
num_a[0] = 16'H8940;
num_b[0] = 16'H8995;
result[0] = 32'H49C32240;
num_a[1] = 16'H70C8;
num_b[1] = 16'H58F5;
result[1] = 32'H2730AF68;
num_a[2] = 16'H0A72;
num_b[2] = 16'HAA5C;
result[2] = 32'H06F374F8;
num_a[3] = 16'H5D38;
num_b[3] = 16'H777F;
result[3] = 32'H2B8346C8;
num_a[4] = 16'H015D;
num_b[4] = 16'H2D4F;
result[4] = 32'H003DC4B3;
num_a[5] = 16'HE0E7;
num_b[5] = 16'HD8EE;
result[5] = 32'HBE93FEC2;
num_a[6] = 16'H1E6F;
num_b[6] = 16'HBCE9;
result[6] = 32'H16753707;
num_a[7] = 16'HA3DD;
num_b[7] = 16'H18E8;
result[7] = 32'H0FF13848;
num_a[8] = 16'H8314;
num_b[8] = 16'H5BE0;
result[8] = 32'H2F0ACD80;
num_a[9] = 16'HC08C;
num_b[9] = 16'H58AF;
result[9] = 32'H42B3BFB4;
num_a[10] = 16'H75C7;
num_b[10] = 16'HB287;
result[10] = 32'H522279F1;
num_a[11] = 16'H5966;
num_b[11] = 16'HC02E;
result[11] = 32'H431C9054;
num_a[12] = 16'H458C;
num_b[12] = 16'H20E3;
result[12] = 32'H08EF2B24;
num_a[13] = 16'H0847;
num_b[13] = 16'H948D;
result[13] = 32'H04CD9B1B;
num_a[14] = 16'HB18F;
num_b[14] = 16'H59F1;
result[14] = 32'H3E61DE9F;
num_a[15] = 16'H0D1E;
num_b[15] = 16'HE2DB;
result[15] = 32'H0B9FB4AA;
num_a[16] = 16'H0A4B;
num_b[16] = 16'HF43B;
result[16] = 32'H09D1DB49;
num_a[17] = 16'H2B04;
num_b[17] = 16'H17B9;
result[17] = 32'H03FC71E4;
num_a[18] = 16'H7CD1;
num_b[18] = 16'H280D;
result[18] = 32'H1386FE9D;
num_a[19] = 16'H7740;
num_b[19] = 16'H1135;
result[19] = 32'H0803F040;
num_a[20] = 16'HE826;
num_b[20] = 16'HE263;
result[20] = 32'HCD4B52B2;
num_a[21] = 16'HC111;
num_b[21] = 16'H2DD4;
result[21] = 32'H228FDF14;
num_a[22] = 16'HBB0D;
num_b[22] = 16'H7B04;
result[22] = 32'H59E22B34;
num_a[23] = 16'HA342;
num_b[23] = 16'H14BB;
result[23] = 32'H0D386936;
num_a[24] = 16'H516A;
num_b[24] = 16'H0292;
result[24] = 32'H00D14274;
num_a[25] = 16'HD6AC;
num_b[25] = 16'H12C3;
result[25] = 32'H0FBB9D04;
num_a[26] = 16'H52E8;
num_b[26] = 16'H6B38;
result[26] = 32'H22B91AC0;
num_a[27] = 16'H8F53;
num_b[27] = 16'HD892;
result[27] = 32'H793FC556;
num_a[28] = 16'H7ACE;
num_b[28] = 16'H7A10;
result[28] = 32'H3A8DD8E0;
num_a[29] = 16'H2DDB;
num_b[29] = 16'H1597;
result[29] = 32'H03DE032D;
num_a[30] = 16'H5A2A;
num_b[30] = 16'HEF80;
result[30] = 32'H545A4B00;
num_a[31] = 16'HC8EE;
num_b[31] = 16'HEFD2;
result[31] = 32'HBC3B053C;
num_a[32] = 16'H6C17;
num_b[32] = 16'HFEEC;
result[32] = 32'H6BA27734;
num_a[33] = 16'HDAD3;
num_b[33] = 16'H48BA;
result[33] = 32'H3E2A554E;
num_a[34] = 16'HBE66;
num_b[34] = 16'H42D9;
result[34] = 32'H31B7B076;
num_a[35] = 16'H255B;
num_b[35] = 16'H65D8;
result[35] = 32'H0EDC6BC8;
num_a[36] = 16'HB0C3;
num_b[36] = 16'H125D;
result[36] = 32'H0CADECD7;
num_a[37] = 16'H7BCF;
num_b[37] = 16'HD12E;
result[37] = 32'H652A3E32;
num_a[38] = 16'H6C29;
num_b[38] = 16'H92AF;
result[38] = 32'H3DF95207;
num_a[39] = 16'H38E5;
num_b[39] = 16'H3147;
result[39] = 32'H0AF39C83;
  
  end

endmodule